//
//  GCYPhotoModel.m
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/28.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "GCYPhotoModel.h"

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
    return nil;
}

- (void)thumbImageWithBlock:(GetThumbImageBlock)GetThumbImageBlock {
    
}

-(void)fullScreenImageWithBlock:(GetFullScreenImageBlock)GetFullScreenImageBlock {
    
}
#pragma mark -- private

- (void)getOriginalImageSizeWithAsset:(PHAsset *)phAsset {

}
- (void)setPhAsset:(PHAsset *)phAsset {
    _phAsset = phAsset;
    //图片的属性
    [self getOriginalImageSizeWithAsset:phAsset];
}


@end
