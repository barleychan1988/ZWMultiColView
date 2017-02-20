//
//  ZWTopHeaderCell.h
//  ZWMultiTbv
//
//  Created by chenzhengwang on 13-12-6.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWMultiColTopHeaderView : UIView

@property (nonatomic)BOOL bHasTopLine;//是否显示顶部分割线 normal seperator line, default is YES;
@property (nonatomic)BOOL bHasBottomLine;//bottom bold seperator line，default is YES;
@property (nonatomic)CGFloat fWidthNormalSeperatorLine;
@property (nonatomic, retain)UIColor *colorNormalSeperatorLine;
@property (nonatomic)CGFloat fWidthBoldSeperatorLine;
@property (nonatomic, retain)UIColor *colorBoldSeperatorLine;
@property (nonatomic, retain)UIFont *fontTitle;
@property (nonatomic, retain, readonly)NSMutableArray *arraySubGridView;

- (void)addGridView:(UIView *)view;
- (void)addCommonTitleGrid:(NSInteger)nStartCol number:(NSInteger)nNum title:(NSString *)strTitle;
- (CGFloat)widthForColumnText:(NSInteger)nColumn;//获取列宽度
- (void)adjustColumnWidth:(NSDictionary *)dicWidths;

@end
