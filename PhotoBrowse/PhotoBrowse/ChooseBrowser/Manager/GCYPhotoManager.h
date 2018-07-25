//
//  GCYPhotoManager.h
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/24.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GCYPhotoManagerDelegate <NSObject>
/**
 取消选择图片
 */
- (void)imagePickerControllerDidCancel;

/**
 完成选择图片
 
 @param thumbImages 缩略图
 @param originalImages 原图
 */
- (void)imagePickerControllerDidFinishPickingMediaWithThumbImages:(NSArray *)thumbImages originalImages:(NSArray *)originalImages;

@end

@interface GCYPhotoManager : NSObject

/**
 使用单例调用启动方法

 */
+ (GCYPhotoManager *)sharedPhotoManager;

/**
 启动图片选择器 默认最多选择9个
 
 @param viewController 当前所在的控制器
 */
- (void)openPhotoListWithController:(UIViewController *)viewController;

/**
 启动图片选择器
 
 @param viewController 当前所在的控制器
 @param maxImageCount 最大图片选择数(默认可不传,使用上面接口 设为9)
 */
- (void)openPhotoListWithController:(UIViewController *)viewController MaxImageCount:(NSInteger)maxImageCount;

/**
 发送照片
 
 @param imageArray 已选中的照片
 */
- (void)sendSeletedPhotosWithArray:(NSArray *)imageArray success:(void(^)(BOOL isSuccess))success;

/**
 关闭相册
 */
- (void)cancelChoosePhoto;


@property(nonatomic, weak) id<GCYPhotoManagerDelegate> delegate;




@end
