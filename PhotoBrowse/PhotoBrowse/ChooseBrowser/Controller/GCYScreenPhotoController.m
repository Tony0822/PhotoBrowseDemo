//
//  GCYScreenPhotoController.m
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "GCYScreenPhotoController.h"
#import "GCYPhotoShowController.h"
#import "GCYPhotoModel.h"
#import "GCYPhotoManager.h"

@interface GCYScreenPhotoController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, GCYPhotoShowControllerDelegate>
@property (nonatomic, strong) UIView     *topView;
@property (nonatomic, strong) UIView     *bottomView;
@property (nonatomic, strong) UIButton   *backBtn;
@property (nonatomic, strong) UIButton   *selectBtn;
@property (nonatomic, strong) UIButton   *sendBtn;
@property (nonatomic, assign) BOOL       isHiddenView;
@property (nonatomic, assign) NSInteger  currentCount;
@property (nonatomic, strong) GCYPhotoShowController    *currentPhotoShowController;
@property (nonatomic, assign) NSInteger  allCount;
@end

@implementation GCYScreenPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self p_SetupPageUI];
    [self.view addSubview:self.topView];
    
    [self.topView addSubview:self.backBtn];
    [self.topView addSubview:self.selectBtn];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.sendBtn];
    
    [self setConfigurationData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

/** 设置分页控制器 */
- (void)p_SetupPageUI {
    //UIPageViewControllerTransitionStyleScroll滑动换页  UIPageViewControllerNavigationOrientationHorizontal横向滚动  UIPageViewControllerOptionInterPageSpacingKey页间距
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{@"UIPageViewControllerOptionInterPageSpacingKey":@20}];
    
    GCYPhotoShowController *showController = [[GCYPhotoShowController alloc] initWithImageModel:self.isPre ? self.seletedPhotoArray[self.currentIndexPath.item] : self.photoDataArray[self.currentIndexPath.item] SelectedIndex:self.currentIndexPath.item];
    self.currentPhotoShowController = showController;
    showController.delegate = self;
    //设置show为page的子控制器
    [pageViewController setViewControllers:@[showController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //将分页控制器添加为当前的子控制器
    [self.view addSubview:pageViewController.view];
    [self addChildViewController:pageViewController];
    [pageViewController didMoveToParentViewController:self];
    
    //代理
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    
    //设置手势
    self.view.gestureRecognizers = pageViewController.gestureRecognizers;
}

- (void)setConfigurationData {
    // 初始化数据
    GCYPhotoModel *model = self.isPre ? self.seletedPhotoArray[self.currentIndexPath.item]:self.photoDataArray[self.currentIndexPath.item];
    self.selectBtn.selected = model.isSelect;
    [self.selectBtn setTitle:[NSString stringWithFormat:@"%zd",model.chooseIndex] forState:UIControlStateSelected];
    
    //判断是否已经滑动到最后面一页
    self.allCount = self.isPre ? self.seletedPhotoArray.count : self.photoDataArray.count;
    
    //当前所在图片的下标
    self.currentCount = self.currentIndexPath.item;
}

- (void)backToList {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)clickSelectBtn {
    GCYPhotoModel *photoModel = self.isPre ? self.seletedPhotoArray[self.currentCount] : self.photoDataArray[self.currentCount];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    for (GCYPhotoModel *model in self.photoDataArray) {
        if (model == photoModel) {
            indexPath = model.indexPath;
        }
    }
    if (self.seletedPhotoIndexPathArray.count == self.maxImageCount && !photoModel.isSelect) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最多选择%zd张图片",self.maxImageCount] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
        
    }else {
        //添加动画
        CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulse.duration = 0.08;
        pulse.repeatCount= 1;
        pulse.autoreverses= YES;
        pulse.fromValue= [NSNumber numberWithFloat:0.7];
        pulse.toValue= [NSNumber numberWithFloat:1.3];
        [[self.selectBtn layer] addAnimation:pulse forKey:nil];
        
        photoModel.isSelect = !photoModel.isSelect;
        if (photoModel.isSelect) {
            photoModel.chooseIndex = self.seletedPhotoIndexPathArray.count+1;
            [self.seletedPhotoIndexPathArray addObject:indexPath];
            [self.seletedPhotoArray addObject:photoModel];
            self.selectBtn.selected = YES;
            [self.selectBtn setTitle:[NSString stringWithFormat:@"%zd",photoModel.chooseIndex] forState:UIControlStateSelected];
            if (self.selectedChooseBtn) {
                self.selectedChooseBtn(@[indexPath]);
            }
        }else {
            for (NSInteger i = 0; i < self.seletedPhotoArray.count ;i++) {
                GCYPhotoModel *model = [self.seletedPhotoArray objectAtIndex:i];
                if (model.chooseIndex > photoModel.chooseIndex) {
                    model.chooseIndex -= 1;
                }
            }
            if (self.selectedChooseBtn) {
                self.selectedChooseBtn([self.seletedPhotoIndexPathArray copy]);
            }
            if (!self.isPre) {
                
                [self.seletedPhotoArray removeObject:photoModel];
            }
            [self.seletedPhotoIndexPathArray removeObject:indexPath];
            self.selectBtn.selected = NO;
        }
        
    }
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
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}
#pragma mark -- delegate
- (void)tapImage {
    self.isHiddenView = !self.isHiddenView;
    if (self.isHiddenView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.top = -self.topView.height;
            self.bottomView.top = SCREENHEIGHT;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.top = 0;
            self.bottomView.top = SCREENHEIGHT - self.bottomView.height;
        }];
        
    }
}

/**
 返回前一页控制器
 
 @param pageViewController pageViewController description
 @param viewController 当前显示的控制器
 @return 返回前一页控制器 返回Nil 就是到头了
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    //取出当前控制器的序号
    GCYPhotoShowController *currentCtrl = (GCYPhotoShowController *)viewController;
    NSInteger index = currentCtrl.selectIndex;
    //判断是否已经滑动到最前面一页
    if (index <= 0) {
        return nil;
    }
    index --;
    GCYPhotoShowController *beforeCtrl = [[GCYPhotoShowController alloc] initWithImageModel:self.isPre ? self.seletedPhotoArray[index] : self.photoDataArray[index] SelectedIndex:index];
    beforeCtrl.delegate = self;
    return beforeCtrl;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    //取出当前控制器的序号
    GCYPhotoShowController *currentCtrl = (GCYPhotoShowController *)viewController;
    NSInteger index = currentCtrl.selectIndex;
    //判断是否已经滑动到最后面一页
    if (index >= self.allCount-1) {
        return nil;
    }
    index ++;
    GCYPhotoShowController *afterCtrl = [[GCYPhotoShowController alloc] initWithImageModel:self.isPre ? self.seletedPhotoArray[index] : self.photoDataArray[index] SelectedIndex:index];
    afterCtrl.delegate = self;
    return afterCtrl;
    
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    // viewControllers[0] 是当前显示的控制器，随着分页控制器的滚动，调整数组的内容次序
    // 始终保证当前显示的控制器的下标是 0
    // 一定注意，不要使用 childViewControllers
    
    GCYPhotoShowController *showController = (GCYPhotoShowController *)pageViewController.viewControllers[0];
    self.currentPhotoShowController = showController;
    self.currentCount = self.currentPhotoShowController.selectIndex;
    
    GCYPhotoModel *photoModel = self.isPre ? self.seletedPhotoArray[self.currentCount] : self.photoDataArray[self.currentCount];
    self.selectBtn.selected = photoModel.isSelect;
    [self.selectBtn setTitle:[NSString stringWithFormat:@"%zd",photoModel.chooseIndex] forState:UIControlStateSelected];
}

#pragma mark -- lazy
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, KNAVHEIGHT)];
        _topView.backgroundColor = [UIColor blackColor];
        _topView.alpha = 0.9;
    }
    return _topView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 15, 30)];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"barbuttonicon_back_15x30_"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backToList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.topView.width - 42 - 10, 10, 42, 42)];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectBigNIcon_42x42_"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectBigNIcon_42x42_"] forState:UIControlStateHighlighted];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectBigYIcon_42x42_"] forState:UIControlStateSelected];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_selectBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_selectBtn addTarget:self action:@selector(clickSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - TAB_BAR_HEIGHT, SCREENWIDTH, TAB_BAR_HEIGHT)];
        _bottomView.backgroundColor = [UIColor blackColor];
    }
    return _bottomView;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bottomView.width-10-60, 10, 60, 30)];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:185/255.0 blue:34/255.0 alpha:1.000]];
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_sendBtn addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.layer.cornerRadius = 3;
        _sendBtn.layer.masksToBounds = YES;
    }
    return _sendBtn;
}



@end
