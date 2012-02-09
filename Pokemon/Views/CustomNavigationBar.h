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
  UIImageView * navigationBarBackgroundImage_;
  
  UIButton * backButton_;
}

@property (nonatomic, retain) IBOutlet UINavigationController * navigationController;
@property (nonatomic, retain) UIImageView * navigationBarBackgroundImage;

@property (nonatomic, retain) IBOutlet UIButton * backButton;

- (void)initNavigationBarWith:(UIImage *)backgroundImage;
- (void)setBackButtonWith:(UINavigationItem *)navigationItem;
- (void)back:(id)sender;
- (void)clearBackground;

@end
