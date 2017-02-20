//
//  ZWMultiColTbvCell.m
//  ZWMultiTbv
//
//  Created by chenzhengwang on 13-12-6.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

#import "ZWMultiColTbvCell.h"
#import "UIView+AddLine.h"

@implementation ZWMultiColTbvCell

@synthesize arrayColumnGridCells = m_mtArrayColumnGridCells;
@synthesize fWidthNormalSeparatorLine = m_fWidthNormalSeparatorLine;
@synthesize colorNormalSeparatorLine = m_colorNormalSeparatorLine;
- (void)setColorNormalSeparatorLine:(UIColor *)color
{
    m_colorNormalSeparatorLine = color;
    for (UIView *line in m_mtArraySeparatorLines)
        line.backgroundColor = m_colorNormalSeparatorLine;
}
@synthesize bHasTopLine = m_bHasTopLine;
@synthesize bHasBottomLine = m_bHasBottomLine;
@synthesize fontTitle = m_fontTitle;

@synthesize colorSelected;
- (void)setColorSelected:(UIColor *)color
{
    colorSelected = [color retain];
    self.backgroundColor = colorSelected;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        m_mtArraySeparatorLines = [[NSMutableArray alloc] initWithCapacity:2];
        m_mtArrayColumnGridCells = [[NSMutableArray alloc] initWithCapacity:2];
        m_bHasBottomLine = NO;
        m_bHasTopLine = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    [super setSelected:selected animated:animated];
    self.backgroundColor = colorSelected;
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    UIView *subview = nil;
    for (subview in [self.contentView subviews])
    {
        [subview removeFromSuperview];
    }
    [m_mtArraySeparatorLines removeAllObjects];
    if (m_mtArraySeparatorLines == nil)
        m_mtArraySeparatorLines = [[NSMutableArray alloc] init];
    
    if (m_bHasTopLine)
        [m_mtArraySeparatorLines addObject:[self.contentView addTopLineWithWidth:m_fWidthNormalSeparatorLine color:m_colorNormalSeparatorLine]];
    if (m_bHasBottomLine)
        [m_mtArraySeparatorLines addObject:[self.contentView addBottomLineWithWidth:m_fWidthNormalSeparatorLine color:m_colorNormalSeparatorLine]];
    //窗口左边添加竖线，右边的竖线由每个单元格添加
    [m_mtArraySeparatorLines addObject:[self.contentView addVerticalLineWithWidth:m_fWidthNormalSeparatorLine color:m_colorNormalSeparatorLine atX:0]];
    
    CGRect frame;
    for (subview in m_mtArrayColumnGridCells)
    {
        [self.contentView addSubview:subview];
        
        [m_mtArraySeparatorLines addObject:[self.contentView addVerticalLineWithWidth:m_fWidthNormalSeparatorLine color:m_colorNormalSeparatorLine atX:subview.frame.size.width + subview.frame.origin.x]];
        
        frame = subview.frame;
        if (m_bHasTopLine && frame.origin.y <= (m_fWidthNormalSeparatorLine - 1))
        {
            frame.origin.y = m_fWidthNormalSeparatorLine;
        }
        if (m_bHasBottomLine)
        {
            if (m_bHasTopLine)
                frame.size.height = self.frame.size.height - m_fWidthNormalSeparatorLine - m_fWidthNormalSeparatorLine;
            else
                frame.size.height = self.frame.size.height - m_fWidthNormalSeparatorLine;
        }
        else
        {
            if (m_bHasTopLine)
                frame.size.height = self.frame.size.height - m_fWidthNormalSeparatorLine;
        }
        subview.frame = frame;
    }
    [super layoutSubviews];
}

- (void)removeFromSuperview
{
    [colorSelected release];
    [super removeFromSuperview];
}

- (void)addSubGridCell:(UIView *)viewGrid atColumn:(NSInteger)nCol
{
    if (m_mtArrayColumnGridCells == nil)
        m_mtArrayColumnGridCells = [[NSMutableArray alloc] initWithCapacity:2];
    [m_mtArrayColumnGridCells insertObject:viewGrid atIndex:nCol];
    [self.contentView addSubview:viewGrid];

    if ([viewGrid isKindOfClass:[UILabel class]])
    {
        UILabel *l = (UILabel *)viewGrid;
        if (m_fontTitle)
            l.font = m_fontTitle;
    }
    else if ([viewGrid isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)viewGrid;
        if (m_fontTitle)
            btn.titleLabel.font = m_fontTitle;
    }
}

- (void)removeAllSubviews
{
    for(UIView *view in [self.contentView subviews])
    {
        [view removeFromSuperview];
    }
    [m_mtArrayColumnGridCells removeAllObjects];
    [m_mtArraySeparatorLines removeAllObjects];
    m_mtArrayColumnGridCells = nil;
    m_mtArraySeparatorLines = nil;
}

//获取列宽度
- (CGFloat)widthForColumnText:(NSInteger)nColumn
{
    CGFloat fRetMaxWidth = 0.0;
    UIView *subview = [m_mtArrayColumnGridCells objectAtIndex:nColumn];
    if ([subview isKindOfClass:[UILabel class]])
    {
        UILabel *l = (UILabel *)subview;
        fRetMaxWidth = [l.text sizeWithFont:l.font].width;
    }
    else if ([subview isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)subview;
        fRetMaxWidth = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width;
    }
    fRetMaxWidth += 6;
    return fRetMaxWidth;
}

- (void)adjustColumnWidth:(NSDictionary *)dicWidths
{
    UIView *subview = (UIView *)[m_mtArrayColumnGridCells objectAtIndex:0];
    CGFloat x = subview.frame.origin.x;
    CGRect frame;
    NSString *strKey;
    for (NSInteger i = 0; i < [m_mtArrayColumnGridCells count]; i++)
    {
        strKey = [NSString stringWithFormat:@"%d", i];
        subview = (UIView *)[m_mtArrayColumnGridCells objectAtIndex:i];
        frame = subview.frame;
        frame.origin.x = x;
        frame.size.width = ((NSNumber *)[dicWidths objectForKey:strKey]).floatValue;
        subview.frame = frame;
        x += frame.size.width;
        x += m_fWidthNormalSeparatorLine;
    }
    [self layoutSubviews];
}
@end
