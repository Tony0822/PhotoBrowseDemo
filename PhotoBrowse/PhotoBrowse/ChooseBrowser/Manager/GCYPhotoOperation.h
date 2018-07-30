//
//  GCYPhotoOperation.h
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCYPhotoModel.h"
/**
 NSOperation是个抽象类,并不具备封装操作的能力,必须使⽤它的子类
 使用NSOperation⼦类的方式有3种：
 （1）NSInvocationOperation
 （2）NSBlockOperation
 （3）自定义子类继承NSOperation,实现内部相应的⽅法
 */

@interface GCYPhotoOperation : NSOperation

+ (instancetype)addOperationWithModel:(GCYPhotoModel *)model completeBlock:(GetFullScreenImageBlock)completeBlock;


@end
