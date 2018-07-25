//
//  GCYChoosePictureView.m
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/24.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "GCYChoosePictureView.h"
#import "GCYPhotoAuthor.h"
#import "GCYPhotoManager.h"
#import "GCYShowBigImageView.h"

#define KitemWidth (self.width - 20) / 3.0

@interface GCYChoosePictureView ()<UICollectionViewDelegate, UICollectionViewDataSource, GCYPhotoManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property(nonatomic,weak) UIButton *addBtn;
@property(nonatomic,weak) UICollectionView *collectionView;

@end

@implementation GCYChoosePictureView



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(KitemWidth, KitemWidth);
   
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KitemWidth, KitemWidth)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_pic"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(p_AddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    self.addBtn = addBtn;
}
#pragma mark -- Action
- (void)p_CloseImage:(UIButton *)closeBtn {
    
    [self.collectionView  performBatchUpdates:^ {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:closeBtn.tag inSection:0];
        [self.imageArray removeObjectAtIndex:closeBtn.tag];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    } completion:^(BOOL finished) {
        [self.collectionView  reloadData];
        
    }];
    [self p_ChangeBtnFrame];
}
#pragma mark -changeBtn
- (void)p_ChangeBtnFrame {
    
    NSInteger arrCount = self.imageArray.count;
    
    if (arrCount >= 9) {
        self.addBtn.hidden = YES;
    }else {
        self.addBtn.hidden = NO;
    }
    NSInteger btnX = (KitemWidth+10)*(arrCount%3);
    NSInteger btnY = (KitemWidth+10)*(arrCount/3);
    [UIView animateWithDuration:0.3 animations:^{
        self.addBtn.frame = CGRectMake(btnX, btnY, KitemWidth, KitemWidth);
    }];
}

- (void)p_AddBtnClick {
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //启动图片选择器
        [[GCYPhotoManager sharedPhotoManager] openPhotoListWithController:self.superViewController MaxImageCount:9-self.imageArray.count];
        //设置代理
        [GCYPhotoManager sharedPhotoManager].delegate = self;
        
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [GCYPhotoAuthor checkCameraAuthorSuccess:^{
            UIImagePickerController *cameraCtrl = [[UIImagePickerController alloc] init];
            cameraCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
            cameraCtrl.allowsEditing = NO;
            cameraCtrl.delegate = self;
            [self.superViewController  presentViewController:cameraCtrl animated:YES completion:nil];
            
        } Failure:^(NSString *message) {
            NSLog(@"%@",message);
        }];
    }]];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.superViewController presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageArray addObject:image];
    [self.collectionView reloadData];
    [self p_ChangeBtnFrame];
}


// GCYPhotoManagerDelegate
- (void)imagePickerControllerDidCancel {
    
}

- (void)imagePickerControllerDidFinishPickingMediaWithThumbImages:(NSArray *)thumbImages originalImages:(NSArray *)originalImages {
    [self.imageArray addObjectsFromArray:originalImages];
    [self.collectionView reloadData];
    [self p_ChangeBtnFrame];
}


#pragma mark -- CollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    if (cell.subviews.count) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    UIImage *image = (UIImage *)self.imageArray[indexPath.item];
    imageView.image = image;
    [cell.contentView addSubview:imageView];
    
    UIButton *closeImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageView.frame) - 20, 0, 20, 20)];
    [closeImageBtn setBackgroundImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    [closeImageBtn addTarget:self action:@selector(p_CloseImage:) forControlEvents:UIControlEventTouchUpInside];
    closeImageBtn.tag = indexPath.item;
    
    imageView.userInteractionEnabled = YES;
    [imageView addSubview:closeImageBtn];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *image = (UIImage *)self.imageArray[indexPath.item];
    [GCYShowBigImageView showBigImageWithImage:image];
}


- (NSMutableArray<UIImage *> *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}


@end
