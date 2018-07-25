//
//  PhotoViewCell.h
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoImageView, Photo;

UIKIT_EXTERN NSString *const PhotoViewCellIdentifier;

@interface PhotoViewCell : UICollectionViewCell

/** 图片模型 */
@property (nonatomic, strong) Photo *photo;
/** 本地相册图片 */
@property (nonatomic, strong) UIImage *image;
/** cell上的photoView */
@property (nonatomic, weak) PhotoImageView *photoView;
/** 存储cell的collectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 放在最底下的contentScrollView(所有子控件都添加在这里) */
@property (nonatomic, weak) UIScrollView *contentScrollView;

/** 快速创建PYPhotoCell的方法 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;


@end
