//
//  KeychainWrapper.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/23/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "KeychainWrapper.h"

//Unique string used to identify the keychain item:
static const UInt8 kKeychainItemIdentifier[] = "com.kjuly.pm.KeychainUI\0";

@interface KeychainWrapper ()

// The following two methods translate dictionaries between the format used by
// the view controller (NSString *) and the Keychain Services API:
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;
// Method used to write data to the keychain:
- (void)writeToKeychain;

@end


@implementation KeychainWrapper

@synthesize keychainData         = keychainData_;
@synthesize genericPasswordQuery = genericPasswordQuery_;

- (void)dealloc
{
  [keychainData_         release];
  [genericPasswordQuery_ release];
  [super dealloc];
}

- (id)init
{
  if ((self = [super init])) {
    OSStatus keychainErr = noErr;
    // Set up the keychain search dictionary:
    genericPasswordQuery_ = [[NSMutableDictionary alloc] init];
    // This keychain item is a generic password.
    [genericPasswordQuery_ setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    // The kSecAttrGeneric attribute is used to store a unique string that is used
    // to easily identify and find this keychain item. The string is first
    // converted to an NSData object:
    NSData * keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier
                                             length:strlen((const char *)kKeychainItemIdentifier)];
    [genericPasswordQuery_ setObject:keychainItemID forKey:(id)kSecAttrGeneric];
    // Return the attributes of the first match only:
    [genericPasswordQuery_ setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    // Return the attributes of the keychain item (the password is
    //  acquired in the secItemFormatToDictionary: method):
    [genericPasswordQuery_ setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    
    //Initialize the dictionary used to hold return data from the keychain:
    NSMutableDictionary * outDictionary = nil;
    // If the keychain item exists, return the attributes of the item: 
    keychainErr = SecItemCopyMatching((CFDictionaryRef)genericPasswordQuery_, (CFTypeRef *)&outDictionary);
    if (keychainErr == noErr) {
      // Convert the data dictionary into the format used by the view controller:
      self.keychainData = [self secItemFormatToDictionary:outDictionary];
    } else if (keychainErr == errSecItemNotFound) {
      // Put default values into the keychain if no matching
      // keychain item is found:
      [self resetKeychainItem];
    } else {
      // Any other error is unexpected.
      NSAssert(NO, @"Serious error.\n");
    }
    [outDictionary release];
  }
  return self;
}

// Implement the mySetObject:forKey method, which writes attributes to the keychain:
- (void)setKeychainObject:(id)inObject forKey:(id)key
{
  if (inObject == nil) return;
  id currentObject = [keychainData_ objectForKey:key];
  if (! [currentObject isEqual:inObject]) {
    [keychainData_ setObject:inObject forKey:key];
    [self writeToKeychain];
  }
}

// Implement the myObjectForKey: method, which reads an attribute value from a dictionary:
- (id)keychainObjectForKey:(id)key {
  return [keychainData_ objectForKey:key];
}

// Reset the values in the keychain item, or create a new item if it
// doesn't already exist:
- (void)resetKeychainItem
{
  // Allocate the keychainData dictionary if it doesn't exist yet.
  if (! keychainData_) self.keychainData = [[NSMutableDictionary alloc] init];
  else if (keychainData_) {
    // Format the data in the keychainData dictionary into the format needed for a query
    //  and put it into tmpDictionary:
    NSMutableDictionary * tmpDictionary = [self dictionaryToSecItemFormat:keychainData_];
    // Delete the keychain item in preparation for resetting the values:
    NSAssert(SecItemDelete((CFDictionaryRef)tmpDictionary) == noErr,
             @"Problem deleting current keychain item." );
  }
  
  // Default generic data for Keychain Item:
  [keychainData_ setObject:@"Item label" forKey:(id)kSecAttrLabel];
  [keychainData_ setObject:@"Item description" forKey:(id)kSecAttrDescription];
  [keychainData_ setObject:@"Account" forKey:(id)kSecAttrAccount];
  [keychainData_ setObject:@"Service" forKey:(id)kSecAttrService];
  [keychainData_ setObject:@"Your comment here." forKey:(id)kSecAttrComment];
  [keychainData_ setObject:@"password" forKey:(id)kSecValueData];
}

// Implement the dictionaryToSecItemFormat: method, which takes the attributes that
//  you want to add to the keychain item and sets up a dictionary in the format
//  needed by Keychain Services:
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert
{
  // This method must be called with a properly populated dictionary
  // containing all the right key/value pairs for a keychain item search.
  
  // Create the return dictionary:
  NSMutableDictionary * returnDictionary =
  [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
  
  // Add the keychain item class and the generic attribute:
  NSData * keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier
                                           length:strlen((const char *)kKeychainItemIdentifier)];
  [returnDictionary setObject:keychainItemID forKey:(id)kSecAttrGeneric];
  [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
  
  // Convert the password NSString to NSData to fit the API paradigm:
  NSString * passwordString = [dictionaryToConvert objectForKey:(id)kSecValueData];
  [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding]
                       forKey:(id)kSecValueData];
  return returnDictionary;
}

// Implement the secItemFormatToDictionary: method, which takes the attribute dictionary
//  obtained from the keychain item, acquires the password from the keychain, and
//  adds it to the attribute dictionary:
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
{
  // This method must be called with a properly populated dictionary
  // containing all the right key/value pairs for the keychain item.
  
  // Create a return dictionary populated with the attributes:
  NSMutableDictionary * returnDictionary =
  [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
  
  // To acquire the password data from the keychain item,
  // first add the search key and class attribute required to obtain the password:
  [returnDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
  [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
  // Then call Keychain Services to get the password:
  NSData * passwordData = NULL;
  OSStatus keychainError = noErr;
  keychainError = SecItemCopyMatching((CFDictionaryRef)returnDictionary, (CFTypeRef *)&passwordData);
  if (keychainError == noErr) {
    // Remove the kSecReturnData key; we don't need it anymore:
    [returnDictionary removeObjectForKey:(id)kSecReturnData];
    
    // Convert the password to an NSString and add it to the return dictionary:
    NSString * password = [[[NSString alloc] initWithBytes:[passwordData bytes]
                                                    length:[passwordData length] encoding:NSUTF8StringEncoding] autorelease];
    [returnDictionary setObject:password forKey:(id)kSecValueData];
  }
  // Don't do anything if nothing is found.
  else if (keychainError == errSecItemNotFound) {
    NSAssert(NO, @"Nothing was found in the keychain.\n");
  }
  // Any other error is unexpected.
  else NSAssert(NO, @"Serious error.\n");
  
  [passwordData release];
  return returnDictionary;
}

// Implement the writeToKeychain method, which is called by the mySetObject routine,
//  which in turn is called by the UI when there is new data for the keychain. This
//  method modifies an existing keychain item, or--if the item does not already
//  exist--creates a new keychain item with the new attribute value plus
//  default values for the other attributes.
- (void)writeToKeychain
{
  NSDictionary * attributes = NULL;
  NSMutableDictionary * updateItem = NULL;
  
  // If the keychain item already exists, modify it:
  if (SecItemCopyMatching((CFDictionaryRef)genericPasswordQuery_,
                          (CFTypeRef *)&attributes) == noErr)
  {
    // First, get the attributes returned from the keychain and add them to the
    // dictionary that controls the update:
    updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
    
    // Second, get the class value from the generic password query dictionary and
    // add it to the updateItem dictionary:
    [updateItem setObject:[genericPasswordQuery_ objectForKey:(id)kSecClass]
                   forKey:(id)kSecClass];
    
    // Finally, set up the dictionary that contains new values for the attributes:
    NSMutableDictionary * tempCheck = [self dictionaryToSecItemFormat:keychainData_];
    //Remove the class--it's not a keychain attribute:
    [tempCheck removeObjectForKey:(id)kSecClass];
    
    // You can update only a single keychain item at a time.
    NSAssert(SecItemUpdate((CFDictionaryRef)updateItem,
                           (CFDictionaryRef)tempCheck) == noErr,
             @"Couldn't update the Keychain Item.");
  }
  else {
    // No previous item found; add the new item.
    // The new value was added to the keychainData dictionary in the mySetObject routine,
    //  and the other values were added to the keychainData dictionary previously.
    
    // No pointer to the newly-added items is needed, so pass NULL for the second parameter:
    NSAssert(SecItemAdd((CFDictionaryRef)[self dictionaryToSecItemFormat:keychainData_],
                        NULL) == noErr, @"Couldn't add the Keychain Item." );
  }
}

@end
