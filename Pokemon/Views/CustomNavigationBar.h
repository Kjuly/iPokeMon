//
//  CustomNavigationBar.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

@protocol CustomNavigationBarDelegate <NSObject>

- (void)hideNavigationBar:(BOOL)hide animated:(BOOL)animated; // hide or not
- (id)rootViewController;                          // navigationController's topViewController
- (void)backToRootViewAnimated:(BOOL)animated;     // |popToRootViewControllerAnimated:|
- (void)backToPreviousViewAnimated:(BOOL)animated; // |popViewControllerAnimated:|

@end


@interface CustomNavigationBar : UINavigationBar {
  id <CustomNavigationBarDelegate> delegate_;
  NSInteger viewCount_;
}

@property (nonatomic, assign) id <CustomNavigationBarDelegate> delegate;
@property (nonatomic, assign) NSInteger viewCount;

- (void)setTitleWithText:(NSString *)text animated:(BOOL)animated;
- (void)removeTitleAnimated:(BOOL)animated;
- (void)backToRoot:(id)sender;
- (void)setBackToRootButtonToHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)addBackButtonForPreviousView;

@end
