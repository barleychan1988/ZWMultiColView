//
//  ZWTableView.m
//  TestForZWMultiColTableView
//
//  Created by chenzhengwang on 13-12-19.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

#import "ZWTableView.h"

@interface ZWTableView()
{
    BOOL m_bRespondsToRefresh;
    BOOL m_bRespondsToLoadMore;
    BOOL m_bRespondsToLastPage;
    BOOL m_bRespondsToNextPage;
}

@end

@implementation ZWTableView

@synthesize dataSource;
- (void)setDataSource:(id<ZWTableViewDataSource>)dataSource_
{
    if (dataSource != dataSource_)
    {
        dataSource = dataSource_;
        m_dblMultiColTbv.dataSource = dataSource;
        
        m_bRespondsToRefresh = [dataSource respondsToSelector:@selector(refresh)];
        m_bRespondsToLoadMore = [dataSource respondsToSelector:@selector(loadMore)];
        m_bRespondsToLastPage = [dataSource respondsToSelector:@selector(lastPage)];
        m_bRespondsToNextPage = [dataSource respondsToSelector:@selector(nextPage)];
    }
}
@synthesize dblMultiColTbv = m_dblMultiColTbv;
@synthesize fHeightToolbarBottom = m_fHeightToolbarBottom;
- (void)setFHeightToolbarBottom:(CGFloat)fHeight
{
    if (m_toolbarBottom == nil)
        return;
    CGRect frame = self.bounds;
    frame.origin.y = 0.0;
    frame.size.height -= self.bounds.origin.y;
    frame.size.height -= m_fHeightToolbarBottom;
    m_dblMultiColTbv.frame = frame;
    frame.origin.y = frame.size.height;
    frame.size.height = m_fHeightToolbarBottom;
    m_toolbarBottom.frame = frame;
}
@synthesize toolbarBottom = m_toolbarBottom;
- (void)setToolbarBottom:(UIToolbar *)toolbar
{
    if (m_toolbarBottom != toolbar)
    {
        if (m_toolbarBottom == nil)
        {
            CGRect frame = m_dblMultiColTbv.frame;
            frame.size.height -= m_fHeightToolbarBottom;
            m_dblMultiColTbv.frame = frame;
            frame.origin.y = frame.size.height;
            frame.size.height = m_fHeightToolbarBottom;
            toolbar.frame = frame;
        }
        else if (toolbar == nil)
        {
            CGRect frame = m_dblMultiColTbv.frame;
            frame.size.height += m_fHeightToolbarBottom;
            m_dblMultiColTbv.frame = frame;
        }
        else
        {
            toolbar.frame = m_toolbarBottom.frame;
        }
//        [m_toolbarBottom release];
        m_toolbarBottom = toolbar;
        [self addSubview:m_toolbarBottom];
    }
}
@synthesize strToolbarMiddleTitle;
- (void)setStrToolbarMiddleTitle:(NSString *)strTitle
{
    m_barBtnItemTitle.title = strTitle;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_dblMultiColTbv = [[ZWDblMultiColTbv alloc] init];
        m_dblMultiColTbv.dataSource = dataSource;
        [self addSubview:m_dblMultiColTbv];
        m_toolbarBottom = [[UIToolbar alloc] init];
        [self addSubview:m_toolbarBottom];
        
        m_fHeightToolbarBottom = 44.0;
        
        [self setupDefaultBottomToolbar];
    }
    return self;
}

@synthesize myInputAccessoryView;
@synthesize myInputView;

//像键盘一样弹出的窗口
- (UIView *)inputAccessoryView
{
    return myInputAccessoryView;
}
- (UIView *)inputView
{
    //    if (!myInputView)
    //    {
    //        UIDatePicker *  pickView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 200, 320, 200)];
    //        //        pickView.delegate = self;
    //        //        pickView.dataSource = self;
    //        //        pickView.showsSelectionIndicator = YES;
    //        return pickView;
    //    }
    return myInputView;
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//- (void)didMoveToSuperview
//{
//    [m_dblMultiColTbv reloadData];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.origin.y = 0.0;
    frame.size.height -= self.bounds.origin.y;
    m_dblMultiColTbv.frame = frame;
    if (m_toolbarBottom)
    {
        frame.size.height -= m_fHeightToolbarBottom;
        m_dblMultiColTbv.frame = frame;
        frame.origin.y = m_dblMultiColTbv.frame.size.height + m_dblMultiColTbv.frame.origin.y;
        frame.size.height = m_fHeightToolbarBottom;
        m_toolbarBottom.frame = frame;
    }

}

- (void)setupDefaultBottomToolbar
{
    m_toolbarBottom = [[UIToolbar alloc] init];
    [self addSubview:m_toolbarBottom];
    
    NSMutableArray *myToolBarItems = /*[[*/[NSMutableArray array]/* retain] autorelease]*/;
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    [myToolBarItems addObject:btnItem];
//    [btnItem release];
    btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [myToolBarItems addObject:btnItem];
//    [btnItem release];
    btnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"箭头-左.png"] style:UIBarButtonItemStylePlain target:self action:@selector(lastPage)];
    [myToolBarItems addObject:btnItem];
    
    m_barBtnItemTitle = [[UIBarButtonItem alloc] initWithTitle:self.strToolbarMiddleTitle style:UIBarButtonItemStylePlain target:self action:nil];
    [myToolBarItems addObject:m_barBtnItemTitle];
    
    btnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"箭头-右.png"] style:UIBarButtonItemStylePlain target:self action:@selector(nextPage)];
    [myToolBarItems addObject:btnItem];
    
    btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [myToolBarItems addObject:btnItem];

    btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(loadMore)];
    [myToolBarItems addObject:btnItem];
    [m_toolbarBottom  setItems:myToolBarItems animated:YES];
}

- (void)reloadData
{
    [m_dblMultiColTbv reloadData];
}

#pragma mark - ZWDblMultiColTbvDataSource

- (void)refresh
{
    if (m_bRespondsToRefresh)
        [dataSource refresh];
}

- (void)loadMore
{
    if (m_bRespondsToLoadMore)
        [dataSource loadMore];
}
- (void)lastPage
{
    if (m_bRespondsToLastPage)
        [dataSource lastPage];
}
- (void)nextPage
{
    if (m_bRespondsToNextPage)
        [dataSource nextPage];
}
@end
