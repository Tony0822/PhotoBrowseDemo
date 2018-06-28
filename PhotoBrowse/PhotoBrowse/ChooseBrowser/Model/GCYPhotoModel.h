//
//  GCYPhotoModel.h
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/28.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^GetThumbImageBlock)(UIImage *thumbImage);
typedef void(^GetFullScreenImageBlock)(UIImage *fullScreenImage,BOOL isFull);
typedef void(^GetFullResolutDataBlock)(NSData *fullResolutData);
typedef void(^GetFullResolutDataSizeBlock)(CGFloat fullResolutDataSize);
typedef void(^GetFullScreenImageDataBlock)(NSData *fullScreenImageData);

/**
 相册组的列表model
 */
@interface GCYPhotoModel : NSObject

/**
 该类表示具体的资源信息，如宽度、高度、时长、是否是收藏的等等。同上面提到的几个类一样，该类的属性也都是只读的，所以我们主要是用它的方法来获取资源。
 */
@property (nonatomic, strong) PHAsset *phAsset;
/** 原图的本地路径 */
@property (nonatomic, strong) NSString *originalImageFileURL;
/** 原图的data */
@property (nonatomic, strong) NSData *originalImageData;
/** 原图片的大小 */
@property (nonatomic, assign) CGFloat originalImageSize;
/** 获取是否是视频类型, Default = false */
@property (nonatomic, assign) BOOL isVideoType;
/** 是否显示原图(后续发送的时候判断是否发送原图) */
@property (nonatomic, assign) BOOL isShowFullImage;
/** 是否被选中 */
@property (nonatomic, assign)BOOL isSelect;
/** 选中的顺序 */
@property (nonatomic, assign) NSInteger chooseIndex;
/** 当前点击的indexPath */
@property (nonatomic, strong) NSIndexPath *indexPath;


/**
 用于处理资源的加载，加载图片的过程带有缓存处理，可以通过传入一个 PHImageRequestOptions 控制资源的输出尺寸等规格
 */
+ (PHImageManager *)sharedPHImageManager;

/** 获取视频的时长 */
- (NSString *)videoTime;
/** 获取缩略图 */
- (void)thumbImageWithBlock:(GetThumbImageBlock)GetThumbImageBlock;
/** 获取屏幕大小的原图 */
- (void)fullScreenImageWithBlock:(GetFullScreenImageBlock)GetFullScreenImageBlock;

@end
