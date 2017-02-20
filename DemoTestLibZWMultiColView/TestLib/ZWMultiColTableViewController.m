//
//  ZWMultiColTableViewController.m
//  TestLib
//
//  Created by chenzhengwang on 14-5-22.
//  Copyright (c) 2014年 zwchen. All rights reserved.
//

#import "ZWMultiColTableViewController.h"

@interface ZWMultiColTableViewController ()
{
    ZWMultiColTableView *m_zwMultiColTableView;
}
@end

@implementation ZWMultiColTableViewController

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
    
    m_zwMultiColTableView = [[ZWMultiColTableView alloc] initWithFrame:self.view.frame];
    m_zwMultiColTableView.bAutoAdjustGridWidthToFitText = YES;
    m_zwMultiColTableView.dataSource = self;
    m_zwMultiColTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_zwMultiColTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZWMultiColTableViewDataSource

- (NSInteger)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfColumn:(ZWMultiColTableView*)multiColTableView
{
    return 10;
}

- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView setContentForTopGridCell:(UIView *)gridCell atColumn:(NSInteger)nCol
{
    UILabel *l = (UILabel *)gridCell;
    l.text = @"topGridCell";
}

- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView setContentForGridCell:(UIView *)gridCell atIndexPath:(NSIndexPath *)indexPath atColumn:(NSInteger)nCol
{
    
    UILabel *l = (UILabel *)gridCell;
    l.text = @"contentGridCell";
}
@end