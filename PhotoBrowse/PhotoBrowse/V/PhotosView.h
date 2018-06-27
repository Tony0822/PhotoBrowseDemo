//
//  PhotosView.h
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotosView, Photo;


typedef NS_ENUM(NSInteger, PhotosViewLayoutType) {
    PhotosViewLayoutTypeFlow = 0, // 流水
    PhotosViewLayoutTypeLine // 线性
};

typedef NS_ENUM(NSInteger, PhotosViewState) {
    PhotosViewStateWillCompose = 0, // 将要发布
    PhotosViewStateDidCompose
};

typedef NS_ENUM(NSInteger, PhotosViewPageType) {
    PhotosViewPageTypeControll = 0, // 图片超过9张，Label显示
    PhotosViewPageTypeLabel
};


@protocol PhotosViewDelegate <NSObject, UIScrollViewDelegate>

@optional
/**
 * 添加图片按钮选中时调用此方法
 * images : 当前存在的图片（未发布）数组
 */
- (void)photosView:(PhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images;

/**
 * 删除图片按钮触发时调用此方法
 * imageIndex : 删除的图片在之前图片数组的位置
 */
- (void)photosView:(PhotosView *)photosView didDeleteImageIndex:(NSInteger)imageIndex;

/**
 * 图片未发布时进入浏览图片时调用此方法
 * previewControlelr : 预览图片时的控制器
 */
//- (void)photosView:(PhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr;

/**
 * 图片浏览将要显示时调用
 */
- (void)photosView:(PhotosView *)photosView willShowWithPhotos:(NSArray<Photo *> *)photos index:(NSInteger)index;
/**
 * 图片浏览已经显示时调用
 */
- (void)photosView:(PhotosView *)photosView didShowWithPhotos:(NSArray<Photo *> *)photos index:(NSInteger)index;
/**
 * 图片浏览将要隐藏时调用
 */
- (void)photosView:(PhotosView *)photosView willHiddenWithPhotos:(NSArray<Photo *> *)photos index:(NSInteger)index;
/**
 * 图片浏览已经隐藏时调用
 */
- (void)photosView:(PhotosView *)photosView didHiddenWithPhotos:(NSArray<Photo *> *)photos index:(NSInteger)index;

@end


@interface PhotosView : UIScrollView

/** 占位图 */
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSArray<Photo *> *photos;
/** 网络图片地址数组（缩略图） */
@property (nonatomic, strong) NSArray<NSString *> *thumbnailURLs;
/** 网络图片地址数组（原图） */
@property (nonatomic, strong) NSArray<NSString *> *originalURLs;
/** 本地相册图片(注意：存的是UIImage或者NSString)数组(默认最多为九张,当传入图片数组长度超过九张时，取前九张) */
@property (nonatomic, strong) NSMutableArray *images;
/** 所有图片的状态（默认为已发布状态） */
@property (nonatomic, assign) PhotosViewState photoState;
/** 图片布局（默认为流水布局） */
@property (nonatomic, assign) PhotosViewLayoutType layoutType;
/** 图片分页指示类型(默认为pageControll。当图片超过九张，改为label显示) */
@property (nonatomic, assign) PhotosViewPageType pageType;
/** 是否隐藏指示器，默认为：NO */
@property (nonatomic, assign) BOOL hidePageControl;
/** 是否隐藏删除按钮(未发布状态) */
@property (nonatomic, assign) BOOL hideDeleteView;
/** 图片间距（默认为5） */
@property (nonatomic, assign) CGFloat photoMargin;
/** 图片的宽 (默认为70) */
@property (nonatomic, assign) CGFloat photoWidth;
/** 图片的高 (默认为70) */
@property (nonatomic, assign) CGFloat photoHeight;
/** 每行最多个数（默认为3）, 当图片布局为线性布局时，此设置失效 */
@property (nonatomic, assign) NSInteger photosMaxCol;
/** 当图片上传前，最多上传的张数，默认为9 */
@property (nonatomic, assign) NSInteger imagesMaxCountWhenWillCompose;
/** 当图片只有一张时, 图片是否充满photosView, 默认：NO */
@property (nonatomic, assign) BOOL oneImageFullFrame;
/** 当图片原图加载完毕，原图是否替换预览图, 默认：YES */
@property (nonatomic, assign) BOOL replaceThumbnailWhenOriginalDownloaded;
/** 当屏幕旋转时，是否自动旋转图片 默认为YES */
@property (nonatomic, assign) BOOL autoRotateImage;
/** 当图片为4张时显示为是否两行两列，默认为YES */
@property (nonatomic, assign) BOOL autoLayoutWithWeChatSytle;
/** 是否自动设置图片可编辑状态 */
@property (nonatomic, assign) BOOL autoSetPhotoState;
/** 显示动画时长：（默认0.5s） */
@property (nonatomic, assign) CGFloat showDuration;
/** 隐藏动画时长：（默认0.5s） */
@property (nonatomic, assign) CGFloat hiddenDuration;

@property (nonatomic, weak) id<PhotosViewDelegate> delegate;
/** 快速创建photosView对象 */
+ (instancetype)photosView;
/** photos : 保存图片链接的数组 */
+ (instancetype)photosViewWithThumbnailUrls:(NSArray<NSString *> *)thumbnailUrls originalUrls:(NSArray<NSString *> *)originalUrls;
/** images : 存储本地图片的数组 */
+ (instancetype)photosViewWithImages:(NSMutableArray<UIImage *> *)images;

/**
 * thumbnailUrls : 保存图片(缩略图)链接的数组
 * originalUrls : 保存图片(原图)链接的数组
 * type : 布局类型（默认为流水布局）
 */
+ (instancetype)photosViewWithThumbnailUrls:(NSArray<NSString *> *)thumbnailUrls originalUrls:(NSArray<NSString *> *)originalUrls layoutType:(PhotosViewLayoutType)type;
/**
 * thumbnailUrls : 保存图片(缩略图)链接的数组
 * originalUrls : 保存图片(原图)链接的数组
 * maxCol : 每行最多显示图片的个数
 */
+ (instancetype)photosViewWithThumbnailUrls:(NSArray<NSString *> *)thumbnailUrls originalUrls:(NSArray<NSString *> *)originalUrls photosMaxCol:(NSInteger)maxCol;

/** 根据图片个数和图片状态自动计算出PYPhontosView的size */
- (CGSize)sizeWithPhotoCount:(NSInteger)count photosState:(NSInteger)state;

/**
 * 刷新图片(未发布)
 * images : 新的图片数组
 */
- (void)reloadDataWithImages:(NSMutableArray<UIImage *> *)images;
/** 根据图片个数刷新界面尺寸 */
- (void)refreshContentSizeWithPhotoCount:(NSInteger)photoCount;






@end
