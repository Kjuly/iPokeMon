//
//  FeedbackViewController.h
//  iPokemon
//
//  Created by Kaijie Yu on 4/28/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedbackViewControllerDelegate <NSObject>

- (void)cancelFeedbackView;

@end

@interface FeedbackViewController : UIViewController <UITextFieldDelegate> {
  id <FeedbackViewControllerDelegate> delegate_;
}

@property (nonatomic, assign) id <FeedbackViewControllerDelegate> delegate;

@end
