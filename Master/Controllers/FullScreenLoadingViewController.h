//
//  FullScreenLoadingViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 4/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenLoadingViewController : UIViewController

- (void)loadViewForError:(PMError)error animated:(BOOL)animated;
- (void)unloadViewAnimated:(BOOL)animated;

@end
