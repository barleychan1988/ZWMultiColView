//
//  ZWDblMultiColTbv.h
//
//
//  Created by chenzhengwang on 13-12-19.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//
/*
 *  @description：this view
 *
 */
#import <UIKit/UIKit.h>
#import "ZWMultiColTableView.h"

@protocol ZWDblMultiColTbvDataSource;

@interface ZWDblMultiColTbv : UIScrollView<ZWMultiColTableViewDataSource>
{
    BOOL m_bHasHeaderTbv;//是否显示Left header tableview；默认是YES    
    ZWMultiColTableView *m_multiColTbvLeft;
    ZWMultiColTableView *m_multiColTbvRight;
    
    CGFloat m_fWidthNormalSeparatorLine;
    UIColor *m_colorNormalSeparatorLine;
    CGFloat m_fWidthBoldSeparatorLine;
    UIColor *m_colorBoldSeparatorLine;
    BOOL m_bAutoAdjustLeftWidthToColumns;
    BOOL m_bAutoAdjustLeftColumnWidthToText;
    BOOL m_bAutoAdjustRightColumnWidthToText;
    
    UIFont *m_fontTopHeaderRow;//列标题栏字体
    UIColor *m_colorTopHeaderRowBkgnd;//列标题栏背景色
    UIFont *m_fontContent;//regular grid font
    
    BOOL m_bCellResue;
    BOOL m_bShowTipMsg;
    BOOL m_bBoldBetweenLeftAndRight;
}
@property (nonatomic, assign) BOOL bHasHeaderView;//需要在设置数据源之前调用才生效 default:YES
@property (nonatomic, assign) id<ZWDblMultiColTbvDataSource> dataSource;
@property (nonatomic)BOOL bAutoAdjustLeftColumnWidthToText;//自动调整列宽带适应文本 default is NO;
@property (nonatomic)BOOL bAutoAdjustRightColumnWidthToText;//自动调整列宽带适应文本 default is NO;
@property (nonatomic)BOOL bAutoAdjustLeftWidthToColumns;//自动调整header tableview width,以至于不需要水平滚动, default is NO;
@property (nonatomic)BOOL bBoldBetweenLeftAndRight;//between header and right tableview is bold separator line. default is yes.

@property (nonatomic, retain) UIColor *colorBoldSeperatorLine;
@property (nonatomic, assign) CGFloat fWidthBoldSeperatorLine;
@property (nonatomic, retain) UIColor *colorNormalSeperatorLine;//每个单元格的分割线颜色
@property (nonatomic, assign) CGFloat fWidthNormalSeperatorLine;

@property (nonatomic, retain)UIColor *colorTopHeaderRowBkgnd;

@property (nonatomic, retain) UIFont *fontTopHeader;
@property (nonatomic, retain) UIFont *fontContent;

@property (nonatomic, assign) BOOL bCellReuse; //单元格重用标志 default:YES
@property (nonatomic)BOOL bHighLightFlashShowSelected;//选择的某行高亮闪烁显示 default is YES;
@property (nonatomic)BOOL bHighLightShowSelected;//选择的某行高亮显示 default is YES;
@property (nonatomic)BOOL bShowTipMsg;//是否显示滚动提示标志，default is NO;

//设置某些列合并一个大列
- (void)addLeftCommonTitleAtStartCol:(NSInteger)nStartCol number:(NSInteger)nNum title:(NSString *)strTitle;
- (void)addRightCommonTitleAtStartCol:(NSInteger)nStartCol number:(NSInteger)nNum title:(NSString *)strTitle;
- (void)adjustWidthAtLeftColumn:(NSInteger)nCol;
- (void)adjustWidthAtRightColumn:(NSInteger)nCol;

- (void)reloadData;
- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

- (NSArray *)getArrayBackgroundColorSetted;
- (void)setBackgroundColorAtIndexPath:(NSIndexPath *)indexPath backgroundColor:(UIColor *)color;
- (void)clearBackgroundColorAtIndexPath:(NSIndexPath *)indexPath;
- (void)clearBackgroundColorAllRow;

@end


#pragma mark - ZWDblMultiColTbvDataSource

@protocol ZWDblMultiColTbvDataSource<UIScrollViewDelegate>

@required
#pragma mark #required
- (NSInteger)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv numberOfRowsInSection:(NSInteger)section;

#pragma mark right body tableview
- (NSInteger)numberOfColumnsOnRight:(ZWDblMultiColTbv *)multiColTbv;
- (void)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv setContentForRightTopCell:(UIView *)cell column:(NSInteger)col;
- (void)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv setContentForRightRegularCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath column:(NSInteger)col;

#pragma mark #optional
@optional
- (NSString *)showTipMsgAtIndexPath:(NSIndexPath *)indexPath;//返回内容为空时不显示
//height for mulColTbv
- (CGFloat)heightForTopHeader:(ZWDblMultiColTbv *)multiColTbv;//default is 44.0
- (CGFloat)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv heightForRowAtIndexPath:(NSIndexPath *)indexPath;//default is 44.0
- (CGFloat)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv heightForHeaderInSection:(NSInteger)section;//default is 22.0

- (void)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)dblMultiColTbv:(ZWDblMultiColTbv*)multiColTbv willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
- (void)dblMultiColTbv:(ZWDblMultiColTbv*)multiColTbv didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);

#pragma mark left header tableview
- (void)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv setContentForLeftTopCell:(UIView *)cell column:(NSInteger)col;
- (void)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv setContentForLeftRegularCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath column:(NSInteger)col;

- (CGFloat)widthForLeft:(ZWDblMultiColTbv *)multiColTbv;//left header tableview width. default is 60 if not implemented
- (NSInteger)numberOfColumnsOnLeft:(ZWDblMultiColTbv *)multiColTbv;//default is 1 if not implemented
- (CGFloat)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv widthForLeftAtColumn:(NSInteger)nCol;//default is 60 at every column if not implemented
- (UIView *)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv leftTopHeaderCellForColumn:(NSInteger)col;//default is UILabel，the size if default also.
- (UIView *)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv leftRegularCellForIndexPath:(NSIndexPath *)indexPath column:(NSInteger)nCol;//default is UILabel，the size if default also.

#pragma mark right body tableview
- (CGFloat)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv widthForRightAtColumn:(NSInteger)col;//defalut is 60 if not implemented
- (UIView *)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv rightTopHeaderCellForColumn:(NSInteger)col;//default is UILabel，the size if default also.
- (UIView *)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv rightRegularCellForIndexPath:(NSIndexPath *)indexPath column:(NSInteger)col;

@end