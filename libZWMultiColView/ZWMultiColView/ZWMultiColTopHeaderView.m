//
//  ZWTopHeaderCell.m
//  ZWMultiTbv
//
//  Created by chenzhengwang on 13-12-6.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

#import "ZWMultiColTopHeaderView.h"
#import "ZWMultiColHasCommonTitle.h"
#import "UIView+AddLine.h"

@interface ZWMultiColTopHeaderView ()
{
    NSMutableArray *m_mtArrayHasSubGrid;
    NSMutableArray *m_mtArraySeparatorLines;
    NSMutableArray *m_mtArraySubviews;//grid cells
    
    BOOL m_bHasTopLine;
    BOOL m_bHasBottomLine;//bold line
    CGFloat m_fWidthNormalSeperatorLine;
    UIColor *m_colorNormalSeperatorLine;
    CGFloat m_fWidthBoldSeperatorLine;
    UIColor *m_colorBoldSeperatorLine;
}
@end

@implementation ZWMultiColTopHeaderView

@synthesize bHasTopLine = m_bHasTopLine;
@synthesize bHasBottomLine = m_bHasBottomLine;
@synthesize fWidthNormalSeperatorLine = m_fWidthNormalSeperatorLine;
@synthesize colorNormalSeperatorLine = m_colorNormalSeperatorLine;
@synthesize fWidthBoldSeperatorLine = m_fWidthBoldSeperatorLine;
@synthesize colorBoldSeperatorLine = m_colorBoldSeperatorLine;
@synthesize fontTitle = m_fontTitle;
@synthesize arraySubGridView = m_mtArraySubviews;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_mtArraySeparatorLines = [[NSMutableArray alloc] initWithCapacity:2];
        
        m_bHasBottomLine = YES;
        m_bHasTopLine = YES;
        m_colorNormalSeperatorLine = [[UIColor lightGrayColor] retain];
        m_colorBoldSeperatorLine = [[UIColor lightGrayColor] retain];
    }
    return self;
}

#pragma mark - view overide

- (void)dealloc
{
    [m_mtArraySeparatorLines release];
    [m_mtArrayHasSubGrid release];
    [m_colorNormalSeperatorLine release];
    [m_colorBoldSeperatorLine release];
    [m_fontTitle release];
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)layoutSubviews
{
    UIView *subview = nil;
    for (subview in self.subviews)
        [subview removeFromSuperview];
    
    if (m_bHasTopLine)
        [self addTopLineWithWidth:m_fWidthNormalSeperatorLine color:m_colorNormalSeperatorLine];
    if (m_bHasBottomLine)
        [self addBottomLineWithWidth:m_fWidthBoldSeperatorLine color:m_colorBoldSeperatorLine];
    //窗口左边添加竖线，右边的竖线由每个单元格添加
    [m_mtArraySeparatorLines addObject:[self addVerticalLineWithWidth:m_fWidthNormalSeperatorLine color:m_colorNormalSeperatorLine atX:0]];

    
    BOOL bAsSubGrid = NO;
    
    ZWMultiColHasCommonTitle *commTitleCol;
    
    for (NSInteger nCol = 0; nCol < [m_mtArraySubviews count]; nCol++)
    {
        subview = [m_mtArraySubviews objectAtIndex:nCol];
        [self addSubview:subview];
        for (NSInteger nIndex = 0; nIndex < [m_mtArrayHasSubGrid count]; nIndex++)
        {
            commTitleCol = [m_mtArrayHasSubGrid objectAtIndex:nIndex];
            if (commTitleCol.nStartCol == nCol)
            {
                bAsSubGrid = YES;
                CGFloat fWidthSub = 0.0f;
                CGFloat fHeightSub = (self.frame.size.height - m_fWidthNormalSeperatorLine - m_fWidthBoldSeperatorLine - m_fWidthNormalSeperatorLine) / 2;
                UIView *gridView = nil;
                CGRect frameGridView = CGRectZero;
                for (NSInteger k=0; k<commTitleCol.nNum; k++)
                {
                    gridView = (UIView *)[m_mtArraySubviews objectAtIndex:nCol + k];
                    [self addSubview:gridView];
                    fWidthSub += gridView.frame.size.width;
                    frameGridView = gridView.frame;
                    frameGridView.origin.y = self.frame.size.height - m_fWidthBoldSeperatorLine - fHeightSub;
                    frameGridView.size.height = fHeightSub;
                    gridView.frame = frameGridView;
                    if (k + 1 != commTitleCol.nNum)
                    {
                        [m_mtArraySeparatorLines addObject:[self addVerticalLineWithWidth:m_fWidthNormalSeperatorLine color:m_colorNormalSeperatorLine atX:gridView.frame.origin.x + gridView.frame.size.width]];
                        fWidthSub += m_fWidthNormalSeperatorLine;
                    }
                }
                CGRect rt = CGRectMake(subview.frame.origin.x, frameGridView.origin.y - 1, fWidthSub, m_fWidthNormalSeperatorLine);
                [self addLineWithRect:rt color:m_colorNormalSeperatorLine];
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(rt.origin.x, m_fWidthNormalSeperatorLine, fWidthSub, fHeightSub)];
                l.textAlignment = NSTextAlignmentCenter;
                l.backgroundColor = self.backgroundColor;
                NSString *strViewClassName = [NSString stringWithUTF8String:object_getClassName(gridView)];
                if ([strViewClassName compare:@"UILabel"] == NSOrderedSame)
                {
                    UILabel *gridLabel = (UILabel *)gridView;
                    l.font = gridLabel.font;
                }
                else if (m_fontTitle)
                    l.font = m_fontTitle;
                l.text = commTitleCol.strTitle;
                [self addSubview:l];

                [m_mtArraySeparatorLines addObject:[self addVerticalLineWithWidth:m_fWidthNormalSeperatorLine color:m_colorNormalSeperatorLine atX:rt.size.width + rt.origin.x]];
                nCol += commTitleCol.nNum;
                nCol --;
                break;
            }
            else
            {
                continue;
            }
        }
        if (bAsSubGrid)
        {
            bAsSubGrid = NO;
        }
        else
        {
            [m_mtArraySeparatorLines addObject:[self addVerticalLineWithWidth:m_fWidthNormalSeperatorLine color:m_colorNormalSeperatorLine atX:subview.frame.size.width + subview.frame.origin.x]];
            CGRect frame;
            frame = subview.frame;
            if (m_bHasTopLine && frame.origin.y <= (m_fWidthNormalSeperatorLine - 1))
            {
                frame.size.height = self.frame.size.height - m_fWidthBoldSeperatorLine - m_fWidthNormalSeperatorLine;
                frame.origin.y = m_fWidthNormalSeperatorLine;
            }
            subview.frame = frame;
        }
    }
    [super layoutSubviews];
}

- (void)addGridView:(UIView *)view
{
    if (m_mtArraySubviews == nil)
        m_mtArraySubviews = [[NSMutableArray alloc] init];
    [m_mtArraySubviews addObject:view];
    [self addSubview:view];
    
    NSString *strViewClassName = [NSString stringWithUTF8String:object_getClassName(view)];
    if ([strViewClassName compare:@"UILabel"] == NSOrderedSame)
    {
        UILabel *l = (UILabel *)view;
        if (m_fontTitle)
            l.font = m_fontTitle;
    }
}

- (void)addCommonTitleGrid:(NSInteger)nStartCol number:(NSInteger)nNum title:(NSString *)strTitle
{
    if (!m_mtArrayHasSubGrid)
        m_mtArrayHasSubGrid = [[NSMutableArray alloc] init];
    ZWMultiColHasCommonTitle *hasSubGridAdd = [[ZWMultiColHasCommonTitle alloc] init];
    hasSubGridAdd.nNum = nNum;
    hasSubGridAdd.nStartCol = nStartCol;
    hasSubGridAdd.strTitle = strTitle;
    [m_mtArrayHasSubGrid addObject:hasSubGridAdd];
}

- (CGFloat)widthForColumnText:(NSInteger)nColumn
{
    CGFloat fRetMaxWidth = 0;
    UIView *subview = [m_mtArraySubviews objectAtIndex:nColumn];
    NSString *strViewClassName = [NSString stringWithUTF8String:object_getClassName(subview)];
    if ([strViewClassName compare:@"UILabel"] == NSOrderedSame)
    {
        UILabel *l = (UILabel *)subview;
        fRetMaxWidth = [l.text sizeWithFont:l.font].width;
        fRetMaxWidth += 6;
    }
    return fRetMaxWidth;
}

- (void)adjustColumnWidth:(NSDictionary *)dicWidths
{
    UIView *subview = (UIView *)[m_mtArraySubviews objectAtIndex:0];
    CGFloat x = subview.frame.origin.x;
    CGRect frame;
    NSString *strKey;
    for (NSInteger i = 0; i < [m_mtArraySubviews count]; i++)
    {
        strKey = [NSString stringWithFormat:@"%d", i];
        subview = (UIView *)[m_mtArraySubviews objectAtIndex:i];
        frame = subview.frame;
        frame.origin.x = x;
        frame.size.width = ((NSNumber *)[dicWidths objectForKey:strKey]).floatValue;
        subview.frame = frame;
        x += frame.size.width;
        x += m_fWidthNormalSeperatorLine;
    }
    [self layoutSubviews];
}
@end