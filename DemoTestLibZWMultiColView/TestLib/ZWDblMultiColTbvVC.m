//
//  ZWDblMultiColTbv.m
//  TestLib
//
//  Created by chenzhengwang on 14-5-23.
//  Copyright (c) 2014年 zwchen. All rights reserved.
//

#import "ZWDblMultiColTbvVC.h"

@interface ZWDblMultiColTbvVC ()
{
    ZWDblMultiColTbv *m_zwDblMultiColTbv;
}
@end

@implementation ZWDblMultiColTbvVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    m_zwDblMultiColTbv = [[ZWDblMultiColTbv alloc] initWithFrame:self.view.frame];
    m_zwDblMultiColTbv.dataSource = self;
    m_zwDblMultiColTbv.bAutoAdjustLeftColumnWidthToText = YES;
    m_zwDblMultiColTbv.bAutoAdjustRightColumnWidthToText = YES;
    m_zwDblMultiColTbv.bAutoAdjustLeftWidthToColumns = YES;
    [self.view addSubview:m_zwDblMultiColTbv];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZWDblMultiColTbvDataSource
- (NSInteger)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

#pragma mark right body tableview
- (NSInteger)numberOfColumnsOnRight:(ZWDblMultiColTbv *)multiColTbv
{
    return 5;
}

- (void)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv setContentForRightTopCell:(UIView *)cell column:(NSInteger)col
{
    UILabel *l = (UILabel *)cell;
    l.text = @"rightTop";
}

- (void)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv setContentForRightRegularCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath column:(NSInteger)col
{
    UILabel *l = (UILabel *)cell;
    l.text = @"rightRegular";
}

- (void)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv setContentForLeftTopCell:(UIView *)cell column:(NSInteger)col
{
    UILabel *l = (UILabel *)cell;
    l.text = @"leftRegular";
}
- (void)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv setContentForLeftRegularCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath column:(NSInteger)col
{
    UILabel *l = (UILabel *)cell;
    l.text = @"leftRegular";
}

//- (CGFloat)widthForLeft:(ZWDblMultiColTbv *)multiColTbv;//left header tableview width. default is 60 if not implemented
//- (NSInteger)numberOfColumnsOnLeft:(ZWDblMultiColTbv *)multiColTbv;//default is 1 if not implemented
//- (CGFloat)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv widthForLeftAtColumn:(NSInteger)nCol;//default is 60 at every column if not implemented
//- (UIView *)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv leftTopHeaderCellForColumn:(NSInteger)col;//default is UILabel，the size if default also.
//- (UIView *)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv leftRegularCellForIndexPath:(NSIndexPath *)indexPath column:(NSInteger)nCol;//default is UILabel，the size if default also.
@end