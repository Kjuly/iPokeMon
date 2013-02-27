//
//  GameMenuBagViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuAbstractChildViewController.h"

@interface GameMenuBagViewController : GameMenuAbstractChildViewController {
  BOOL isSelectedItemViewOpening_;
}

@property (nonatomic, assign) BOOL isSelectedItemViewOpening;

- (void)unloadSelcetedItemTalbeView:(id)sender;

@end
