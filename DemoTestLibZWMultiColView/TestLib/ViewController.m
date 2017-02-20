//
//  ViewController.m
//  TestLib
//
//  Created by chenzhengwang on 14-5-22.
//  Copyright (c) 2014年 zwchen. All rights reserved.
//

#import "ViewController.h"
#import "ZWMultiColTableViewController.h"
#import "ZWDblMultiColTbvVC.h"
#import "ZWTableViewVC.h"

@interface ViewController ()
{
    NSArray *m_arrayItemText;
    UITableView *m_tableView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    m_arrayItemText = [[NSArray alloc] initWithObjects:@"ZWMultiColTableView", @"ZWDblMultiColTbv", @"ZWTableView", nil];
    
    self.title = @"TestLibZWMultiColView";
    
    m_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];
//    m_zwMultiColTableView = [[ZWMultiColTableView alloc] initWithFrame:self.view.frame];
//    m_zwMultiColTableView.dataSource = self;
//    m_zwMultiColTableView.bAutoAdjustGridWidthToFitText = YES;
//    [self.view addSubview:m_zwMultiColTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    m_zwMultiColTableView.frame = CGRectMake(self.view.frame.origin.x, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellID];
    }
    cell.textLabel.text = [m_arrayItemText objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            ZWMultiColTableViewController *zwMultiColTableView = [[ZWMultiColTableViewController alloc] init];
            [self.navigationController pushViewController:zwMultiColTableView animated:YES];
        }
            break;
        case 1:
        {
            ZWDblMultiColTbvVC *zwMultiColTableView = [[ZWDblMultiColTbvVC alloc] init];
            [self.navigationController pushViewController:zwMultiColTableView animated:YES];
        }
            break;
        case 2:
        {
            ZWTableViewVC *zwMultiColTableView = [[ZWTableViewVC alloc] init];
            [self.navigationController pushViewController:zwMultiColTableView animated:YES];
        }
            break;
            
        default:
            break;
    }
}
/*
#pragma mark - ZWMultiColTableViewDataSource

- (NSInteger)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (NSInteger)numberOfColumn:(ZWMultiColTableView*)multiColTableView
{
    return 6;
}

- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView setContentForTopGridCell:(UIView *)gridCell atColumn:(NSInteger)nCol
{
    UILabel *l = (UILabel *)gridCell;
    l.text = @"topGrid";
}

- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView setContentForGridCell:(UIView *)gridCell atIndexPath:(NSIndexPath *)indexPath atColumn:(NSInteger)nCol
{
    UILabel *l = (UILabel *)gridCell;
    l.text = @"contentGrid";
}
 */
@end