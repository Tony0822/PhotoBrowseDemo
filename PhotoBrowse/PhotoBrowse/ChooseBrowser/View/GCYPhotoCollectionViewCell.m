//
//  GCYPhotoCollectionViewCell.m
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/28.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "GCYPhotoCollectionViewCell.h"
#import "GCYPhotoModel.h"

@interface GCYPhotoCollectionViewCell ()
@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *videoImage;
@property (nonatomic, strong) UILabel *videoTime;

@end

@implementation GCYPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self.contentView addSubview:self.photoImage];
        [self.contentView addSubview:self.selectBtn];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.videoImage];
        [self.contentView addSubview:self.videoTime];
    }
    return self;
}
- (void)setPhotoModel:(GCYPhotoModel *)photoModel{
    
    _photoModel = photoModel;
    
    [photoModel thumbImageWithBlock:^(UIImage *thumbImage) {
        self.photoImage.image = thumbImage;
    }];

    self.selectBtn.selected = photoModel.isSelect;
    [self.selectBtn setTitle:[NSString stringWithFormat:@"%zd",photoModel.chooseIndex] forState:UIControlStateSelected];

    self.selectBtn.hidden = photoModel.isVideoType;
    self.bottomView.hidden = !photoModel.isVideoType;
    self.videoImage.hidden = !photoModel.isVideoType;
    self.videoTime.hidden = !photoModel.isVideoType;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.photoImage.frame = self.bounds;
    CGFloat btnWidth = 27;
    CGFloat videoWidth = 15;
    self.selectBtn.frame = CGRectMake(self.width - KMARGIN - btnWidth, KMARGIN, btnWidth, btnWidth);
    self.bottomView.frame = CGRectMake(0, self.height-2*KMARGIN, self.width, 2*KMARGIN);
    self.videoImage.frame = CGRectMake(KMARGIN*0.5, self.bottomView.height - videoWidth, videoWidth, videoWidth);
    self.videoTime.frame = CGRectMake(self.width-40-KMARGIN*0.5, 0, videoWidth, videoWidth);
    
}

#pragma mark -- action
- (void)clickSelectBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(thumbImageSeletedChooseIndexPath:selectedBtn:)]) {
        [self.delegate thumbImageSeletedChooseIndexPath:self.photoModel.indexPath selectedBtn:self.selectBtn];
    }
}
#pragma mark -- lazy
- (UIImageView *)photoImage{
    if (!_photoImage) {
        _photoImage = [[UIImageView alloc]init];
        [_photoImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _photoImage.contentMode =  UIViewContentModeScaleAspectFill;
        _photoImage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _photoImage.clipsToBounds  = YES;
    }
    return _photoImage;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]init];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectIcon_27x27_"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectIcon_27x27_"] forState:UIControlStateHighlighted];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectYIcon_27x27_"] forState:UIControlStateSelected];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_selectBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_selectBtn addTarget:self action:@selector(clickSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor blackColor];
        _bottomView.alpha = 0.5;
    }
    return _bottomView;
}

- (UIImageView *)videoImage{
    if (!_videoImage) {
        _videoImage = [[UIImageView alloc]init];
        _videoImage.image = [UIImage imageNamed:@"News_VideoBIG_31x31_"];
    }
    return _videoImage;
}

- (UILabel *)videoTime{
    if (!_videoTime) {
        _videoTime = [[UILabel alloc]init];
        _videoTime.textColor = [UIColor whiteColor];
        _videoTime.textAlignment = NSTextAlignmentRight;
        _videoTime.font = FONTSIZE(10);
    }
    return _videoTime;
}


@end
