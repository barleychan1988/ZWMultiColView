//
//  ZWTableView.h
//  TestForZWMultiColTableView
//
//  Created by chenzhengwang on 13-12-19.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWDblMultiColTbv.h"

typedef enum tagEnum_LoadType
{
    Load_None,
    Load_Refresh,
    Load_Load,
    Load_LastPage,
    Load_NextPage
}enLoadType;

@protocol ZWTableViewDataSource;

@interface ZWTableView : UIView
{
    ZWDblMultiColTbv *m_dblMultiColTbv;
    UIToolbar *m_toolbarBottom;
    UIBarButtonItem *m_barBtnItemTitle;
    
    CGFloat m_fHeightToolbarBottom;
}
@property (nonatomic, retain)id<ZWTableViewDataSource> dataSource;
@property (nonatomic, retain, readonly)ZWDblMultiColTbv *dblMultiColTbv;
@property (nonatomic)CGFloat fHeightToolbarBottom;
@property (nonatomic, retain)UIToolbar *toolbarBottom;
@property (nonatomic, retain)NSString *strToolbarMiddleTitle;

@property(nonatomic, strong)UIView *myInputAccessoryView;
@property(nonatomic, strong)UIView *myInputView;

- (void)reloadData;

@end

@protocol ZWTableViewDataSource<ZWDblMultiColTbvDataSource>

@optional
- (void)refresh;
- (void)loadMore;
- (void)lastPage;
- (void)nextPage;

@end