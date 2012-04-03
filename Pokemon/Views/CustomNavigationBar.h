//
//  CustomNavigationBar.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

@interface CustomNavigationBar : UINavigationBar
{
  UINavigationController * navigationController_;
  UIImageView            * navigationBarBackgroundImage_;
  UIButton               * backButtonToRoot_;
  UIButton               * backButton_;
  
  NSInteger viewCount_;
}

@property (nonatomic, retain) IBOutlet UINavigationController * navigationController;
@property (nonatomic, retain) UIImageView * navigationBarBackgroundImage;
@property (nonatomic, retain) UIButton    * backButtonToRoot;
@property (nonatomic, retain) UIButton    * backButton;

@property (nonatomic, assign) NSInteger viewCount;

- (void)initNavigationBarWith:(UIImage *)backgroundImage;
- (void)backToRoot:(id)sender;
- (void)setBackButtonForRoot;
- (void)addBackButtonForPreviousView;
- (void)removeBackButtonForPreviousView;
- (void)clearBackground;

@end
