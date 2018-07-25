//
//  GCYPhotoGroupListController.m
//  PhotoBrowse
//
//  Created by TonyYang on 2018/7/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "GCYPhotoGroupListController.h"
#import "GCYPhotoGroupCell.h"
#import "GCYPhotoListController.h"
#import "GCYPhotoKitManager.h"
#import "GCYPhotoGroupModel.h"
#import "GCYPhotoManager.h"


@interface GCYPhotoGroupListController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSMutableArray *groupDataArray;
@property(nonatomic, strong) UITableView *groupTableView;

@end

@implementation GCYPhotoGroupListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片";
    
    [self.view addSubview:self.groupTableView];

    [self setNavigationRightButton];
    
    [self setPushNavigation];
}

- (void)setPushNavigation {
    //获取相册列表
    NSArray *groupArray = [[GCYPhotoKitManager sharedPhotoKitManager] getPhotoGroupArray];
    [self.groupDataArray addObjectsFromArray:groupArray];
    [self.groupTableView reloadData];
    
    // 遍历找出相机胶卷组 直接打开
    for (GCYPhotoGroupModel *model in self.groupDataArray) {
        if ([model.groupName isEqualToString:@"相机胶卷"] || [model.groupName isEqualToString:@"Camera Roll"]) {
            [self showPhotoListViewControllerWithModel:model];
        }
    }
}

- (void)showPhotoListViewControllerWithModel:(GCYPhotoGroupModel *)model {
    GCYPhotoListController *listVC = [[GCYPhotoListController alloc] init];
    listVC.title = model.groupName;
    listVC.groupModel = model;
    listVC.maxImageCount = self.maxImageCount;
    [self.navigationController pushViewController:listVC animated:NO];
}

- (void)setNavigationRightButton {
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark -- Action
- (void)clickCancleBtn {
    [[GCYPhotoManager sharedPhotoManager] cancelChoosePhoto];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *groupCellID = @"groupCellID";
    GCYPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:groupCellID];
    if (cell == nil) {
        cell = [[GCYPhotoGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.groupModel = [self.groupDataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GCYPhotoGroupModel *groupModel = [self.groupDataArray objectAtIndex:indexPath.row];
    [self showPhotoListViewControllerWithModel:groupModel];
}

#pragma mark -- lazy
- (UITableView *)groupTableView {
    if (!_groupTableView) {
        _groupTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _groupTableView.delegate = self;
        _groupTableView.dataSource = self;
        _groupTableView.rowHeight = 80;
    }
    return _groupTableView;
}

- (NSMutableArray *)groupDataArray {
    if (!_groupDataArray) {
        _groupDataArray = [NSMutableArray array];
    }
    return _groupDataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
