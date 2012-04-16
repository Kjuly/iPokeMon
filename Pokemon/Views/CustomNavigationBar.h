//
//  CustomNavigationBar.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

@interface CustomNavigationBar : UINavigationBar
{
  NSInteger viewCount_;
}

@property (nonatomic, assign) NSInteger viewCount;

- (void)setup;
- (void)setTitleWithText:(NSString *)text animated:(BOOL)animated;
- (void)backToRoot:(id)sender;
- (void)setBackToRootButtonToHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)addBackButtonForPreviousView;
- (void)removeBackButtonForPreviousView;
- (void)clearBackground;

@end
