//
//  BagItemInfoViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BagItemInfoViewController : UIViewController

- (void)setDataWithName:(NSString *)name
                  price:(NSInteger)price
                   info:(NSString *)info
           duringBattle:(BOOL)duringBattle;
- (void)loadViewWithAnimation;

@end
