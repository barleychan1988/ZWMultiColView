//
//  UIView+AddLine.m
//  ZWMultiTbv
//
//  Created by chenzhengwang on 13-12-6.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

#import "UIView+AddLine.h"

@implementation UIView(AddLine)

- (UIView *)addTopLineWithWidth:(CGFloat)width color:(UIColor *)color
{
    UIView *viewTopLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, width)];
    
    viewTopLine.backgroundColor = color;
    viewTopLine.autoresizingMask = UIViewAutoresizingFlexibleWidth/* | UIViewAutoresizingFlexibleTopMargin*/;
    
    [self addSubview:viewTopLine];
    return viewTopLine;
}

- (UIView *)addBottomLineWithWidth:(CGFloat)width color:(UIColor *)color
{
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - width, self.frame.size.width, width)];
    
    bottomLine.backgroundColor = color;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth/* | UIViewAutoresizingFlexibleTopMargin*/;
    
    [self addSubview:bottomLine];
    return bottomLine;
}

- (UIView *)addVerticalLineWithWidth:(CGFloat)width color:(UIColor *)color atX:(CGFloat)x
{
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(x, 0.0f, width, self.frame.size.height)];
    vLine.backgroundColor = color;
    vLine.autoresizingMask = UIViewAutoresizingNone/* | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin*/;
    
    [self addSubview:vLine];
    return vLine;
}

- (UIView *)addLineWithRect:(CGRect)rect color:(UIColor *)color
{
    UIView *vLine = [[UIView alloc] initWithFrame:rect];
    vLine.backgroundColor = color;
    vLine.autoresizingMask = UIViewAutoresizingFlexibleHeight/* | UIViewAutoresizingFlexibleRightMargin*/;
    
    [self addSubview:vLine];
    return vLine;
}

@end