//
//  Photo.h
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 用于存储照片对象的Model 暂不支持GIF
 使用FLAnimatedImage第三方 便可支持GIF
 */
@interface Photo : NSObject


/**
 缩略图URL
 */
@property (nonatomic, copy) NSString *thumbnailURL;

/**
 原型图URL
 */
@property (nonatomic, copy) NSString *originalURL;

/**
 缩略图
 */
@property (nonatomic, strong) UIImage *thumbnailImage;

/**
 原型图
 */
@property (nonatomic, strong) UIImage *originalImage;

/**
 进度
 */
@property (nonatomic, assign) CGFloat progress;

/**
 记录旋转前大小，最开始的大小
 */
@property (nonatomic, assign) CGSize originalSize;

/**
 旋转时，默认的宽度
 */
@property (nonatomic, assign) CGFloat verticalWidth;

/**
 根据缩略图创建模型
 */
+ (instancetype)photoWithThumbnailURL:(NSString *)thumbnailURL;

/**
 根据原型图创建模型
 */
+ (instancetype)photoWithOriginalURL:(NSString *)OriginalURL;


@end
