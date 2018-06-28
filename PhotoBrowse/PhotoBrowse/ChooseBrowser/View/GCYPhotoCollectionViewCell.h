//
//  GCYPhotoCollectionViewCell.h
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/28.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCYPhotoCollectionViewCellDelegate <NSObject>

- (void)thumbImageSeletedChooseIndexPath:(NSIndexPath *)indexPath selectedBtn:(UIButton *)selectedBtn;

@end

@class GCYPhotoModel;

@interface GCYPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<GCYPhotoCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) GCYPhotoModel *photoModel;


@end
