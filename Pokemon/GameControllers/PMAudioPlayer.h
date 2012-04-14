//
//  GameAudioPlayer.h
//  Pokemon
//
//  Created by Kaijie Yu on 4/14/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface PMAudioPlayer : NSObject

+ (PMAudioPlayer *)sharedInstance;

@end
