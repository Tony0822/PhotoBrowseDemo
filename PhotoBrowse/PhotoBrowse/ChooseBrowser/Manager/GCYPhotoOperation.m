//
//  GCYPhotoOperation.m
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "GCYPhotoOperation.h"

@interface GCYPhotoOperation ()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;
@property(nonatomic, copy) GetFullScreenImageBlock finishedBlock;

@property(nonatomic, strong) GCYPhotoModel *model;

@end

@implementation GCYPhotoOperation

@synthesize finished = _finished;
@synthesize executing = _executing;


- (instancetype)init {
    self = [super init];
    if (self) {
        _finished = NO;
        _executing = NO;
    }
    return self;
}

+ (instancetype)addOperationWithModel:(GCYPhotoModel *)model completeBlock:(GetFullScreenImageBlock)completeBlock {
    
    GCYPhotoOperation *op = [[GCYPhotoOperation alloc] init];
    op.model = model;
    op.finishedBlock = completeBlock;
    return op;
}

- (void)start {
    if ([self isCancelled]) {
        _finished = YES;
        return;
    }
    
    _executing = NO;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.model fullScreenImageWithBlock:^(UIImage *fullScreenImage, BOOL isFull) {
            if (isFull) {
                self.finished = YES;
            }
            if (self.finishedBlock) {
                self.finishedBlock(fullScreenImage, isFull);
            }
        }];
        
    }];
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
