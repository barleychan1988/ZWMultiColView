//
//  ZWTableViewVC.m
//  TestLib
//
//  Created by chenzhengwang on 14-5-23.
//  Copyright (c) 2014年 zwchen. All rights reserved.
//

#import "ZWTableViewVC.h"

@interface ZWTableViewVC ()
{
    ZWTableView *m_zwTableView;
    NSInteger m_nRowNum;
}
@end

@implementation ZWTableViewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        m_nRowNum = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    m_zwTableView = [[ZWTableView alloc] initWithFrame:self.view.frame];
    m_zwTableView.dblMultiColTbv.bAutoAdjustLeftColumnWidthToText = YES;
    m_zwTableView.dblMultiColTbv.bAutoAdjustRightColumnWidthToText = YES;
    m_zwTableView.dblMultiColTbv.bAutoAdjustLeftWidthToColumns = YES;
    m_zwTableView.dataSource = self;
    [self.view addSubview:m_zwTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZWTableViewDataSource

- (NSInteger)dblMultiColTbv:(ZWDblMultiColTbv *)multiColTbv numberOfRowsInSection:(NSInteger)section
{
    return m_nRowNum;
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

- (void)refresh
{
    m_nRowNum = 1;
    [m_zwTableView reloadData];
}

- (void)loadMore
{
    m_nRowNum += 5;
    m_nRowNum %= 15;
    if (m_nRowNum == 0)
        m_nRowNum = 1;
    
    [m_zwTableView reloadData];
}

@end