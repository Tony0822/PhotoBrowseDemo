//
//  GCYPhotoGroupCell.m
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/28.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "GCYPhotoGroupCell.h"
#import "GCYPhotoGroupModel.h"

@interface GCYPhotoGroupCell ()
/**
 *  缩略图
 */
@property (nonatomic, strong) UIImageView *thumbImage;
/**
 *  组名
 */
@property (nonatomic, strong) UILabel *groupName;
/**
 *  图片个数
 */
@property (nonatomic, strong) UILabel *imageCount;

@end

@implementation GCYPhotoGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.thumbImage];
        [self.contentView addSubview:self.groupName];
        [self.contentView addSubview:self.imageCount];
    }
    return self;
}
- (void)setGroupModel:(GCYPhotoGroupModel *)groupModel {
    _groupModel = groupModel;
    
    self.thumbImage.image = groupModel.thumbImage;
    self.groupName.text = groupModel.groupName;
    self.imageCount.text = [NSString stringWithFormat:@"(%zd)",groupModel.assetsCount];
    
    self.thumbImage.frame = CGRectMake(0, 0, 80, 80);
    self.groupName.frame = CGRectMake(CGRectGetMaxX(self.thumbImage.frame) + KMARGIN, 0, [self.groupName.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}].width + KMARGIN*0.5, self.thumbImage.height);
    self.imageCount.frame = CGRectMake(CGRectGetMaxX(self.groupName.frame) + KMARGIN, 0, [self.imageCount.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}].width + KMARGIN, self.thumbImage.height);

}
#pragma mark -- lazy
- (UIImageView *)thumbImage{
    if (!_thumbImage) {
        _thumbImage = [[UIImageView alloc]init];
        [_thumbImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _thumbImage.contentMode =  UIViewContentModeScaleAspectFill;
        _thumbImage.clipsToBounds  = YES;
    }
    return _thumbImage;
}

- (UILabel *)groupName{
    if (!_groupName) {
        _groupName = [[UILabel alloc]init];
        _groupName.textColor = [UIColor blackColor];
        _groupName.font = FONTSIZE(15);
    }
    return _groupName;
}

- (UILabel *)imageCount{
    if (!_imageCount) {
        _imageCount = [[UILabel alloc]init];
        _imageCount.textColor = [UIColor grayColor];
        _imageCount.font = FONTSIZE(15);
    }
    return _imageCount;
}


@end
