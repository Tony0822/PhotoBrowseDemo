//
//  GCYPhotoKitManager.h
//  PhotoBrowse
//
//  Created by TonyYang on 2018/6/29.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCYPhotoGroupModel;

@interface GCYPhotoKitManager : NSObject

/**
 获取单例
 
 @return 单例
 */
+ (GCYPhotoKitManager *)sharedPhotoKitManager;

/**
 获取所有相册组
 
 @return 相册组Model集合
 */
- (NSArray *)getPhotoGroupArray;

/**
 通过相册组的Model,获取当前相册的所有相片Model
 
 @param groupModel 相册组的Model
 
 @return 单独一个相册的数据
 */
- (NSArray *)getPhotoListWithModel:(GCYPhotoGroupModel *)groupModel;


@end
