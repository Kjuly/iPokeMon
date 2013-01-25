//
//  ResourceManageViewController.m
//  iPokeMon
//
//  Created by Kjuly on 1/25/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import "ResourceManageViewController.h"

@interface ResourceManageViewController ()

@end

@implementation ResourceManageViewController

- (id)init {
  self = [super init];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)loadView {
  UIView * view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, kViewWidth, kViewHeight}];
  [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
  self.view = view;
  [view release];
}

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
