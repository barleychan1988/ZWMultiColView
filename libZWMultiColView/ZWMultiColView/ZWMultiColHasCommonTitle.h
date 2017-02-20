//
//  ZWMultiColHasCommonTitle.h
//  ZWMultiTbv
//
//  Created by chenzhengwang on 13-12-6.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

/*
 * Copyright (c) 2005,深圳市慧视通科技股份有限公司软件开发中心
 * All rights reserved.
 *
 * 文件名称：ZWMultiColHasCommonTitle.h
 * 文件标识：
 * 摘要：该对象主要是用于记录相邻的多列具有共同标题.
 *      _______________________________
 *      |        strCommonTitle       |
 *      |-----------------------------|
 *      |_title1_|__title2__|_title2__|
 *
 * 当前版本：1.0
 * 作 者：chenzhengwang
 * 完成日期：2013.12.06
 *
 */

#import <Foundation/Foundation.h>

@interface ZWMultiColHasCommonTitle : NSObject

//开始具有共同标题的列下标
@property (nonatomic, assign)NSInteger nStartCol;
//具有共同标题的列数
@property (nonatomic, assign)NSInteger nNum;
//共同标题内容
@property (nonatomic, copy)NSString *strTitle;

@end
