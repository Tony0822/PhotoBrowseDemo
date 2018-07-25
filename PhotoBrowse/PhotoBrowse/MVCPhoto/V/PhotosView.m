//
//  PhotosView.m
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "PhotosView.h"
#import "Photo.h"

@interface PhotosView ()

/** 图片大小*/
@property (nonatomic, assign) CGSize photoSize;

/** 添加图片按钮*/
@property (nonatomic, strong) UIButton *addImageButton;

/** 记录scrollerView的x值 */
@property (nonatomic, assign) CGFloat originalX;

@end

@implementation PhotosView

@dynamic delegate;

@end
