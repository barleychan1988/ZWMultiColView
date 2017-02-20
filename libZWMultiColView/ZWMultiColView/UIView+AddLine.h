/*
 * Copyright (c) 2005,深圳市慧视通科技股份有限公司软件开发中心
 * All rights reserved.
 *
 * 文件名称：filename.h
 * 文件标识：见配置管理计划书
 * 摘要：the function of this category is adding line on view.
 *
 * 当前版本：1.0
 * 作 者：chenzhengwang
 * 完成日期：2013.12.06
 *
 */

#import <UIKit/UIKit.h>

@interface UIView(AddLine)

/*
 *  @description:在View的上边栏添加横线
 *  @param [in]:width:线条的粗度；color:线条的颜色
 *  @ret: 线条View
 */
- (UIView *)addTopLineWithWidth:(CGFloat)width color:(UIColor *)color;
/*
 *  @description:在View的下边栏添加横线
 *  @param [in]:width:线条的粗度；color:线条的颜色
 *  @ret: 线条View
 */
- (UIView *)addBottomLineWithWidth:(CGFloat)width color:(UIColor *)color;
/*
 *  @description:在View的x开始位置上添加竖线
 *  @param [in]:width:线条的宽度；color:线条的颜色
 *  @ret: 线条View
 */
- (UIView *)addVerticalLineWithWidth:(CGFloat)width color:(UIColor *)color atX:(CGFloat)x;
/*
 *  @description:在View上的矩形区内添加指定颜色的View
 *  @param [in]:rect:矩形区；color:矩形区颜色
 *  @ret: 线条View
 */
- (UIView *)addLineWithRect:(CGRect)rect color:(UIColor *)color;

@end
