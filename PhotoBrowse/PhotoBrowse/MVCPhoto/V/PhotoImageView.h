//
//  PhotoImageView.h
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoImageView, Photo, PhotosView;

@protocol PhotoImageViewDelegate <NSObject>

@optional
/**
 单击
 */
- (void)didSingleClick:(PhotoImageView *)photoImageView;
/**
 长按
 */
- (void)didLongClick:(PhotoImageView *)photoImageView;
/**
 删除
 */
- (void)didDeleteClick:(PhotoImageView *)photoImageView;

@end

@interface PhotoImageView : UIImageView

/** 图片模型 */
@property (nonatomic, strong) Photo *photo;
/** 网络图片*/
@property (nonatomic, copy) NSArray<Photo *> *photos;
/** 本地相册图片 */
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;
/** 是否放大状态 */
@property (nonatomic, assign) BOOL isBig;
/** 是否正在预览*/
@property (nonatomic, assign) BOOL isPreview;
/** 原来的frame*/
@property (nonatomic, assign) CGRect orignalFrame;
/** 放大的倍数 */
@property (nonatomic, assign) CGFloat scale;
/** 判断是否是旋转手势 */
@property (nonatomic, assign, getter=isRotationGesture) BOOL rotationGesture;
/** 在window呈现的view*/
@property (nonatomic, strong) PhotoImageView *windowView;







@property (nonatomic, weak) id<PhotoImageViewDelegate> delegate;

@end
