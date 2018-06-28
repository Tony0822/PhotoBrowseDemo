//
//  GCYPhotoModel.m
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/28.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "GCYPhotoModel.h"
#import <objc/runtime.h>

const char * kThumbImageKey = "kThumbImageKey";//缩略图
const char * kFullScreenImageKey = "kFullScreenImageKey";//屏幕大小图
const char * kOriginalImageKey = "kOriginalImageKey";//原图
const char * kPHImageFileURLKey = "kPHImageFileURLKey";//原图本地路径
const char * kOriginalImageData = "kOriginalImageData";//原图data
const char * kOriginalImageSize = "kOriginalImageSize";//原图大小


@implementation GCYPhotoModel

+ (PHImageManager *)sharedPHImageManager {
    static PHImageManager *imageManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageManger = [[PHImageManager alloc] init];
    });
    return imageManger;
}

- (NSString *)videoTime {
    NSInteger time = (NSInteger)self.phAsset.duration;
    NSInteger minute = time / 60;
    CGFloat second = time % 60;
    return [NSString stringWithFormat:@"%zd:%.2f",minute,second];
}

- (void)thumbImageWithBlock:(GetThumbImageBlock)GetThumbImageBlock {
    //取出关联对象 所关联的值
    UIImage *image = objc_getAssociatedObject(self, kThumbImageKey);
    if (image != nil) {
        GetThumbImageBlock(image);
        return;
    }
    
    CGFloat itemWH = (SCREENWIDTH - (4+1)*KMARGIN*0.5)/4;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    
    [[GCYPhotoModel sharedPHImageManager] requestImageForAsset:self.phAsset
                                                    targetSize:CGSizeMake(itemWH*screenScale, itemWH*screenScale)
                                                   contentMode:PHImageContentModeDefault
                                                       options:options
                                                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    // 此处设置关联对象
                                                     objc_setAssociatedObject(self, kThumbImageKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                                 }];
    
}

-(void)fullScreenImageWithBlock:(GetFullScreenImageBlock)GetFullScreenImageBlock {
    
}
#pragma mark -- private

- (void)getOriginalImageSizeWithAsset:(PHAsset *)phAsset {
    [[GCYPhotoModel sharedPHImageManager] requestImageDataForAsset:phAsset
                                                           options:nil
                                                     resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                         CGFloat dataSize = imageData.length/(1024*1024.0);
                                                         objc_setAssociatedObject(self, kOriginalImageSize, [NSString stringWithFormat:@"%f", dataSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                                         objc_setAssociatedObject(self, kOriginalImageData, imageData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                                         objc_setAssociatedObject(self, kPHImageFileURLKey, [info objectForKey:@"PHImageFileURLKey"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                                     }];
}
- (void)setPhAsset:(PHAsset *)phAsset {
    _phAsset = phAsset;
    //图片的属性
    [self getOriginalImageSizeWithAsset:phAsset];
}


@end
