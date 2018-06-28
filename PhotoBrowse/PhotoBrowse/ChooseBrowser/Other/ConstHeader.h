//
//  ConstHeader.h
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/28.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//


#import <Foundation/Foundation.h>

//获取屏幕 宽度、高度
#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)
#define KMARGIN 10//默认间距
#define FONTSIZE(x)  [UIFont systemFontOfSize:x]//设置字体大小
#define WEAK_SELF(value) __weak typeof(self) value = self

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define KNAVHEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)
