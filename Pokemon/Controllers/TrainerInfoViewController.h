//
//  TrainerInfoViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainerInfoViewController : UIViewController <NSFetchedResultsControllerDelegate>
{
  NSFetchedResultsController * fetchedResultsController_;
}

@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsController;

@end
