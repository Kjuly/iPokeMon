//
//  SixPokemonsTableViewCell.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsTableViewCell.h"

#import <QuartzCore/QuartzCore.h>

#import "GlobalColor.h"

@implementation SixPokemonsTableViewCell

@synthesize imageView   = imageView_;
@synthesize nameLabel   = nameLabel_;
@synthesize genderLabel = genderLabel_;
@synthesize levelLabel  = levelLabel_;
@synthesize HPLabel     = HPLabel_;
@synthesize HPBarTotal  = HPBarTotal_;
@synthesize HPBarLeft   = HPBarLeft_;

- (void)dealloc
{
  [imageView_   release];
  [nameLabel_   release];
  [genderLabel_ release];
  [levelLabel_  release];
  [HPLabel_     release];
  [HPBarTotal_  release];
  [HPBarLeft_   release];
  
  self.imageView   = nil;
  self.nameLabel   = nil;
  self.genderLabel = nil;
  self.levelLabel  = nil;
  self.HPLabel     = nil;
  self.HPBarTotal  = nil;
  self.HPBarLeft   = nil;
  
  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight       = 70.0f;
    CGFloat const cellWidth        = 320.0f;
    CGFloat const imageWidth       = 60.0f; 
    CGFloat const labelHeight      = 30.0f;
    CGFloat const nameLabelWidth   = 100.0f;
    CGFloat const genderLabelWidth = 30.0f;
    CGFloat const levelLabelWidth  = 40.0f;
    CGFloat const HPLabelWidth     = 70.0f;
    
    CGRect dataViewFrame    = CGRectMake(imageWidth + 20.0f, 5.0f, cellWidth - imageWidth - 40.0f, cellHeight - 10.0f);
    CGRect nameLabelFrame   = CGRectMake(0.0f, 0.0f, nameLabelWidth, labelHeight);
    CGRect genderLabelFrame = CGRectMake(dataViewFrame.size.width - levelLabelWidth - genderLabelWidth, 0.0f, genderLabelWidth, labelHeight);
    CGRect levelLabelFrame  = CGRectMake(dataViewFrame.size.width - levelLabelWidth, 0.0f, levelLabelWidth, labelHeight);
    CGRect HPBarFrame       = CGRectMake(0.0f, labelHeight, 150.0f, 16.0f);
    CGRect HPLabelFrame     = CGRectMake(HPBarFrame.size.width, labelHeight, HPLabelWidth, 16.0f);
    
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cellWidth, cellHeight)];
    [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PokedexTableViewCellBackground.png"]]];
    [self setBackgroundView:backgroundView];
    [backgroundView release];
    
    // Set |selectedBackgroundView|
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cellWidth, cellHeight)];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    [self setSelectedBackgroundView:selectedBackgroundView];
    [selectedBackgroundView release];
    
    
    // Set Layouts for |contentView|(readonly)
    // Image View
    imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, imageWidth, imageWidth)];
    [imageView_ setUserInteractionEnabled:YES];
    [self.contentView addSubview:imageView_];
    
    
    ///Data View
    UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
    [dataView setBackgroundColor:[UIColor clearColor]];
    
    // Name Label
    nameLabel_ = [[UILabel alloc] initWithFrame:nameLabelFrame];
    [nameLabel_ setBackgroundColor:[UIColor clearColor]];
    [nameLabel_ setTextColor:[GlobalColor textColorOrange]];
    [nameLabel_ setTextAlignment:UITextAlignmentLeft];
    [nameLabel_ setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0f]];
    [dataView addSubview:nameLabel_];
    
    // Gender Label
    genderLabel_ = [[UILabel alloc] initWithFrame:genderLabelFrame];
    [genderLabel_ setBackgroundColor:[UIColor clearColor]];
    [genderLabel_ setTextColor:[GlobalColor textColorBlue]];
    [genderLabel_ setTextAlignment:UITextAlignmentLeft];
    [genderLabel_ setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16.0f]];
    [dataView addSubview:genderLabel_];
    
    // Level Label
    levelLabel_ = [[UILabel alloc] initWithFrame:levelLabelFrame];
    [levelLabel_ setBackgroundColor:[UIColor clearColor]];
    [levelLabel_ setTextColor:[GlobalColor textColorBlue]];
    [levelLabel_ setTextAlignment:UITextAlignmentRight];
    [levelLabel_ setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.0f]];
    [dataView addSubview:levelLabel_];
    
    // HP Bar
    HPBarTotal_ = [[UIView alloc] initWithFrame:HPBarFrame];
    [HPBarTotal_ setBackgroundColor:[GlobalColor textColorBlue]];
    [HPBarTotal_.layer setCornerRadius:5.0f];
    // HP Bar Left Part
    HPBarLeft_ = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, HPBarFrame.size.height)];
    [HPBarLeft_ setBackgroundColor:[GlobalColor textColorOrange]];
    [HPBarLeft_.layer setCornerRadius:5.0f];
    [HPBarTotal_ addSubview:HPBarLeft_];
    [dataView addSubview:HPBarTotal_];
    
    // HP Label
    HPLabel_ = [[UILabel alloc] initWithFrame:HPLabelFrame];
    [HPLabel_ setBackgroundColor:[UIColor clearColor]];
    [HPLabel_ setTextColor:[GlobalColor textColorOrange]];
    [HPLabel_ setTextAlignment:UITextAlignmentRight];
    [HPLabel_ setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.0f]];
    [HPLabel_ setTextColor:[UIColor grayColor]];
    [dataView addSubview:HPLabel_];
    
    [self.contentView addSubview:dataView];
    [dataView release];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

@end
