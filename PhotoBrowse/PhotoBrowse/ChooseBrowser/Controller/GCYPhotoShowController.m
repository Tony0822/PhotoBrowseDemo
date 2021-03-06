//
//  GCYPhotoShowController.m
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "GCYPhotoShowController.h"
#import "GCYPhotoModel.h"

@interface GCYPhotoShowController () <UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation GCYPhotoShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithImageModel:(GCYPhotoModel *)model SelectedIndex:(NSInteger)index{
    
    self = [super init];
    if (self) {
        
        _selectIndex = index;
        
        [self p_SetupUIWithImageModel:model];
        
    }
    return self;
}

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UIImageView *)imageV{
    
    if (!_imageV) {
        
        _imageV = [[UIImageView alloc] init];;
    }
    return _imageV;
}

/** 设置图片显示 */
- (void)p_SetupUIWithImageModel:(GCYPhotoModel *)model {
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
    
    _scrollView.frame = self.view.bounds;
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 2;
    
    [_scrollView addSubview:self.imageV];
    
    __weak typeof(self) weakSelf = self;
    [model fullScreenImageWithBlock:^(UIImage *fullScreenImage,BOOL isFull) {
        weakSelf.imageV.image = fullScreenImage;
        [weakSelf p_SetImageSizeWithImage:fullScreenImage scale:1];
    }];
    
    _imageV.userInteractionEnabled = YES;
    
    //添加单击 双击 手势
    UITapGestureRecognizer *oneTapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_OneTapImage)];
    oneTapImage.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *doubleTapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_DoubleTapImage)];
    doubleTapImage.numberOfTapsRequired = 2;
    
    [oneTapImage requireGestureRecognizerToFail:doubleTapImage];
    
    [_imageV addGestureRecognizer:oneTapImage];
    [_imageV addGestureRecognizer:doubleTapImage];
}

/** 设置图片大小 */
- (void)p_SetImageSizeWithImage:(UIImage *)image scale:(CGFloat)scale {
    
    //屏幕尺寸
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //原图尺寸
    CGSize imageSize = image ? image.size : screenSize;
    //需要设置的尺寸
    CGSize size = CGSizeZero;
    size.width = screenSize.width*scale;
    size.height = size.width *imageSize.height / imageSize.width;
    //设置图片位置
    _imageV.frame = CGRectMake(0, 0, size.width, size.height);
    _scrollView.contentSize = size;
    //短图居中
    if (size.height < _scrollView.height*scale) {
        _imageV.top = (_scrollView.height - size.height)*0.5;
        if (_imageV.top < 0) {
            _imageV.top = 0;
        }
    }
}

/** 单击图片 */
- (void)p_OneTapImage {
    
    if ([self.delegate respondsToSelector:@selector(tapImage)]) {
        [self.delegate tapImage];
    }
}

/** 双击 */
- (void)p_DoubleTapImage {
    
    CGFloat scale = self.scrollView.zoomScale < 2 ? 2 : 1;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.zoomScale = scale;
        
    }];
}

//UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    [self p_SetImageSizeWithImage:self.imageV.image scale:scrollView.zoomScale];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageV;
}

//保证翻页时当前图片 恢复原大小
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    self.scrollView.zoomScale = 1;
}


@end
