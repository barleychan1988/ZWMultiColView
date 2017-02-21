//
//  ZWDblMultiColTbv.m
//  TestForZWMultiColTableView
//
//  Created by chenzhengwang on 13-12-19.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import "ZWDblMultiColTbv.h"
#import "ZWMultiColTbvDefine.h"

@interface ZWDblMultiColTbv ()
{
    UIView *m_viewTopHideLine;//遮住最上面冒出的竖线
    UIView *m_viewBottomHideLine;//遮住最下面冒出的竖线

    UIButton *btnTip;

    BOOL m_bRespondsToShowTipMsg;
    BOOL m_bRespondsToNumOfColOnLeft;
    BOOL m_bRespondsToHeightForTopHeaderCell;
    BOOL m_bRespondsToHeightForRowAtIndexPath;
    
    BOOL m_bRespondsToWidthForLeft;
    BOOL m_bRespondsToWidthForLeftColumn;
    BOOL m_bRespondsToLeftTopCell;
    BOOL m_bRespondsToLeftRegularCell;
    
    BOOL m_bRespondsToWidthForBodyColumn;
    BOOL m_bRespondsToRightTopHeaderCellForIndexPath;
    BOOL m_bRespondsToRightRegularCellForIndexPath;
    
    BOOL m_bRespondsToDidSelectRowAtIndexPath;
    BOOL m_bRespondsToWillDeselectRowAtIndexPath;
    BOOL m_bRespondsToDidDeselectRowAtIndexPath;
    
    NSMutableDictionary *m_mtDicLeftHeaderColumnWidth;//根据文本自动调整列宽度
    NSMutableDictionary *m_mtDicRightBodyColumnWidth;//根据文本自动调整列宽度
    
    CGFloat m_fWidthLeft;//default is 60.0;
}
@end

@implementation ZWDblMultiColTbv

@synthesize bHasHeaderView = m_bHasHeaderTbv;
@synthesize dataSource;
- (void)setDataSource:(id<ZWDblMultiColTbvDataSource>)dataSource_
{
    if (dataSource !=dataSource_)
    {
        [dataSource release];
        dataSource = [dataSource_ retain];
        
        m_bRespondsToShowTipMsg = [dataSource respondsToSelector:@selector(showTipMsgAtIndexPath:)];
        m_bRespondsToHeightForTopHeaderCell = [dataSource respondsToSelector:@selector(heightForTopHeader:)];
        m_bRespondsToNumOfColOnLeft = [dataSource respondsToSelector:@selector(numberOfColumnsOnLeft:)];
        m_bRespondsToHeightForRowAtIndexPath = [dataSource respondsToSelector:@selector(dblMultiColTbv:heightForRowAtIndexPath:)];
        
        m_bRespondsToWidthForLeft = [dataSource respondsToSelector:@selector(widthForLeft:)];
        m_bRespondsToWidthForLeftColumn = [dataSource respondsToSelector:@selector(dblMultiColTbv:widthForLeftAtColumn:)];
        m_bRespondsToLeftTopCell = [dataSource respondsToSelector:@selector(dblMultiColTbv:leftTopHeaderCellForColumn:)];
        m_bRespondsToLeftRegularCell = [dataSource respondsToSelector:@selector(dblMultiColTbv:leftRegularCellForIndexPath:column:)];
        
        m_bRespondsToWidthForBodyColumn = [dataSource respondsToSelector:@selector(dblMultiColTbv:widthForRightAtColumn:)];
        m_bRespondsToRightTopHeaderCellForIndexPath = [dataSource respondsToSelector:@selector(dblMultiColTbv:rightTopHeaderCellForColumn:)];
        m_bRespondsToRightRegularCellForIndexPath = [dataSource respondsToSelector:@selector(dblMultiColTbv:rightRegularCellForIndexPath:column:)];
        
        m_bRespondsToDidSelectRowAtIndexPath = [dataSource respondsToSelector:@selector(dblMultiColTbv:didSelectRowAtIndexPath:)];
        m_bRespondsToWillDeselectRowAtIndexPath = [dataSource respondsToSelector:@selector(dblMultiColTbv:willDeselectRowAtIndexPath:)];
        m_bRespondsToDidDeselectRowAtIndexPath = [dataSource respondsToSelector:@selector(dblMultiColTbv:didDeselectRowAtIndexPath:)];
        
        [m_multiColTbvLeft reloadData];
        [m_multiColTbvRight reloadData];
        
        if (m_bHasHeaderTbv && m_multiColTbvLeft == nil)
        {
            m_multiColTbvLeft = [[ZWMultiColTableView alloc] init];
            m_multiColTbvLeft.dataSource = self;
            m_multiColTbvLeft.bShowVerticalScrollIndicator = NO;
            m_multiColTbvLeft.bAutoAdjustGridWidthToFitText = m_bAutoAdjustLeftColumnWidthToText;
            m_multiColTbvLeft.layer.borderColor = m_colorNormalSeparatorLine.CGColor;
            m_multiColTbvLeft.layer.borderWidth = m_fWidthNormalSeparatorLine;
//            [m_multiColTbvLeft.tableview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addSubview:m_multiColTbvLeft];
            
            m_viewTopHideLine = [[UIView alloc] init];
            m_viewTopHideLine.userInteractionEnabled = NO;
            m_viewTopHideLine.backgroundColor = self.backgroundColor;
            [self addSubview:m_viewTopHideLine];
            m_viewBottomHideLine = [[UIView alloc] init];
            m_viewBottomHideLine.userInteractionEnabled = NO;
            m_viewBottomHideLine.backgroundColor = self.backgroundColor;
            [self addSubview:m_viewBottomHideLine];
            
            [m_multiColTbvLeft.tableview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}
@synthesize bAutoAdjustLeftColumnWidthToText = m_bAutoAdjustLeftColumnWidthToText;
- (void)setBAutoAdjustLeftColumnWidthToText:(BOOL)bAutoAdjust
{
    m_bAutoAdjustLeftColumnWidthToText = bAutoAdjust;
    m_multiColTbvLeft.bAutoAdjustGridWidthToFitText = m_bAutoAdjustLeftColumnWidthToText;
}
@synthesize bAutoAdjustLeftWidthToColumns = m_bAutoAdjustLeftWidthToColumns;
@synthesize bAutoAdjustRightColumnWidthToText = m_bAutoAdjustRightColumnWidthToText;
- (void)setBAutoAdjustRightColumnWidthToText:(BOOL)bAutoAdjust
{
    m_bAutoAdjustRightColumnWidthToText = bAutoAdjust;
    m_multiColTbvRight.bAutoAdjustGridWidthToFitText = m_bAutoAdjustRightColumnWidthToText;
}

@synthesize bBoldBetweenLeftAndRight = m_bBoldBetweenLeftAndRight;

@synthesize fWidthBoldSeperatorLine = m_fWidthBoldSeparatorLine;
@synthesize colorBoldSeperatorLine = m_colorBoldSeparatorLine;
- (void)setColorBoldSeperatorLine:(UIColor *)color
{
    [m_colorBoldSeparatorLine release];
    m_colorBoldSeparatorLine = [color retain];
    m_multiColTbvLeft.colorBoldSeparatorLine = m_colorBoldSeparatorLine;
    m_multiColTbvRight.colorBoldSeparatorLine = m_colorBoldSeparatorLine;
}
@synthesize fWidthNormalSeperatorLine = m_fWidthNormalSeparatorLine;
@synthesize colorNormalSeperatorLine = m_colorNormalSeparatorLine;
- (void)setColorNormalSeperatorLine:(UIColor *)color
{
    [m_colorNormalSeparatorLine release];
    m_colorNormalSeparatorLine = [color retain];
    m_multiColTbvLeft.colorNormalSeparatorLine = m_colorNormalSeparatorLine;
    m_multiColTbvRight.colorNormalSeparatorLine = m_colorNormalSeparatorLine;
}

@synthesize colorTopHeaderRowBkgnd;// = m_colorTopHeaderRowBkgnd;
- (void)setColorTopHeaderRowBkgnd:(UIColor *)color
{
    [m_colorTopHeaderRowBkgnd release];
    m_colorTopHeaderRowBkgnd = [color retain];
    m_multiColTbvLeft.colorTopHeaderBkgnd = m_colorTopHeaderRowBkgnd;
    m_multiColTbvRight.colorTopHeaderBkgnd = m_colorTopHeaderRowBkgnd;
}

@synthesize fontTopHeader = m_fontTopHeaderRow;
- (void)setFontTopHeader:(UIFont *)font
{
    [m_fontTopHeaderRow release];
    m_fontTopHeaderRow = [font retain];
    m_multiColTbvLeft.fontTopContent = m_fontTopHeaderRow;
    m_multiColTbvRight.fontTopContent = m_fontTopHeaderRow;
}
@synthesize fontContent = m_fontContent;

@synthesize bCellReuse = m_bCellResue;
- (void)setBCellReuse:(BOOL)bReuse
{
    m_bCellResue = bReuse;
    m_multiColTbvLeft.bCellResue = m_bCellResue;
    m_multiColTbvRight.bCellResue = m_bCellResue;
}
@synthesize bShowTipMsg = m_bShowTipMsg;

@synthesize bHighLightShowSelected;
@synthesize bHighLightFlashShowSelected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        // Initialization code
        m_bBoldBetweenLeftAndRight = YES;
        m_bHasHeaderTbv = YES;
        m_bCellResue = YES;
        
        m_fWidthNormalSeparatorLine = ZWMultiColTbv_NormalLineWidth;
        m_colorNormalSeparatorLine = [[UIColor colorWithWhite:ZWMultiColTbv_LineGray alpha:1.0f] retain];
        m_fWidthBoldSeparatorLine = ZWMultiColTbv_BoldLineWidth;
        m_colorBoldSeparatorLine = [[UIColor colorWithWhite:ZWMultiColTbv_LineGray alpha:1.0f] retain];
        m_colorTopHeaderRowBkgnd = [[UIColor colorWithWhite:ZWMultiColTbv_TopHeaderBkgndColor alpha:1.0f] retain];//
        
        m_fWidthLeft = 60.0;
        
        bHighLightShowSelected = YES;
        bHighLightFlashShowSelected = YES;
        
        m_multiColTbvRight = [[ZWMultiColTableView alloc] init];
        m_multiColTbvRight.dataSource = self;
        m_multiColTbvRight.bAutoAdjustGridWidthToFitText = m_bAutoAdjustRightColumnWidthToText;
//    [m_multiColTbvRight.tableview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubview:m_multiColTbvRight];
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [m_multiColTbvRight reloadData];
}

- (void)dealloc
{
    [dataSource release];
    [m_multiColTbvLeft.tableview removeObserver:self forKeyPath:@"contentSize"];
    [m_multiColTbvLeft release];
    [m_multiColTbvRight release];
    
    [m_viewTopHideLine release];
    [m_viewBottomHideLine release];
    
    [m_fontTopHeaderRow release];
    [m_fontContent release];
    [m_colorBoldSeparatorLine release];
    [m_colorNormalSeparatorLine release];
    [m_colorTopHeaderRowBkgnd release];
    
    [m_mtDicLeftHeaderColumnWidth release];
    [m_mtDicRightBodyColumnWidth release];
    [btnTip release];
    
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.origin.y = 0.0;
    frame.size.height += self.bounds.origin.y;
    if (m_multiColTbvLeft)
    {
        frame.size.width = [self widthForLeft:self];
        m_multiColTbvLeft.frame = frame;
        frame.origin.x += frame.size.width;
        if (!m_bBoldBetweenLeftAndRight)
            frame.origin.x -= m_fWidthNormalSeparatorLine;
    }
    frame.size.width = self.bounds.size.width - frame.origin.x;
    m_multiColTbvRight.frame = frame;
    
    if (!m_bAutoAdjustRightColumnWidthToText && !m_bRespondsToWidthForBodyColumn)
    {
        [m_multiColTbvRight reloadData];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutHideLineView
{
    CGRect frame = CGRectMake(self.bounds.origin.x, -1.0, self.bounds.size.width, 1.0);
    if (m_multiColTbvLeft.tableview.contentOffset.y < 0)
    {
        frame.size.height = -m_multiColTbvLeft.tableview.contentOffset.y;
        frame.origin.y = 0.0;
        m_multiColTbvRight.tableview.showsVerticalScrollIndicator = NO;
    }
    else
    {
        frame.size.height = 1.0;
        frame.origin.y = -frame.size.height;
        if (m_multiColTbvLeft.tableview.dragging)
            m_multiColTbvRight.tableview.showsVerticalScrollIndicator = YES;
    }
    m_viewTopHideLine.frame = frame;
    [self bringSubviewToFront:m_viewTopHideLine];
    
    frame = CGRectMake(self.bounds.origin.x, self.bounds.size.height + self.bounds.origin.y, self.bounds.size.width, 1.0);
    frame.size.height = m_multiColTbvLeft.tableview.frame.size.height - m_multiColTbvLeft.tableview.contentSize.height + m_multiColTbvLeft.tableview.contentOffset.y;
    if (frame.size.height < 0)
    {
        frame.size.height = 1;
        frame.origin.y = m_multiColTbvLeft.frame.size.height + 1;
    }
    else
    {
        CGFloat fTopHeaderHeight = [self heightForTopHeader:self];
        frame.origin.y = fTopHeaderHeight;
        frame.origin.y += m_multiColTbvLeft.tableview.contentSize.height - m_multiColTbvLeft.tableview.contentOffset.y + 1;
        if (frame.origin.y < fTopHeaderHeight)
            frame.origin.y = fTopHeaderHeight;
        if (m_multiColTbvLeft.tableview.dragging)
            m_multiColTbvLeft.tableview.showsVerticalScrollIndicator = NO;
    }
    m_viewBottomHideLine.frame = frame;
    [self bringSubviewToFront:m_viewBottomHideLine];
}

- (void)showTip:(NSString *)strMsg
{
    if (strMsg == nil || strMsg.length == 0)
        return;
    if (btnTip == nil)
    {
        btnTip = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        //        btnTip.layer.cornerRadius = 10;
        btnTip.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        btnTip.hidden = YES;
    }
    CGRect rect;
    CGSize size = [strMsg sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont buttonFontSize]]}];
    if (size.width > 200)
    {
        size.width = 200;
    }
//    CGFloat fHeight = 480.0f;
//    if (iPhone5)
//        fHeight += 88;
    rect.size.width = size.width + 20;
    rect.size.height = size.height;
//    rect.origin.y = (fHeight - rect.size.height) / 2;
    rect.origin.y = [self heightForTopHeader:self];
    rect.origin.x = self.bounds.origin.x;
    if (m_multiColTbvRight.tableview.contentOffset.y < 0)
        rect.origin.y -= m_multiColTbvRight.tableview.contentOffset.y;
    btnTip.frame = rect;//CGRectMake(90, 150, size.width + 20, size.height + 40);
    
    [btnTip setTitle:strMsg forState:UIControlStateNormal];
    if ([btnTip superview] == nil)
    {
        [self addSubview:btnTip];
    }
    btnTip.alpha = 0.8;
    btnTip.hidden = NO;
    [self bringSubviewToFront:btnTip];
}

- (void)addLeftCommonTitleAtStartCol:(NSInteger)nStartCol number:(NSInteger)nNum title:(NSString *)strTitle
{
    [m_multiColTbvLeft addCommonTitleAtStartCol:nStartCol number:nNum title:strTitle];
}

- (void)addRightCommonTitleAtStartCol:(NSInteger)nStartCol number:(NSInteger)nNum title:(NSString *)strTitle
{
    [m_multiColTbvRight addCommonTitleAtStartCol:nStartCol number:nNum title:strTitle];
}

- (void)adjustWidthAtLeftColumn:(NSInteger)nCol
{
    [m_multiColTbvLeft adjustWidthAtColumn:nCol];
}
- (void)adjustWidthAtRightColumn:(NSInteger)nCol
{
    [m_multiColTbvRight adjustWidthAtColumn:nCol];
}

- (void)reloadData
{
    if (m_multiColTbvLeft)
        [m_multiColTbvLeft reloadData];
    [m_multiColTbvRight reloadData];
    
    [UIView animateWithDuration:3 animations: ^{ btnTip.alpha=0; }
                     completion: ^(BOOL finished){ btnTip.hidden = YES; }
     ];
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    if (m_multiColTbvLeft)
        [m_multiColTbvLeft layoutIfNeeded];
    [m_multiColTbvRight layoutIfNeeded];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [m_multiColTbvLeft.tableview insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [m_multiColTbvRight.tableview insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    [m_multiColTbvLeft.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    [m_multiColTbvRight.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [m_multiColTbvLeft selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    [m_multiColTbvRight selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    
    [m_multiColTbvLeft clearBackgroundColorAllRow];
    [m_multiColTbvRight clearBackgroundColorAllRow];
    [m_multiColTbvLeft setBackgroundColorAtIndexPath:indexPath backgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.1]];
    [m_multiColTbvRight setBackgroundColorAtIndexPath:indexPath backgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.1]];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [m_multiColTbvLeft deselectRowAtIndexPath:indexPath animated:animated];
    [m_multiColTbvRight deselectRowAtIndexPath:indexPath animated:animated];
    
    [m_multiColTbvLeft clearBackgroundColorAllRow];
    [m_multiColTbvRight clearBackgroundColorAllRow];
}


- (NSArray *)getArrayBackgroundColorSetted
{
    return [m_multiColTbvRight arrayBackgroundColorSetted];
}
- (void)setBackgroundColorAtIndexPath:(NSIndexPath *)indexPath backgroundColor:(UIColor *)color
{
    [m_multiColTbvRight setBackgroundColorAtIndexPath:indexPath backgroundColor:color];
    if (m_multiColTbvLeft)
        [m_multiColTbvLeft setBackgroundColorAtIndexPath:indexPath backgroundColor:color];
}
- (void)clearBackgroundColorAtIndexPath:(NSIndexPath *)indexPath
{
    [m_multiColTbvRight clearBackgroundColorAtIndexPath:indexPath];
    if (m_multiColTbvLeft)
        [m_multiColTbvLeft clearBackgroundColorAtIndexPath:indexPath];
}
- (void)clearBackgroundColorAllRow
{
    [m_multiColTbvRight clearBackgroundColorAllRow];
    if (m_multiColTbvLeft)
        [m_multiColTbvLeft clearBackgroundColorAllRow];
}

#pragma mark - ZWMultiColTableViewDataSource
- (void)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView needAdjustWidth:(CGFloat)fWidth
{
    if (m_bAutoAdjustLeftWidthToColumns && multiColTableView == m_multiColTbvLeft)
    {
        m_fWidthLeft = fWidth;
        
        CGRect frame = self.bounds;
        frame.origin.y = 0.0;
        frame.size.height += self.bounds.origin.y;
        frame.size.width = [self widthForLeft:self];
        m_multiColTbvLeft.frame = frame;
        frame.origin.x += frame.size.width;
        if (!m_bBoldBetweenLeftAndRight)
            frame.origin.x -= m_fWidthNormalSeparatorLine;
        frame.size.width = self.bounds.size.width - frame.origin.x;
        m_multiColTbvRight.frame = frame;
    }
}

- (NSInteger)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource dblMultiColTbv:self numberOfRowsInSection:section];
}

- (NSInteger)numberOfColumn:(ZWMultiColTableView *)multiColTableView
{
    if (multiColTableView == m_multiColTbvLeft)
    {
        return [self numberOfColumnsOnLeft:self];
    }
    else// if (multiColTableView == m_multiColTbvRight)
    {
        return [dataSource numberOfColumnsOnRight:self];
    }
    return 0;
}

- (CGFloat)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView widthAtColumn:(NSInteger)nCol
{
    if (multiColTableView == m_multiColTbvLeft)
    {
        return [self dblMultiColTbv:self widthForLeftAtColumn:nCol];
    }
    else// if (multiColTableView == m_multiColTbvRight)
    {
        return [self dblMultiColTbv:self widthForRightAtColumn:nCol];
    }
    return 0.0;
}

- (CGFloat)heightForTopRow:(ZWMultiColTableView *)multiColTableView
{
    return [self heightForTopHeader:self];
}

- (CGFloat)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self dblMultiColTbv:self heightForRowAtIndexPath:indexPath];
}

- (UIView *)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView gridCellForTopRowColumn:(NSInteger)nCol
{
    if (multiColTableView == m_multiColTbvLeft)
    {
        return [self dblMultiColTbv:self leftTopHeaderCellForColumn:nCol];
    }
    else// if (multiColTableView == m_multiColTbvRight)
    {
        return [self dblMultiColTbv:self rightTopHeaderCellForColumn:nCol];
    }
    return nil;
}

- (void)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView setContentForTopGridCell:(UIView *)gridCell atColumn:(NSInteger)nCol
{
    if (multiColTableView == m_multiColTbvLeft)
    {
        [dataSource dblMultiColTbv:self setContentForLeftTopCell:gridCell column:nCol];
    }
    else// if (multiColTableView == m_multiColTbvRight)
    {
        [dataSource dblMultiColTbv:self setContentForRightTopCell:gridCell column:nCol];
    }
}

- (UIView *)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView gridCellForIndexPath:(NSIndexPath *)indexPath atColumn:(NSInteger)nCol
{
    if (multiColTableView == m_multiColTbvLeft)
    {
        return [self dblMultiColTbv:self leftRegularCellForIndexPath:indexPath column:nCol];
    }
    else// if (multiColTableView == m_multiColTbvRight)
    {
        return [self dblMultiColTbv:self rightRegularCellForIndexPath:indexPath column:nCol];
    }
    return nil;
}

- (void)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView setContentForGridCell:(UIView *)gridCell atIndexPath:(NSIndexPath *)indexPath atColumn:(NSInteger)nCol
{
    if (multiColTableView == m_multiColTbvLeft)
    {
        [dataSource dblMultiColTbv:self setContentForLeftRegularCell:gridCell indexPath:indexPath column:nCol];
    }
    else// if (multiColTableView == m_multiColTbvRight)
    {
        [dataSource dblMultiColTbv:self setContentForRightRegularCell:gridCell indexPath:indexPath column:nCol];
    }
}

- (NSIndexPath *)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!bHighLightShowSelected)
        return indexPath;
    
    ZWMultiColTableView *tbvOther;
    if (multiColTableView == m_multiColTbvLeft)
    {
        tbvOther = m_multiColTbvRight;
    }
    else
    {
        tbvOther = m_multiColTbvLeft;
    }
    if (bHighLightFlashShowSelected)
    {
        NSMutableArray *arrayParam = nil;
        if (tbvOther != nil)
        {
            UITableViewCell *cell = [tbvOther cellForRowAtIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            [tbvOther selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//            [UIView animateWithDuration:1 animations:^{} completion:^(BOOL finished){cell.selectionStyle = UITableViewCellSelectionStyleNone;}];
            arrayParam = [[NSMutableArray alloc] initWithCapacity:2];
            [arrayParam addObject:tbvOther];
            [arrayParam addObject:indexPath];
            [self performSelector:@selector(deselectRowAtIndexPath:) withObject:arrayParam afterDelay:0.3];
            [arrayParam release];
        }
        UITableViewCell *cell2 = [multiColTableView cellForRowAtIndexPath:indexPath];
    //    cell.selected = YES;
        cell2.selectionStyle = UITableViewCellSelectionStyleBlue;
        [multiColTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    //    [UIView animateWithDuration:12 animations:^{[tableView deselectRowAtIndexPath:indexPath animated:YES];} completion:^(BOOL finished){ NSLog(@"string" );cell2.selectionStyle = UITableViewCellSelectionStyleNone;}];
        arrayParam =[[NSMutableArray alloc] initWithCapacity:2];
        [arrayParam addObject:multiColTableView];
        [arrayParam addObject:indexPath];
        [self performSelector:@selector(deselectRowAtIndexPath:) withObject:arrayParam afterDelay:0.3];
        [arrayParam release];
    }
    else
    {
        [m_multiColTbvLeft clearBackgroundColorAllRow];
        [m_multiColTbvRight clearBackgroundColorAllRow];
        [m_multiColTbvLeft setBackgroundColorAtIndexPath:indexPath backgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.1]];
        [m_multiColTbvRight setBackgroundColorAtIndexPath:indexPath backgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.1]];
    }
    return indexPath;
}
- (void)deselectRowAtIndexPath:(NSArray *)arrayParam
{
    UITableView *tableView = (UITableView *)[arrayParam objectAtIndex:0];
    NSIndexPath * indexPath = (NSIndexPath *)[arrayParam objectAtIndex:1];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSIndexPath *)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    if (m_bRespondsToWillDeselectRowAtIndexPath)
        return [dataSource dblMultiColTbv:self willDeselectRowAtIndexPath:indexPath];
    return indexPath;
}

- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_bRespondsToDidSelectRowAtIndexPath)
        [dataSource dblMultiColTbv:self didSelectRowAtIndexPath:indexPath];
}

- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    if (m_bRespondsToDidDeselectRowAtIndexPath)
        [dataSource dblMultiColTbv:self didDeselectRowAtIndexPath:indexPath];
}

- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView scrollViewDidScroll:(UIScrollView *)scrollView indexPath:(NSIndexPath *)indexPath
{
    if (multiColTableView == m_multiColTbvLeft)
    {
        m_multiColTbvRight.tableview.contentOffset = m_multiColTbvLeft.tableview.contentOffset;
    }
    else if (multiColTableView == m_multiColTbvRight)
    {
        m_multiColTbvLeft.tableview.contentOffset = m_multiColTbvRight.tableview.contentOffset;
    }
    [self layoutHideLineView];
    
    if (m_bShowTipMsg)
    {
        if (m_bRespondsToShowTipMsg)
            return [self showTip:[dataSource showTipMsgAtIndexPath:indexPath]];
        if (indexPath != nil)
            [self showTip:[NSString stringWithFormat:@"%ld", (long)indexPath.row + 1]];
    }
}

- (void)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:3 animations: ^{ btnTip.alpha=0; }
                     completion: ^(BOOL finished){ btnTip.hidden = YES; }
     ];
}

- (void)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [UIView animateWithDuration:3 animations: ^{ btnTip.alpha=0; }
                     completion: ^(BOOL finished){ btnTip.hidden = YES; }
     ];
}

- (void)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:3 animations: ^{ btnTip.alpha=0; }
                     completion: ^(BOOL finished){ btnTip.hidden = YES; }
     ];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath compare:@"contentOffset"] == NSOrderedSame)
    {
        if (object == m_multiColTbvLeft.tableview)
        {
            m_multiColTbvRight.tableview.contentOffset = m_multiColTbvLeft.tableview.contentOffset;
        }
        else if (object == m_multiColTbvRight.tableview)
        {
            m_multiColTbvLeft.tableview.contentOffset = m_multiColTbvRight.tableview.contentOffset;
        }
    }
    else if ([keyPath compare:@"contentSize"] == NSOrderedSame && object == m_multiColTbvLeft.tableview)
    {
        [self layoutHideLineView];        
    }
}

#pragma mark - ZWDblMultiColTbvDataSource

- (CGFloat)heightForTopHeader:(ZWDblMultiColTbv *)multiColTbv
{
    if (m_bRespondsToHeightForTopHeaderCell)
        return [dataSource heightForTopHeader:multiColTbv];
    return 44.0f;
}

- (CGFloat)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_bRespondsToHeightForRowAtIndexPath)
        return [dataSource dblMultiColTbv:self heightForRowAtIndexPath:indexPath];
    return 44.0f;
}

#pragma mark Left

- (CGFloat)widthForLeft:(ZWDblMultiColTbv *)multiColTbv
{
    if (m_bAutoAdjustLeftWidthToColumns && m_bAutoAdjustLeftColumnWidthToText)
        return m_fWidthLeft;
    if (m_bRespondsToWidthForLeft)
        return [dataSource widthForLeft:self];
    return 60.0;
}

- (NSInteger)numberOfColumnsOnLeft:(ZWDblMultiColTbv *)multiColTbv
{
    if (m_bRespondsToNumOfColOnLeft)
        return [dataSource numberOfColumnsOnLeft:multiColTbv];
    return 1;
}

- (CGFloat)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv widthForLeftAtColumn:(NSInteger)nCol
{
    CGFloat fRet = ([self widthForLeft:self] - m_fWidthNormalSeparatorLine) / [self numberOfColumnsOnLeft:self] - m_fWidthNormalSeparatorLine;
    NSString *strKey = [[NSString stringWithFormat:@"%ld", (long)nCol] retain];
    NSNumber *num;
    if (m_bAutoAdjustLeftColumnWidthToText)
    {
        num = [m_mtDicLeftHeaderColumnWidth objectForKey:strKey];
        if (num != nil)
            fRet = num.floatValue;
    }
    else if (m_bRespondsToWidthForLeftColumn)
        fRet = [dataSource dblMultiColTbv:self widthForLeftAtColumn:nCol];
    
    if (m_mtDicLeftHeaderColumnWidth == nil)
    {
        m_mtDicLeftHeaderColumnWidth = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    if (nil == [m_mtDicLeftHeaderColumnWidth objectForKey:strKey])
    {
        num = [[NSNumber numberWithFloat:fRet] retain];
        [m_mtDicLeftHeaderColumnWidth setObject:num forKey:strKey];
        [num release];
    }
    [strKey release];
    return fRet;
}

- (UIView *)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv leftTopHeaderCellForColumn:(NSInteger)nCol
{
    if (m_bRespondsToLeftTopCell)
        return [dataSource dblMultiColTbv:self leftTopHeaderCellForColumn:nCol];
    
    UILabel *l =  [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    l.backgroundColor = m_colorTopHeaderRowBkgnd;
    if (m_fontTopHeaderRow)
        l.font = m_fontTopHeaderRow;
    
    return l;
}

- (UIView *)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv leftRegularCellForIndexPath:(NSIndexPath *)indexPath column:(NSInteger)nCol
{
    if (m_bRespondsToLeftRegularCell)
        return [dataSource dblMultiColTbv:self leftRegularCellForIndexPath:indexPath column:nCol];
    
    UILabel *l =  [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    if (m_fontContent)
        l.font = m_fontContent;
    l.backgroundColor = [UIColor clearColor];
    
    return l;
}

#pragma mark Right

- (CGFloat)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv widthForRightAtColumn:(NSInteger)nCol
{
    CGFloat fRet = self.frame.size.width;
    if (m_bHasHeaderTbv)
        fRet -= [self widthForLeft:self];
    fRet = (fRet - m_fWidthNormalSeparatorLine) / [dataSource numberOfColumnsOnRight:self];
    fRet -= m_fWidthNormalSeparatorLine;
    NSString *strKey = [[NSString stringWithFormat:@"%ld", (long)nCol] retain];
    NSNumber *num;
    if (m_bAutoAdjustRightColumnWidthToText)
    {
        num = [m_mtDicRightBodyColumnWidth objectForKey:strKey];
        if (num != nil)
            fRet = num.floatValue;
    }
    else if (m_bRespondsToWidthForBodyColumn)
        fRet = [dataSource dblMultiColTbv:self widthForRightAtColumn:nCol];
    
    if (m_mtDicRightBodyColumnWidth == nil)
    {
        m_mtDicRightBodyColumnWidth = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    if (nil == [m_mtDicRightBodyColumnWidth objectForKey:strKey])
    {
        num = [[NSNumber numberWithFloat:fRet] retain];
        [m_mtDicRightBodyColumnWidth setObject:num forKey:strKey];
        [num release];
    }
    [strKey release];
    return fRet;
}

- (UIView *)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv rightTopHeaderCellForColumn:(NSInteger)nCol
{
    UIView *cell = nil;
    if (m_bRespondsToRightTopHeaderCellForIndexPath)
        cell = [dataSource dblMultiColTbv:multiColTbv rightTopHeaderCellForColumn:nCol];
    if (cell != nil)
        return cell;
    
    UILabel *l =  [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    l.backgroundColor = m_colorTopHeaderRowBkgnd;
    if (m_fontTopHeaderRow)
        l.font = m_fontTopHeaderRow;
    
    return l;
}

- (UIView *)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv rightRegularCellForIndexPath:(NSIndexPath *)indexPath column:(NSInteger)nCol
{
    if (m_bRespondsToRightRegularCellForIndexPath)
        return [dataSource dblMultiColTbv:multiColTbv rightRegularCellForIndexPath:indexPath column:nCol];
    
    UILabel *l =  [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    if (m_fontContent)
        l.font = m_fontContent;
    l.backgroundColor = [UIColor clearColor];
    
    return l;
}

@end
