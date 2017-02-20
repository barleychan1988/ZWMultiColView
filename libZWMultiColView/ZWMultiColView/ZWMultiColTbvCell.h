//
//  ZWMultiColTbvCell.h
//  ZWMultiTbv
//
//  Created by chenzhengwang on 13-12-6.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWMultiColTbvCell : UITableViewCell
{
    NSMutableArray *m_mtArrayColumnGridCells;
    
    BOOL m_bHasTopLine;
    BOOL m_bHasBottomLine;//normal line
    CGFloat m_fWidthNormalSeparatorLine;
    UIColor *m_colorNormalSeparatorLine;
    UIFont *m_fontTitle;
    
    NSMutableArray *m_mtArraySeparatorLines;
}

@property (nonatomic)BOOL bHasTopLine;
@property (nonatomic)BOOL bHasBottomLine;
@property (nonatomic)CGFloat fWidthNormalSeparatorLine;
@property (nonatomic, retain)UIColor *colorNormalSeparatorLine;
@property (nonatomic, retain)UIFont *fontTitle;

@property (nonatomic, retain)NSMutableArray *arrayColumnGridCells;

@property (nonatomic, retain)UIColor *colorSelected;//added by zwchen 20140213

- (void)removeAllSubviews;
- (void)addSubGridCell:(UIView *)viewGrid atColumn:(NSInteger)nCol;

/*
 *  @description:获取列表单元格内容所占宽度，目前只支持UILabel控件
 *
 */
- (CGFloat)widthForColumnText:(NSInteger)nColumn;//获取列宽度
/*
 *  @description:
 *  @param: exm:dicWidths={"1"=100;"2"=50;} 第一列宽度=100 第2列宽度=50
 */
- (void)adjustColumnWidth:(NSDictionary *)dicWidths;

@end