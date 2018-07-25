//
//  GCYPhotoListController.m
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "GCYPhotoListController.h"
#import "GCYPhotoGroupModel.h"
#import "GCYPhotoCollectionViewCell.h"
#import "GCYPhotoModel.h"
#import "GCYPhotoKitManager.h"
#import "GCYPhotoManager.h"
#import "GCYScreenPhotoController.h"

#define ROW_COUNT 4
#define PHOTOCELL_ID @"GCYPhotoCollectionViewCell"

@interface GCYPhotoListController ()<UICollectionViewDelegate, UICollectionViewDataSource, GCYPhotoCollectionViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *photoDataArray;
@property (nonatomic, strong) NSMutableArray *seletedPhotoArray;
@property (nonatomic, strong) NSMutableArray *seletedPhotoIndexPathArray;
@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) UIButton *preViewBtn;
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation GCYPhotoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.photoCollectionView];
    
    [self setNavigationRightButton];
    [self setBottomView];
    [self setListData];
}

- (void)setListData {
    NSArray *photoList = [[GCYPhotoKitManager sharedPhotoKitManager] getPhotoListWithModel:self.groupModel];
    [self.photoDataArray addObjectsFromArray:photoList];
    [self.photoCollectionView reloadData];
}

- (void)setNavigationRightButton {
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setBottomView {
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-TAB_BAR_HEIGHT, SCREENWIDTH, TAB_BAR_HEIGHT)];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    
    self.preViewBtn.left = 10;
    [bottomView addSubview:self.preViewBtn];
    self.sendBtn.right = SCREENWIDTH - 10;
    [bottomView addSubview:self.sendBtn];
}

#pragma mark -- Action
- (void)clickCancleBtn {
    [[GCYPhotoManager sharedPhotoManager] cancelChoosePhoto];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendPhoto {
    if (!self.seletedPhotoArray.count) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"请最少选择一张照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
        return;
    }
    
    [[GCYPhotoManager sharedPhotoManager] sendSeletedPhotosWithArray:[self.seletedPhotoArray copy] success:^(BOOL isSuccess) {
        if (isSuccess) {
            // 发送成功
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)preViewBtnClick {
    if (!self.seletedPhotoArray.count) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"请最少选择一张照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
        return;
    }
    GCYScreenPhotoController *screenPhotoCtrl = [[GCYScreenPhotoController alloc]init];
    screenPhotoCtrl.seletedPhotoArray = self.seletedPhotoArray;
    screenPhotoCtrl.seletedPhotoIndexPathArray = self.seletedPhotoIndexPathArray;
    screenPhotoCtrl.photoDataArray = self.photoDataArray;
    screenPhotoCtrl.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    screenPhotoCtrl.maxImageCount = self.maxImageCount;
    screenPhotoCtrl.isPre = YES;
    __weak typeof(self) bself = self;
    [screenPhotoCtrl setSelectedChooseBtn:^(NSArray *indexPaths) {
        [bself.photoCollectionView reloadItemsAtIndexPaths:indexPaths];
    }];
    [self.navigationController pushViewController:screenPhotoCtrl animated:YES];

}



#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GCYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PHOTOCELL_ID forIndexPath:indexPath];
    cell.photoModel = [self.photoDataArray objectAtIndex:indexPath.item];
    
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GCYScreenPhotoController *screenPhotoCtrl = [[GCYScreenPhotoController alloc]init];
    screenPhotoCtrl.seletedPhotoArray = self.seletedPhotoArray;
    screenPhotoCtrl.seletedPhotoIndexPathArray = self.seletedPhotoIndexPathArray;
    screenPhotoCtrl.photoDataArray = self.photoDataArray;
    screenPhotoCtrl.currentIndexPath = indexPath;
    screenPhotoCtrl.maxImageCount = self.maxImageCount;
    screenPhotoCtrl.isPre = NO;
    __weak typeof(self) bself = self;
    [screenPhotoCtrl setSelectedChooseBtn:^(NSArray *indexPaths) {
        [bself.photoCollectionView reloadItemsAtIndexPaths:indexPaths];
    }];
    [self.navigationController pushViewController:screenPhotoCtrl animated:YES];
}

- (void)thumbImageSeletedChooseIndexPath:(NSIndexPath *)indexPath selectedBtn:(UIButton *)selectedBtn {
      GCYPhotoModel *photoModel = [self.photoDataArray objectAtIndex:indexPath.item];
    if (self.seletedPhotoIndexPathArray.count == self.maxImageCount && !photoModel.isSelect) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最多选择%zd张图片",self.maxImageCount] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    } else {
        photoModel.isSelect = !photoModel.isSelect;
        if (photoModel.isSelect) {
            photoModel.chooseIndex = self.seletedPhotoIndexPathArray.count+1;
            [self.seletedPhotoIndexPathArray addObject:indexPath];
            [self.seletedPhotoArray addObject:photoModel];
            [self.photoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        } else {
            for (NSInteger i = 0; i < self.seletedPhotoIndexPathArray.count ;i++) {
                GCYPhotoModel *model = [self.seletedPhotoArray objectAtIndex:i];
                if (model.chooseIndex > photoModel.chooseIndex) {
                    model.chooseIndex -= 1;
                }
            }
            [self.photoCollectionView reloadItemsAtIndexPaths:self.seletedPhotoIndexPathArray];
            [self.seletedPhotoIndexPathArray removeObject:indexPath];
            [self.seletedPhotoArray removeObject:photoModel];
        }
        CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulse.duration = 0.08;
        pulse.repeatCount= 1;
        pulse.autoreverses= YES;
        pulse.fromValue= [NSNumber numberWithFloat:0.7];
        pulse.toValue= [NSNumber numberWithFloat:1.3];
        [[selectedBtn layer] addAnimation:pulse forKey:nil];
    }
}

#pragma mark -- lazy
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionView *)photoCollectionView {
    if (!_photoCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        CGFloat itemWH = (SCREENWIDTH - (ROW_COUNT+1)*10/2)/ROW_COUNT;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10/2, 10/2, SCREENWIDTH-10, SCREENHEIGHT-44-10-HOME_INDICATOR_HEIGHT) collectionViewLayout:layout];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.backgroundColor = [UIColor whiteColor];
        [_photoCollectionView registerClass:[GCYPhotoCollectionViewCell class] forCellWithReuseIdentifier:PHOTOCELL_ID];
        _photoCollectionView.showsVerticalScrollIndicator = NO;
    }
    return _photoCollectionView;
}

- (UIButton *)preViewBtn {
    if (!_preViewBtn) {
        _preViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
        [_preViewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_preViewBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_preViewBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_preViewBtn addTarget:self action:@selector(preViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preViewBtn;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:185/255.0 blue:34/255.0 alpha:1.000]];
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_sendBtn addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.layer.cornerRadius = 3;
        _sendBtn.layer.masksToBounds = YES;
    }
    return _sendBtn;
}
- (NSMutableArray *)photoDataArray{
    
    if (!_photoDataArray) {
        _photoDataArray = [NSMutableArray array];
    }
    return _photoDataArray;
}

- (NSMutableArray *)seletedPhotoArray{
    
    if (!_seletedPhotoArray) {
        
        _seletedPhotoArray = [NSMutableArray array];
    }
    return _seletedPhotoArray;
}

- (NSMutableArray *)seletedPhotoIndexPathArray{
    
    if (!_seletedPhotoIndexPathArray) {
        
        _seletedPhotoIndexPathArray = [NSMutableArray array];
    }
    return _seletedPhotoIndexPathArray;
}


@end
