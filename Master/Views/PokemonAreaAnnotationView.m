//
//  PokemonAreaAnnotationView.m
//  iPokeMon
//
//  Created by Kaijie Yu on 5/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonAreaAnnotationView.h"

#import "GlobalRender.h"

@implementation PokemonAreaAnnotationView


- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
    CGRect frame = self.frame;
    frame.size = CGSizeMake(32.f, 32.f);
    [self setFrame:frame];
    [self setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  // background
  [[UIColor colorWithWhite:0.f alpha:.8f] setFill];
  [[UIBezierPath bezierPathWithOvalInRect:rect] fill];
  
  // foreground
  [[GlobalRender colorRedWithAlpha:.9f] setFill];
  CGFloat viewSize = self.frame.size.width;
  CGFloat margin = viewSize * .1f;
  CGRect foregroundRect = rect;
  foregroundRect.origin.x    += margin;
  foregroundRect.origin.y    += margin;
  foregroundRect.size.width  -= margin * 2;
  foregroundRect.size.height -= margin * 2;
  [[UIBezierPath bezierPathWithOvalInRect:foregroundRect] fill];
}

@end
