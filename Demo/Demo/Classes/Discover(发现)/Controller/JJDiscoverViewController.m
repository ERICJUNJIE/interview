//
//  JJDiscoverViewController.m
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "JJDiscoverViewController.h"
#import "JJMessageTools.h"
#import "JJDicoverTableViewCell.h"
#import "JJMessageModel.h"

@interface JJDiscoverViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation JJDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [[JJMessageTools shareMessageTools] loadMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJDicoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
    [cell setModel:self.dataSource[indexPath.row]];
    [cell layoutIfNeeded];
    [self.dataSource[indexPath.row] setCellHeight:[cell cellHeight]];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource[indexPath.row] cellHeight];
}

@end
