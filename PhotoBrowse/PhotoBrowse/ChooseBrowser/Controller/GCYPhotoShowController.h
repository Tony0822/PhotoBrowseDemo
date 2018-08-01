//
//  GCYPhotoShowController.h
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GCYPhotoModel;

@protocol GCYPhotoShowControllerDelegate <NSObject>

- (void)tapImage;

@end

@interface GCYPhotoShowController : UIViewController

- (instancetype)initWithImageModel:(GCYPhotoModel *)model SelectedIndex:(NSInteger)index;

/** delegate */
@property(nonatomic,assign) id<GCYPhotoShowControllerDelegate> delegate;
/** 当前点击的序号 */
@property(nonatomic,assign)NSInteger  selectIndex;
/** 当前显示图片的View */
@property(nonatomic,strong) UIImageView *imageV;
@end
