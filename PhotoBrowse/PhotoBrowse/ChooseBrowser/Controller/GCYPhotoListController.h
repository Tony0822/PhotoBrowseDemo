//
//  GCYPhotoListController.h
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCYPhotoGroupModel;

@interface GCYPhotoListController : UIViewController
@property (nonatomic, strong) GCYPhotoGroupModel *groupModel;
@property (nonatomic, assign) NSInteger maxImageCount;

@end
