//
//  CustomNavigationBar.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//


@protocol CustomNavigationBarDelegate;
@protocol CustomNavigationBarDataSource;


@interface CustomNavigationBar : UINavigationBar {
  id <CustomNavigationBarDelegate>   __weak delegate_;
  id <CustomNavigationBarDataSource> __weak dataSource_;
  NSInteger viewCount_;
}

@property (nonatomic, weak) id <CustomNavigationBarDelegate>   delegate;
@property (nonatomic, weak) id <CustomNavigationBarDataSource> dataSource;
@property (nonatomic, assign) NSInteger viewCount;

- (void)back:(id)sender;
- (void)backToRoot:(id)sender;
- (void)setBackToRootButtonToHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)addBackButtonForPreviousView;

@end


// Delegate
@protocol CustomNavigationBarDelegate <NSObject>

@required

// Informs the delegate that the custom navigation bar will hide or show animated
- (void)customNavigationBarWillHide:(BOOL)hide animated:(BOOL)animated;
// Informs the delegate that the custom navigation bar will back to root animated
//   dispath |popToRootViewControllerAnimated:| in |CustomNavigationController|
- (void)customNavigationBarWillBackToRootAnimated:(BOOL)animated;
// Informs the delegate that the custom navigation bar will back to previous animated
//   dispath |popViewControllerAnimated:| in |CustomNavigationController|
- (void)customNavigationBarWillBackToPreviousAnimated:(BOOL)animated;

@end


// Data Source
@protocol CustomNavigationBarDataSource <NSObject>

@required

- (id)rootViewController; // navigationController's topViewController

@end
