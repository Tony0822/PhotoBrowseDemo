//
//  GCYChoosePictureView.h
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/24.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCYChoosePictureView : UIView

/** viewController */
@property(nonatomic,strong) UIViewController *superViewController;

/**
 图片的数组
 */
@property(nonatomic,strong) NSMutableArray<UIImage *> *imageArray;


@end
