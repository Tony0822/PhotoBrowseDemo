//
//  GCYPhotoAuthor.h
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/28.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CheckSuccess)(void);
typedef void(^CheckFailure)(NSString *message);


/**
 相册相机权限
 */
@interface GCYPhotoAuthor : NSObject
/**
 检查相册权限
 
 @param success 已授权
 @param failure 未授权
 */
+ (void)checkPhotoAuthorSuccess:(CheckSuccess)success Failure:(CheckFailure)failure;

/**
 检查相机权限
 
 @param success 已授权
 @param failure 未授权
 */
+ (void)checkCameraAuthorSuccess:(CheckSuccess)success Failure:(CheckFailure)failure;

@end
