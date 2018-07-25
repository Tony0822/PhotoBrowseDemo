//
//  GCYPhotoManager.m
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/24.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "GCYPhotoManager.h"
#import "GCYPhotoAuthor.h"
#import "GCYPhotoGroupListController.h"
#import "GCYPhotoModel.h"

@interface GCYPhotoManager ()
@property(nonatomic,strong) NSOperationQueue *imageQueue;
@end

@implementation GCYPhotoManager
+ (GCYPhotoManager *)sharedPhotoManager{
    
    static GCYPhotoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GCYPhotoManager alloc]init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSOperationQueue *)imageQueue{
    
    if (!_imageQueue) {
        
        _imageQueue = [[NSOperationQueue alloc] init];;
        _imageQueue.maxConcurrentOperationCount = 1;
    }
    return _imageQueue;
}

- (void)openPhotoListWithController:(UIViewController *)viewController {
    [self openPhotoListWithController:viewController MaxImageCount:9];
}

- (void)openPhotoListWithController:(UIViewController *)viewController MaxImageCount:(NSInteger)maxImageCount {
    [GCYPhotoAuthor checkPhotoAuthorSuccess:^{
        GCYPhotoGroupListController *photoCtrl = [[GCYPhotoGroupListController alloc] init];
        photoCtrl.maxImageCount = maxImageCount;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoCtrl];
        [viewController presentViewController:nav animated:YES completion:nil];
    } Failure:^(NSString *message) {
        
    }];
}

- (void)sendSeletedPhotosWithArray:(NSArray *)imageArray success:(void (^)(BOOL))success {
    NSMutableArray *thumbImageArr = [NSMutableArray array];
    NSMutableArray *originalImageArr = [NSMutableArray array];
    __block NSInteger imageCount = 0;
    
    for (GCYPhotoModel *model in imageArray) {
        [model thumbImageWithBlock:^(UIImage *thumbImage) {
            [thumbImageArr addObject:thumbImage];
        }];
        
    }
}

- (void)cancelChoosePhoto {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel)]) {
        [self.delegate imagePickerControllerDidCancel];
    }
}
@end
