//
//  MoveDetailRoundView.h
//  iPokeMon
//
//  Created by Kaijie Yu on 5/20/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveDetailRoundView : UIView

- (void)configureMoveDetailWithName:(NSString *)name
                               type:(NSString *)type
                                 pp:(NSString *)pp
                        description:(NSString *)description;
- (void)setContentHidden:(BOOL)hidden;

@end
