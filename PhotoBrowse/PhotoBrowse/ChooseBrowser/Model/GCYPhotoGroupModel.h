//
//  GCYPhotoGroupModel.h
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/28.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

/**
 相册组列表model
 */
@interface GCYPhotoGroupModel : NSObject
/** 相册组名 */
@property (nonatomic, copy) NSString *groupName;

/** 相册组缩略图 */
@property (nonatomic, strong) UIImage *thumbImage;

/** 单个相册图片总数 */
@property (nonatomic, assign) NSInteger assetsCount;

/** 相册的类型 Saved Photos... */
@property (nonatomic, copy) NSString *type;

/** PHotoKit group
PHCollection的子类，单个资源的集合，如相册、时刻等
 */
@property(nonatomic, strong) PHAssetCollection *assetCollection;

@end
