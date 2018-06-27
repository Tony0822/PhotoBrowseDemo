//
//  ADView.h
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/26.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SkipButtonType) {
    SkipButtonTypeNormalTimeAndText = 0,      //普通的倒计时+跳过
    SkipButtonTypeCircleAnimationTest,        //圆形动画+跳过
    SkipButtonTypeNormalText,                 //只有普通的跳过
    SkipButtonTypeNormalTime,                 //只有普通的倒计时
    SkipButtonTypeNone                        //无
};

//可以根据需要添加一些相应的参数
typedef void(^adImageBlock)(NSString *content);

@interface ADView : UIImageView

/** 广告图的显示时间（默认5秒）*/
@property (nonatomic, assign) NSUInteger duration;

/** 获取数据前，启动图的等待时间（若不设置则不启动等待机制）*/
@property (nonatomic, assign) NSUInteger waitTime;

/** 右上角按钮的样式（默认倒计时+跳过）*/
@property (nonatomic, assign) SkipButtonType skipType;

/** 广告图点击事件回调*/
@property (nonatomic, copy) adImageBlock adImageTapBlock;

/** 加载广告图*/
- (void)reloadAdImageWithUrl:(NSString *)urlStr;

@end
