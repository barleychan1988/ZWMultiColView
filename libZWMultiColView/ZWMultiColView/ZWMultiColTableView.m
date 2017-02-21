//
//  ZWTableView.m
//  ZWMultiTbv
//
//  Created by chenzhengwang on 13-12-9.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

#import "ZWMultiColTableView.h"
#import "ZWMultiColTbvDefine.h"

@interface ZWMultiColTableView()
{
    NSMutableDictionary *m_mtDicColumnWidths;
    
    BOOL m_bRespondsToGridCellForTopRowColumn;//dataSource 是否实现gridCellForTopColumn:
    BOOL m_bRespondsToGridCellForIndexPath;//dataSource 是否实现gridCellForIndexPath: atColumn:
    BOOL m_bRespondsToHeightForTopRow;
    BOOL m_bRespondsToHeightForRowAtIndexPath;//dataSource 是否实现heightForRowAtIndexPath:
    BOOL m_bRespondsToWidthAtColumn;
    BOOL m_bRespondsToAutoAdjustWidth;
    
    BOOL m_bRespondsToWillSelectRowAtIndexPath;
    BOOL m_bRespondsToWillDeselectRowAtIndexPath;
    BOOL m_bRespondsToDidSelectRowAtIndexPath;
    BOOL m_bRespondsToDidDeselectRowAtIndexPath;
    
    BOOL m_bRespondsToScrollViewDidScroll;
    BOOL m_bRespondsToScrollViewDidEndDecelerating;
    BOOL m_bRespondsToScrollViewDidEndDragging;
    BOOL m_bRespondsToScrollViewDidEndScrollingAnimation;
    
    NSMutableDictionary *m_mtDicRowBkgndColor;
}
@end

@implementation ZWMultiColTableView

@synthesize dataSource;
- (void)setDataSource:(id<ZWMultiColTableViewDataSource>)dataSource_
{
    if (dataSource_ != dataSource)
    {
        [dataSource release];
        dataSource = [dataSource_ retain];
        
        m_bRespondsToGridCellForIndexPath = [dataSource respondsToSelector:@selector(ZWMultiColTableView:gridCellForIndexPath:atColumn:)];
        m_bRespondsToGridCellForTopRowColumn = [dataSource respondsToSelector:@selector(ZWMultiColTableView:gridCellForTopRowColumn:)];
        m_bRespondsToHeightForRowAtIndexPath = [dataSource respondsToSelector:@selector(ZWMultiColTableView:heightForRowAtIndexPath:)];
        m_bRespondsToHeightForTopRow = [dataSource respondsToSelector:@selector(heightForTopRow:)];
        m_bRespondsToWidthAtColumn = [dataSource respondsToSelector:@selector(ZWMultiColTableView:widthAtColumn:)];
        m_bRespondsToAutoAdjustWidth = [dataSource respondsToSelector:@selector(ZWMultiColTableView:needAdjustWidth:)];
        
        m_bRespondsToWillSelectRowAtIndexPath = [dataSource respondsToSelector:@selector(ZWMultiColTableView: willSelectRowAtIndexPath:)];
        m_bRespondsToWillDeselectRowAtIndexPath = [dataSource respondsToSelector:@selector(willDeselectRowAtIndexPath:)];
        m_bRespondsToDidSelectRowAtIndexPath = [dataSource respondsToSelector:@selector(ZWMultiColTableView:didSelectRowAtIndexPath:)];
        m_bRespondsToDidDeselectRowAtIndexPath = [dataSource respondsToSelector:@selector(ZWMultiColTableView:didDeselectRowAtIndexPath:)];
        
        m_bRespondsToScrollViewDidScroll = [dataSource respondsToSelector:@selector(ZWMultiColTableView:scrollViewDidScroll:indexPath:)];
        m_bRespondsToScrollViewDidEndDecelerating = [dataSource respondsToSelector:@selector(ZWMultiColTableView:scrollViewDidEndDecelerating:)];
        m_bRespondsToScrollViewDidEndDragging = [dataSource respondsToSelector:@selector(ZWMultiColTableView:scrollViewDidEndDragging:willDecelerate:)];
        m_bRespondsToScrollViewDidEndScrollingAnimation = [dataSource respondsToSelector:@selector(ZWMultiColTableView:scrollViewDidEndScrollingAnimation:)];
        
        [self initTopHeaderView];
        [m_tbvGridCells reloadData];
    }
}

@synthesize fWidthNormalSeparatorLine = m_fWidthNormalSeparatorLine;
- (void)setFWidthNormalSeparatorLine:(CGFloat)fWidth
{
    m_fWidthNormalSeparatorLine = fWidth;
    m_viewTopHeader.fWidthNormalSeperatorLine = m_fWidthNormalSeparatorLine;
}
@synthesize colorNormalSeparatorLine = m_colorNormalSeparatorLine;
- (void)setColorNormalSeparatorLine:(UIColor *)color
{
    [m_colorNormalSeparatorLine release];
    m_colorNormalSeparatorLine = [color retain];
    m_viewTopHeader.colorNormalSeperatorLine = m_colorNormalSeparatorLine;
}
@synthesize fWidthBoldSeparatorLine = m_fWidthBoldSeparatorLine;
- (void)setFWidthBoldSeparatorLine:(CGFloat)fWidth
{
    m_fWidthBoldSeparatorLine = fWidth;
    m_viewTopHeader.fWidthBoldSeperatorLine = m_fWidthBoldSeparatorLine;
}
@synthesize colorBoldSeparatorLine = m_colorBoldSeparatorLine;
- (void)setColorBoldSeparatorLine:(UIColor *)color
{
    [m_colorBoldSeparatorLine release];
    m_colorBoldSeparatorLine = [color retain];
    m_viewTopHeader.colorBoldSeperatorLine = m_colorBoldSeparatorLine;
}

@synthesize fontContent = m_fontContent;
- (void)setFontContent:(UIFont *)font
{
    [m_fontContent release];
    m_fontContent = [font retain];
}
@synthesize fontTopContent = m_fontTopContent;
- (void)setFontTopContent:(UIFont *)font
{
    [m_fontTopContent release];
    m_fontTopContent = [font retain];
    m_viewTopHeader.fontTitle = m_fontTopContent;
}
@synthesize colorTopHeaderBkgnd = m_colorTopHeaderBkgnd;
- (void)setColorTopHeaderBkgnd:(UIColor *)color
{
    [m_colorTopHeaderBkgnd release];
    m_colorTopHeaderBkgnd = [color retain];
//    m_viewTopHeader.backgroundColor = m_colorTopHeaderBkgnd;
    [m_viewTopHeader setBackgroundColor:m_colorTopHeaderBkgnd];
}

@synthesize bCellResue = m_bCellResue;
@synthesize bAutoAdjustGridWidthToFitText = m_bAutoAdjustGridWidthToFitText;
@synthesize bAutoAdjustRowHeightToFitText = m_bAutoAdjustRowHeightToFitText;

@synthesize bShowVerticalScrollIndicator = m_bShowVerticalScrollIndicator;
- (void)setBShowVerticalScrollIndicator:(BOOL)bShowIndicator
{
    m_bShowVerticalScrollIndicator = bShowIndicator;
    m_tbvGridCells.showsVerticalScrollIndicator = m_bShowVerticalScrollIndicator;
}
@synthesize tableview = m_tbvGridCells;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self setupTopHeaderView];
        m_tbvGridCells = [[UITableView alloc] init];
        m_tbvGridCells.backgroundColor = nil;
        m_tbvGridCells.separatorStyle = UITableViewCellSelectionStyleNone;
        m_tbvGridCells.delegate = self;
        m_tbvGridCells.dataSource = self;
        [self addSubview:m_tbvGridCells];
        
        m_mtDicColumnWidths = [[NSMutableDictionary alloc] init];
        m_bCellResue = YES;
        
        //default settings
        self.fWidthNormalSeparatorLine = ZWMultiColTbv_NormalLineWidth;
//        self.colorNormalSeparatorLine = [[UIColor colorWithWhite:ZWMultiColTbv_LineGray alpha:1.0f] retain]; 在setColorNormalSeparatorLine:中有retain，所以在此不需要retain
        self.colorNormalSeparatorLine = [UIColor colorWithWhite:ZWMultiColTbv_LineGray alpha:1.0f];
        self.fWidthBoldSeparatorLine = ZWMultiColTbv_BoldLineWidth;
        self.colorBoldSeparatorLine = [UIColor colorWithWhite:ZWMultiColTbv_LineGray alpha:1.0f];
        self.colorTopHeaderBkgnd = [UIColor colorWithWhite:ZWMultiColTbv_TopHeaderBkgndColor alpha:1.0f];//[[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1] retain];
    }
    return self;
}

- (void)dealloc
{
    [m_fontContent release];
    [m_fontTopContent release];
    [m_colorTopHeaderBkgnd release];
    [m_colorNormalSeparatorLine release];
    [m_colorBoldSeparatorLine release];
    [m_mtDicColumnWidths release];
    
    [m_viewTopHeader release];
    [m_tbvGridCells release];
    
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
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self initTopHeaderView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat fWidthContentSize = 0.0;
    NSInteger nColumnNumber = [dataSource numberOfColumn:self];
    for (NSInteger i=0; i<nColumnNumber; i++)
    {
        fWidthContentSize += m_fWidthNormalSeparatorLine;
        fWidthContentSize += [self ZWMultiColTableView:self widthAtColumn:i];
    }
    fWidthContentSize += m_fWidthNormalSeparatorLine;
    CGRect frame = self.bounds;
    frame.origin.y = 0.0;
    frame.origin.x -= self.contentOffset.x;
    frame.size.width = fWidthContentSize;
    frame.size.height = [self heightForTopRow:self];
    m_viewTopHeader.frame = frame;
    
    frame.origin.y += frame.size.height;
    frame.size.height = self.bounds.size.height + self.bounds.origin.y - [self heightForTopRow:self];
    m_tbvGridCells.frame = frame;
    
    if (!m_bAutoAdjustGridWidthToFitText && !m_bRespondsToWidthAtColumn)
    {
        [self initTopHeaderView];
    }
}

- (void)setupTopHeaderView
{
    if (m_viewTopHeader != nil)
        [m_viewTopHeader release];
    m_viewTopHeader = [[ZWMultiColTopHeaderView alloc] init];
    m_viewTopHeader.clipsToBounds = YES;
    m_viewTopHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    m_viewTopHeader.fWidthNormalSeperatorLine = m_fWidthNormalSeparatorLine;
    m_viewTopHeader.colorNormalSeperatorLine = m_colorNormalSeparatorLine;
    m_viewTopHeader.fWidthBoldSeperatorLine = m_fWidthBoldSeparatorLine;
    m_viewTopHeader.colorBoldSeperatorLine = m_colorBoldSeparatorLine;
    m_viewTopHeader.backgroundColor = m_colorTopHeaderBkgnd;
    m_viewTopHeader.bHasTopLine = YES;
    m_viewTopHeader.bHasBottomLine = YES;
    m_viewTopHeader.fontTitle = m_fontTopContent;
    [self addSubview:m_viewTopHeader];
    [self bringSubviewToFront:m_viewTopHeader];
}

- (void)initTopHeaderView
{
//    if (!m_bCellResue)
//        [m_viewTopHeader removeAllSubviews];
    
    NSInteger nColNum = [dataSource numberOfColumn:self];
    NSInteger columnsDiff = nColNum - [[m_viewTopHeader arraySubGridView] count];
    UIView *gridCell = nil;
    if (columnsDiff > 0)
    {
        for (int i=0; i<columnsDiff; i++)//貌似有问题，当列数动态变化时，有可能不是从第0列添加
        {
            //创建单元格
            gridCell = [self ZWMultiColTableView:self gridCellForTopRowColumn:i];
            [m_viewTopHeader addGridView:gridCell];
        }
    }
    else if (columnsDiff < 0)
    {
        columnsDiff = -columnsDiff;
        for (int i = 0; i < columnsDiff; i++)
        {
            [[[m_viewTopHeader arraySubGridView] lastObject] removeFromSuperview];
            [[m_viewTopHeader arraySubGridView] removeLastObject];
        }
    }
    
//    BOOL bWidthColumnChanged = NO;
    //设置单元格内容及宽度
    CGFloat x = m_fWidthNormalSeparatorLine;
    CGRect rectGridCell;
    for (int i = 0; i < nColNum; i++)
    {
        gridCell = [[m_viewTopHeader arraySubGridView] objectAtIndex:i];
        [dataSource ZWMultiColTableView:self setContentForTopGridCell:gridCell atColumn:i];
        
        if (m_bAutoAdjustGridWidthToFitText)
        {
            if (m_mtDicColumnWidths == nil)
            {
                m_mtDicColumnWidths = [[NSMutableDictionary alloc] initWithCapacity:2];
            }
            CGFloat fWidth = [m_viewTopHeader widthForColumnText:i];
            NSString *strKey = [[NSString stringWithFormat:@"%d", i] retain];
            NSNumber *numWidth = (NSNumber *)[m_mtDicColumnWidths objectForKey:strKey];
            if (numWidth == nil || fWidth > numWidth.floatValue)
            {
                numWidth = [[NSNumber numberWithFloat:fWidth] retain];
                [m_mtDicColumnWidths setObject:numWidth forKey: strKey];
                [numWidth release];
//                bWidthColumnChanged = YES;
            }
            [strKey release];
        }
        // Add the grid cells - call the delegate method to init the grid cells
        rectGridCell.origin.x = x;
        rectGridCell.origin.y = 0.0;
        rectGridCell.size.height = [self heightForTopRow:self];
        rectGridCell.size.width = [self ZWMultiColTableView:self widthAtColumn:i];
        gridCell.frame = rectGridCell;
        
        x += [self ZWMultiColTableView:self widthAtColumn:i];
        x += m_fWidthNormalSeparatorLine;
    }
//    if (bWidthColumnChanged)
//    {
    [self adjustGridColumnWidth];
//    }
}

- (void)addCommonTitleAtStartCol:(NSInteger)nStartCol number:(NSInteger)nNum title:(NSString *)strTitle
{
    [m_viewTopHeader addCommonTitleGrid:nStartCol number:nNum title:strTitle];
}

- (void)adjustGridColumnWidth
{
    [m_viewTopHeader adjustColumnWidth:m_mtDicColumnWidths];
    
    NSArray *arrayCells = [[m_tbvGridCells visibleCells] retain];
    UITableViewCell *cell;
    for (cell in arrayCells)
    {
        [(ZWMultiColTbvCell *)cell adjustColumnWidth:m_mtDicColumnWidths];
    }
    [arrayCells release];
    
    CGFloat fWidthSum = m_fWidthNormalSeparatorLine;
    NSNumber *numWidth;
    for (NSString *strKey in [m_mtDicColumnWidths allKeys])
    {
        numWidth = [[m_mtDicColumnWidths objectForKey:strKey] retain];
        fWidthSum += numWidth.floatValue;
        fWidthSum += m_fWidthNormalSeparatorLine;
        [numWidth release];
    }
    self.contentSize = CGSizeMake(fWidthSum, 0);
    CGRect frame = m_viewTopHeader.frame;
    frame.size.width = fWidthSum;
    m_viewTopHeader.frame = frame;
    frame = m_tbvGridCells.frame;
    frame.size.width = fWidthSum;
    m_tbvGridCells.frame = frame;
    
    if (m_bRespondsToAutoAdjustWidth)
        [dataSource ZWMultiColTableView:self needAdjustWidth:fWidthSum];
}

- (void)adjustWidthAtColumn:(NSInteger)nCol
{
    BOOL bWidthColumnChanged = NO;
    CGFloat fWidth = [m_viewTopHeader widthForColumnText:nCol];
    NSString *strKey = [[NSString stringWithFormat:@"%ld", (long)nCol] retain];
    NSNumber *numWidth = [(NSNumber *)[m_mtDicColumnWidths objectForKey:strKey] retain];
    if (numWidth == nil || fWidth > numWidth.floatValue)
    {
        [numWidth release];
        numWidth = [[NSNumber numberWithFloat:fWidth] retain];
        [m_mtDicColumnWidths setObject:numWidth forKey: strKey];
        bWidthColumnChanged = YES;
    }
    [numWidth release];
    NSArray *arrayCells = [[m_tbvGridCells visibleCells] retain];
    ZWMultiColTbvCell *cell;
    numWidth = [(NSNumber *)[m_mtDicColumnWidths objectForKey:strKey] retain];
    for (cell in arrayCells)
    {
        fWidth = [cell widthForColumnText:nCol];
        if (numWidth == nil || fWidth > numWidth.floatValue)
        {
            [numWidth release];
            numWidth = [[NSNumber numberWithFloat:fWidth] retain];
            [m_mtDicColumnWidths setObject:numWidth forKey: strKey];
            bWidthColumnChanged = YES;
        }
    }
    [numWidth release];
    [arrayCells release];
    
    [strKey release];
    
    if (bWidthColumnChanged)
    {
        [self adjustGridColumnWidth];
    }
}

- (void)reloadData
{
    [self initTopHeaderView];
    [m_tbvGridCells reloadData];
    [m_tbvGridCells setContentOffset:CGPointMake(0.0, 0.0)];
}

- (ZWMultiColTbvCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ZWMultiColTbvCell *)[m_tbvGridCells cellForRowAtIndexPath:indexPath];
}

// Selection

- (NSIndexPath *)indexPathForSelectedRow
{
    return [m_tbvGridCells indexPathForSelectedRow];
}

- (NSArray *)indexPathsForSelectedRows
{
    return [m_tbvGridCells indexPathsForSelectedRows];
}

@synthesize bHighLightWhenSelect;
- (void)setBHighLightWhenSelect:(BOOL)bHighLight
{
    bHighLightWhenSelect = bHighLight;
    if (!bHighLight)
        [m_tbvGridCells deselectRowAtIndexPath:[m_tbvGridCells indexPathForSelectedRow] animated:NO];
    if (bHighLight)
    {
        for (UITableViewCell *cell in m_tbvGridCells.visibleCells)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    }
    else
    {
        for (UITableViewCell *cell in m_tbvGridCells.visibleCells)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
}
// Selects and deselects rows. These methods will not call the delegate methods (-tableView:willSelectRowAtIndexPath: or tableView:didSelectRowAtIndexPath:), nor will it send out a notification.
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [m_tbvGridCells selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [m_tbvGridCells deselectRowAtIndexPath:indexPath animated:animated];
}

- (void)setBackgroundColorAtIndexPath:(NSIndexPath *)indexPath backgroundColor:(UIColor *)color
{
    if (self.arrayBackgroundColorSetted == nil)
        _arrayBackgroundColorSetted = [[NSMutableArray alloc] initWithCapacity:1];
    if (m_mtDicRowBkgndColor == nil)
        m_mtDicRowBkgndColor = [[NSMutableDictionary alloc] initWithCapacity:1];
    BOOL bHasAlready = NO;
    for (NSIndexPath *index in _arrayBackgroundColorSetted)
    {
        if (indexPath.row == index.row && index.section == indexPath.section)
        {
            bHasAlready = YES;
        }
    }
    if (!bHasAlready)
        [_arrayBackgroundColorSetted addObject:indexPath];
    NSString *strKey = [[NSString stringWithFormat:@"%ld", (long)indexPath.row] retain];
    [m_mtDicRowBkgndColor setObject:color forKey:strKey];
    
//    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = [m_mtDicRowBkgndColor objectForKey:strKey];
    ZWMultiColTbvCell *cell = [self cellForRowAtIndexPath:indexPath];
    cell.colorSelected = [m_mtDicRowBkgndColor objectForKey:strKey];
    
    [strKey release];
}
- (void)clearBackgroundColorAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = nil;
    for (NSIndexPath *index in _arrayBackgroundColorSetted)
    {
        if (indexPath.row == index.row && index.section == indexPath.section)
        {
            [_arrayBackgroundColorSetted removeObject:index];
            NSString *strKey = [[NSString stringWithFormat:@"%ld", (long)indexPath.row] retain];
            [m_mtDicRowBkgndColor removeObjectForKey:strKey];
            [strKey release];
            break;
        }
    }
}
- (void)clearBackgroundColorAllRow
{
    for (NSIndexPath *index in _arrayBackgroundColorSetted)
    {
//        UITableViewCell *cell = [self cellForRowAtIndexPath:index];
//        cell.backgroundColor = nil;
        ZWMultiColTbvCell *cell = [self cellForRowAtIndexPath:index];
        cell.colorSelected = nil;
        
        NSString *strKey = [[NSString stringWithFormat:@"%ld", (long)index.row] retain];
        [m_mtDicRowBkgndColor removeObjectForKey:strKey];
        [strKey release];
        [_arrayBackgroundColorSetted removeObject:index];
        break;
    }
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource ZWMultiColTableView:self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellID = @"RowCellID";
    ZWMultiColTbvCell *cell = (ZWMultiColTbvCell *)[tableView dequeueReusableCellWithIdentifier:strCellID];
    if (cell == nil)
    {
        cell = [[[ZWMultiColTbvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellID] autorelease];
        cell.bHasBottomLine = YES;
    }
    if (bHighLightWhenSelect)
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    else
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.colorSelected = nil;
    for (NSIndexPath *index in _arrayBackgroundColorSetted)
    {
        if (index.row == indexPath.row && indexPath.section == index.section)
        {
            NSString *strKey = [[NSString stringWithFormat:@"%ld", (long)indexPath.row] retain];
            cell.colorSelected = [m_mtDicRowBkgndColor objectForKey:strKey];
            [strKey release];
            break;
        }
    }

    cell.fontTitle = m_fontContent;
    cell.fWidthNormalSeparatorLine = m_fWidthNormalSeparatorLine;
    cell.colorNormalSeparatorLine = m_colorNormalSeparatorLine;
    
    if (!m_bCellResue)
        [cell removeAllSubviews];
    
    NSInteger numOfCols = [dataSource numberOfColumn:self];
    NSInteger columnsDiff = numOfCols - [[cell arrayColumnGridCells] count];
    
    UIView *gridCell = nil;
    if (columnsDiff > 0)
    {
        for (int i=0; i<columnsDiff; i++)//貌似有问题，当列数动态变化时
        {
            //创建单元格
            gridCell = [self ZWMultiColTableView:self gridCellForIndexPath:indexPath atColumn:i];
            [cell addSubGridCell:gridCell atColumn:i];
        }
    }
    else if (columnsDiff < 0)
    {
        columnsDiff = -columnsDiff;
        for (int i = 0; i < columnsDiff; i++)
        {
            [[[cell arrayColumnGridCells] lastObject] removeFromSuperview];
            [[cell arrayColumnGridCells] removeLastObject];
        }
    }
    
    BOOL bWidthColumnChanged = NO;
    //设置单元格内容及宽度
    CGFloat x = m_fWidthNormalSeparatorLine;
    CGRect rectGridCell;
    for (int i = 0; i < numOfCols; i++)
    {
        gridCell = [[cell arrayColumnGridCells] objectAtIndex:i];
        [dataSource ZWMultiColTableView:self setContentForGridCell:gridCell atIndexPath:indexPath atColumn:i];
        
        if (m_bAutoAdjustGridWidthToFitText)
        {
            if (m_mtDicColumnWidths == nil)
            {
                m_mtDicColumnWidths = [[NSMutableDictionary alloc] initWithCapacity:2];
            }
            CGFloat fWidth = [cell widthForColumnText:i];
            NSString *strKey = [[NSString stringWithFormat:@"%d", i] retain];
            NSNumber *numWidth = (NSNumber *)[m_mtDicColumnWidths objectForKey:strKey];
            if (numWidth == nil || fWidth > numWidth.floatValue)
            {
                numWidth = [[NSNumber numberWithFloat:fWidth] retain];
                [m_mtDicColumnWidths setObject:numWidth forKey: strKey];
                [numWidth release];
                bWidthColumnChanged = YES;
            }
            [strKey release];
        }
        // Add the grid cells - call the delegate method to init the grid cells
        rectGridCell.origin.x = x;
        rectGridCell.origin.y = 0.0;
        rectGridCell.size.height = [self tableView:m_tbvGridCells heightForRowAtIndexPath:indexPath];
        rectGridCell.size.width = [self ZWMultiColTableView:self widthAtColumn:i];
        gridCell.frame = rectGridCell;
        
        x += [self ZWMultiColTableView:self widthAtColumn:i];
        x += m_fWidthNormalSeparatorLine;
    }
    if (bWidthColumnChanged)
    {
//        [cell adjustColumnWidth:m_mtDicColumnWidths];
        [self adjustGridColumnWidth];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (m_bAutoAdjustRowHeightToFitText)
//    {
//        
//    }
    if (m_bRespondsToHeightForRowAtIndexPath)
        return [dataSource ZWMultiColTableView:self heightForRowAtIndexPath:indexPath];
    else
        return 44.0f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_bRespondsToWillSelectRowAtIndexPath)
        return [dataSource ZWMultiColTableView:self willSelectRowAtIndexPath:indexPath];
    return indexPath;
}
- (NSIndexPath *)willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_bRespondsToWillDeselectRowAtIndexPath)
        return [dataSource ZWMultiColTableView:self willDeselectRowAtIndexPath:indexPath];
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_bRespondsToDidSelectRowAtIndexPath)
        [dataSource ZWMultiColTableView:self didSelectRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_bRespondsToDidDeselectRowAtIndexPath)
        [dataSource ZWMultiColTableView:self didDeselectRowAtIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == m_tbvGridCells)
    {
        if (scrollView.contentOffset.y < 0)
        {
            CGRect frame = m_viewTopHeader.frame;
            frame.origin.y = -scrollView.contentOffset.y;
            m_viewTopHeader.frame = frame;
        }
        else
        {
            CGRect frame = m_viewTopHeader.frame;
            frame.origin.y = 0.0;
            m_viewTopHeader.frame = frame;
        }
    }
    if (m_bRespondsToScrollViewDidScroll)
    {
        NSArray *array = [[m_tbvGridCells visibleCells] retain];
        NSIndexPath *indexPath = [[m_tbvGridCells indexPathForCell:[array lastObject]] retain];
        [dataSource ZWMultiColTableView:self scrollViewDidScroll:scrollView indexPath:indexPath];
        [array release];
        [indexPath release];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (m_bRespondsToScrollViewDidEndDecelerating)
        [dataSource ZWMultiColTableView:self scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (m_bRespondsToScrollViewDidEndDragging)
        [dataSource ZWMultiColTableView:self scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    if (m_bRespondsToScrollViewDidEndScrollingAnimation)
        [dataSource ZWMultiColTableView:self scrollViewDidEndScrollingAnimation:scrollView];
}


#pragma mark - ZWMultiColTableViewDataSource
- (CGFloat)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView widthAtColumn:(NSInteger)nCol //if not implement, default is the width of grid text;
{
    CGFloat fRet = 0.0;
    NSString *strKey = [[NSString stringWithFormat:@"%ld", (long)nCol] retain];
    NSNumber *num;
    if (m_bAutoAdjustGridWidthToFitText)
    {
        num = [m_mtDicColumnWidths objectForKey:strKey];
        if (num != nil)
            fRet = num.floatValue;
    }
    else if (m_bRespondsToWidthAtColumn)
        fRet = [dataSource ZWMultiColTableView:self widthAtColumn:nCol];
    else
    {
        num = [m_mtDicColumnWidths objectForKey:strKey];
        if (num != nil)
            fRet = num.floatValue;
        else
            fRet = (self.frame.size.width - m_fWidthNormalSeparatorLine) / [dataSource numberOfColumn:self] - m_fWidthNormalSeparatorLine;
    }
    
    if (m_mtDicColumnWidths == nil)
    {
        m_mtDicColumnWidths = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    if (nil == [m_mtDicColumnWidths objectForKey:strKey])
    {
        num = [[NSNumber numberWithFloat:fRet] retain];
        [m_mtDicColumnWidths setObject:num forKey:strKey];
        [num release];
    }
    else if (((NSNumber *)[m_mtDicColumnWidths objectForKey:strKey]).floatValue < fRet)
    {   
        num = [[NSNumber numberWithFloat:fRet] retain];
        [m_mtDicColumnWidths setObject:num forKey:strKey];
        [num release];
    }
    [strKey release];
    return fRet;
}

- (CGFloat)heightForTopRow:(ZWMultiColTableView*)multiColTableView
{
    if (m_bRespondsToHeightForTopRow)
        return [dataSource heightForTopRow:self];
    return 44.0f;
}

- (UIView *)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView gridCellForTopRowColumn:(NSInteger)nCol
{
    UIView *view = nil;
    if (m_bRespondsToGridCellForTopRowColumn)
    {
        view = [dataSource ZWMultiColTableView:self gridCellForTopRowColumn:nCol];
    }
    else
    {
        UILabel *l = [[[UILabel alloc] init] autorelease];
        l.backgroundColor = m_colorTopHeaderBkgnd;
        if (m_fontTopContent)
            l.font = [[m_fontTopContent retain] autorelease];
        view = l;
    }
//    [dataSource setContentForTopGridCell:view atColumn:nCol];
//    if (m_bAutoAdjustGridWidthToFitText)
//    {
//    }
    return view;
}

- (UIView *)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView gridCellForIndexPath:(NSIndexPath *)indexPath atColumn:(NSInteger)nCol
{
    UIView *view = nil;
    if (m_bRespondsToGridCellForIndexPath)
    {
        view = [dataSource ZWMultiColTableView:self gridCellForIndexPath:indexPath atColumn:nCol];
    }
    else
    {
        UILabel *l = [[[UILabel alloc] init] autorelease];
        if (m_fontContent)
            l.font = [[m_fontContent retain] autorelease];
        l.backgroundColor = [UIColor clearColor];
        view = l;
    }
//    [dataSource setContentForGridCell:view atIndexPath:indexPath atColumn:nCol];
//    if (m_bAutoAdjustGridWidthToFitText)
//    {
//    }
    return view;
}

@end
