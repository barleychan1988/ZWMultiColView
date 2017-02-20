//
//  ZWMultiColTbvDefine.h
//  ZWMultiTbv
//
//  Created by chenzhengwang on 13-12-6.
//  Copyright (c) 2013年 zwchen. All rights reserved.
//

#ifndef ZWMultiTbv_ZWMultiColTbvDefine_h
#define ZWMultiTbv_ZWMultiColTbvDefine_h

//判断设备是iphone5或者iphone4
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define ZWMultiColTbv_BorderColorGray 212.0f/255.0f
#define ZWMultiColTbv_BorderWidth 1.0f
#define ZWMultiColTbv_CornerRadius 3.0f

#define ZWMultiColTbv_LineGray 223.0f/255.0f
#define ZWMultiColTbv_BoldLineWidth 2.0f
#define ZWMultiColTbv_NormalLineWidth 1.0f

#define ZWMultiColTbv_TopHeaderBkgndColor 235.0f/255.0f

#endif
