//
//  SixPokemonsTableViewCell.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsTableViewCell.h"

#import "GlobalRender.h"

@implementation SixPokemonsTableViewCell

@synthesize imageView       = imageView_;
@synthesize nameLabel       = nameLabel_;
@synthesize genderImageView = genderImageView_;
@synthesize levelLabel      = levelLabel_;
@synthesize HPLabel         = HPLabel_;
@synthesize HPBarTotal      = HPBarTotal_;
@synthesize HPBarLeft       = HPBarLeft_;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight       = kCellHeightOfSixPokemonsTableView;
    CGFloat const cellWidth        = kViewWidth;
    CGFloat const imageWidth       = 60.f; 
    CGFloat const labelHeight      = 30.f;
    CGFloat const nameLabelWidth   = 100.f;
    CGFloat const genderLabelWidth = 30.f;
    CGFloat const levelLabelWidth  = 40.f;
    CGFloat const HPLabelWidth     = 70.f;
    
    CGRect dataViewFrame    = CGRectMake(imageWidth + 20.f, 5.f, cellWidth - imageWidth - 40.f, cellHeight - 10.f);
    CGRect nameLabelFrame   = CGRectMake(0.f, 0.f, nameLabelWidth, labelHeight);
    CGRect genderImageViewFrame = CGRectMake(dataViewFrame.size.width - levelLabelWidth - genderLabelWidth, 0.f, genderLabelWidth, labelHeight);
    CGRect levelLabelFrame  = CGRectMake(dataViewFrame.size.width - levelLabelWidth, 0.f, levelLabelWidth, labelHeight);
    CGRect HPBarFrame       = CGRectMake(0.f, labelHeight + 2.f, 160.f, 13.f);
    CGRect HPLabelFrame     = CGRectMake(HPBarFrame.size.width, labelHeight, HPLabelWidth, 16.f);
    
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [backgroundView setBackgroundColor:
      [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTableViewCellPokedex]]];
    [backgroundView setOpaque:NO];
    [self setBackgroundView:backgroundView];
    
    // Set |selectedBackgroundView|
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    [self setSelectedBackgroundView:selectedBackgroundView];
    
    /*/ Set editing view
    UIView * editingView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, cellHeight)];
    [editingView setBackgroundColor:[UIColor whiteColor]];
    [self setEditingAccessoryView:editingView];
    [editingView release];
    
    [self setShouldIndentWhileEditing:NO];
    [self setShowsReorderControl:NO];
    [self setEditingAccessoryType:UITableViewCellAccessoryNone];
    [self setAccessoryType:UITableViewCellAccessoryNone];*/
    
    
    // Set Layouts for |contentView|(readonly)
    // Image View
    imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, 5.f, imageWidth, imageWidth)];
    [imageView_ setUserInteractionEnabled:YES];
    [self addSubview:imageView_];
    
    ///Data View
    UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
    [dataView setBackgroundColor:[UIColor clearColor]];
    
    // Name Label
    nameLabel_ = [[UILabel alloc] initWithFrame:nameLabelFrame];
    [nameLabel_ setBackgroundColor:[UIColor clearColor]];
    [nameLabel_ setTextColor:[GlobalRender textColorOrange]];
    [nameLabel_ setTextAlignment:NSTextAlignmentLeft];
    [nameLabel_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
    [dataView addSubview:nameLabel_];
    
    // Gender Label
    genderImageView_ = [[UIImageView alloc] initWithFrame:genderImageViewFrame];
    [genderImageView_ setBackgroundColor:[UIColor clearColor]];
    [dataView addSubview:genderImageView_];
    
    // Level Label
    levelLabel_ = [[UILabel alloc] initWithFrame:levelLabelFrame];
    [levelLabel_ setBackgroundColor:[UIColor clearColor]];
    [levelLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
    [levelLabel_ setTextAlignment:NSTextAlignmentRight];
    [levelLabel_ setFont:[GlobalRender textFontBoldItalicInSizeOf:14.f]];
    [dataView addSubview:levelLabel_];
    
    // HP Bar
    HPBarTotal_ = [[UIImageView alloc] initWithFrame:HPBarFrame];
    [HPBarTotal_ setImage:[UIImage imageNamed:kPMINPMHPBarBackground]];
    // HP Bar Left Part
    HPBarLeft_ = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, HPBarFrame.size.height)];
    [HPBarLeft_ setImage:[UIImage imageNamed:kPMINPMHPBar]];
    [HPBarTotal_ addSubview:HPBarLeft_];
    [dataView addSubview:HPBarTotal_];
    
    // HP Label
    HPLabel_ = [[UILabel alloc] initWithFrame:HPLabelFrame];
    [HPLabel_ setBackgroundColor:[UIColor clearColor]];
    [HPLabel_ setTextAlignment:NSTextAlignmentRight];
    [HPLabel_ setFont:[GlobalRender textFontBoldItalicInSizeOf:16.f]];
    [HPLabel_ setTextColor:[GlobalRender textColorOrange]];
    [dataView addSubview:HPLabel_];
    
    [self addSubview:dataView];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
//  [self.HPBarTotal setBackgroundColor:[GlobalRender textColorTitleWhite]];
//  [self.HPBarLeft setBackgroundColor:[GlobalRender textColorOrange]];
}

/*
- (void)layoutSubviews {
  [super layoutSubviews];
//  if ([self isEditing]) {
    // Set editing view
//    UIView * editingView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, kCellHeightOfSixPokemonsTableView)];
//    [editingView setBackgroundColor:[UIColor whiteColor]];
////    [self setEditingAccessoryView:editingView];
//    [self.contentView addSubview:editingView];
//    [editingView release];
//  }
}
 */

@end
