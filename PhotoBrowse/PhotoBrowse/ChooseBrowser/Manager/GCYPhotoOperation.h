//
//  GCYPhotoOperation.h
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCYPhotoModel.h"

@interface GCYPhotoOperation : NSOperation

+ (instancetype)addOperationWithModel:(GCYPhotoModel *)model completeBlock:(GetFullScreenImageBlock)completeBlock;


@end
