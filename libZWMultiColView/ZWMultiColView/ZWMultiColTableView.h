//
//  ZWTableView.h
//  ZWMultiTbv
//
//  Created by chenzhengwang on 13-12-9.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMultiColTopHeaderView.h"
#import "ZWMultiColTbvCell.h"

@protocol ZWMultiColTableViewDataSource;

@interface ZWMultiColTableView : UIScrollView<UITableViewDelegate, UITableViewDataSource>
{
    ZWMultiColTopHeaderView *m_viewTopHeader;
    UITableView *m_tbvGridCells;
    
    BOOL m_bCellResue;
    
    UIFont *m_fontContent;
    UIFont *m_fontTopContent;
    UIColor *m_colorTopHeaderBkgnd;
    UIColor *m_colorNormalSeparatorLine;
    CGFloat m_fWidthNormalSeparatorLine;
    UIColor *m_colorBoldSeparatorLine;
    CGFloat m_fWidthBoldSeparatorLine;
    
    BOOL m_bAutoAdjustGridWidthToFitText;//自动调整单元格宽度以适应文本内容
    BOOL m_bAutoAdjustRowHeightToFitText;//自动调整单元格高度以适应文本内容
    
    BOOL m_bShowVerticalScrollIndicator;
}
@property (nonatomic, retain)id<ZWMultiColTableViewDataSource> dataSource;

@property (nonatomic, retain)UIColor *colorNormalSeparatorLine;
@property (nonatomic)CGFloat fWidthNormalSeparatorLine;
@property (nonatomic, retain)UIColor *colorBoldSeparatorLine;
@property (nonatomic)CGFloat fWidthBoldSeparatorLine;

@property (nonatomic, retain)UIFont *fontContent;
@property (nonatomic, retain)UIFont *fontTopContent;
@property (nonatomic, retain)UIColor *colorTopHeaderBkgnd;

@property (nonatomic)BOOL bCellResue;//单元格重用标志，default is YES;
@property (nonatomic)BOOL bAutoAdjustGridWidthToFitText;
@property (nonatomic)BOOL bAutoAdjustRowHeightToFitText;//not implement yet.

@property (nonatomic)BOOL bShowVerticalScrollIndicator;   // default YES. show indicator while we are tracking. fades out after tracking
@property (nonatomic, readonly, retain)UITableView *tableview;

- (void)addCommonTitleAtStartCol:(NSInteger)nStartCol number:(NSInteger)nNum title:(NSString *)strTitle;
- (void)adjustWidthAtColumn:(NSInteger)nCol;

- (void)reloadData;//重新加载数据后会回卷到第一条数据
- (ZWMultiColTbvCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;// returns nil if cell is not visible or index path is out of range

// Selection
@property (nonatomic)BOOL bHighLightWhenSelect;
- (NSIndexPath *)indexPathForSelectedRow;                                                // returns nil or index path representing section and row of selection.
- (NSArray *)indexPathsForSelectedRows NS_AVAILABLE_IOS(5_0); // returns nil or a set of index paths representing the sections and rows of the selection.

// Selects and deselects rows. These methods will not call the delegate methods (-tableView:willSelectRowAtIndexPath: or tableView:didSelectRowAtIndexPath:), nor will it send out a notification.
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

@property (nonatomic, strong, readonly)NSMutableArray *arrayBackgroundColorSetted;
- (void)setBackgroundColorAtIndexPath:(NSIndexPath *)indexPath backgroundColor:(UIColor *)color;
- (void)clearBackgroundColorAtIndexPath:(NSIndexPath *)indexPath;
- (void)clearBackgroundColorAllRow;

@end

@protocol ZWMultiColTableViewDataSource <NSObject>

@required
- (NSInteger)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfColumn:(ZWMultiColTableView*)multiColTableView;

- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView setContentForTopGridCell:(UIView *)gridCell atColumn:(NSInteger)nCol;
- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView setContentForGridCell:(UIView *)gridCell atIndexPath:(NSIndexPath *)indexPath atColumn:(NSInteger)nCol;

@optional
- (void)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView needAdjustWidth:(CGFloat)fWidth;//当自动适应文本内容时，列宽度改变后通过此方法通知super view是否自动调整view frame;
- (CGFloat)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView widthAtColumn:(NSInteger)nCol;//if not implement, default is the width of grid text;
- (CGFloat)heightForTopRow:(ZWMultiColTableView*)multiColTableView;//default is 44.0
- (CGFloat)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;//if not implement, default is 44.0
- (UIView *)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView gridCellForTopRowColumn:(NSInteger)nCol;//default is UILabel;
- (UIView *)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView gridCellForIndexPath:(NSIndexPath *)indexPath atColumn:(NSInteger)nCol;//default is UILabel;

- (NSIndexPath *)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);

- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView scrollViewDidScroll:(UIScrollView *)scrollView indexPath:(NSIndexPath *)indexPath;
- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;;


@end