//
//  GameMenuMoveUnitView.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameMenuMoveUnitViewDelegate;

@interface GameMenuMoveUnitView : UIView

// localization job is done in this method
- (void)configureMoveUnitWithSID:(NSInteger)SID
                              pp:(NSString *)pp
                        delegate:(id <GameMenuMoveUnitViewDelegate>)delegate
                             tag:(NSInteger)tag;
- (void)setButtonEnabled:(BOOL)enabled;
- (void)setButtonSelected:(BOOL)selected;

@end


// Delegate

@protocol GameMenuMoveUnitViewDelegate <NSObject>

- (void)showDetail:(id)sender;

@end
