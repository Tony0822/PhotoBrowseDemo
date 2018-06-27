//
//  ViewController.m
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "ViewController.h"
#import "AdImageButtonView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  AdImageButtonView *timerView = [[AdImageButtonView alloc] initWithFrame:CGRectMake(100, 100, 40, 40)];
    timerView.delayTime = 4;
    [self.view addSubview:timerView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
