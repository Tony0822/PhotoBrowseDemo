//
//  ViewController.m
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "ViewController.h"
#import "GCYChoosePictureView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GCYChoosePictureView *pView = [[GCYChoosePictureView alloc] initWithFrame:CGRectMake(10, 100, self.view.width - 20, self.view.width - 20)];
    
    pView.superViewController = self;
    [self.view addSubview:pView];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
