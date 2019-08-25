//
//  YouWenSortViewController.m
//  MoblieCQUPT_iOS
//
//  Created by xiaogou134 on 2018/2/24.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import "YouWenSortViewController.h"
#import "YouWenTableViewCell.h"
#import "YouWenDataModel.h"
#import "YouWenDetailViewController.h"
#import "YouWenAddViewController.h"
#import <MJRefresh.h>
#import "ReportViewController.h"
@interface YouWenSortViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tab;
@property (strong, nonatomic) NSMutableArray *cellArray;
@property (strong, nonatomic) YouWenDataModel *dataModel;
@property (nonatomic, assign) NSInteger YWpage;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation YouWenSortViewController
- (instancetype)initViewStyle:(NSString *)style{
    if (self = [super init]) {
        _dataModel = [[YouWenDataModel alloc] initWithStyle:style];
        [_tab registerClass:[YouWenTableViewCell class] forCellReuseIdentifier:@"YouWenTableViewCell"];
        _YWpage = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableData:) name:[NSString stringWithFormat:@"%@DataLoading", style]object:nil];
    }
    return self;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array].mutableCopy;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tab = [[UITableView alloc] init];
    _cellArray = [NSMutableArray array];
    _tab.delegate = self;
    _tab.dataSource = self;
    _tab.rowHeight = UITableViewAutomaticDimension;
    _tab.estimatedRowHeight = 200; // 设置估算高度
    
    
    _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tab.backgroundColor = RGBColor(246, 246, 246, 1.0);
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewData)];
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tab.mj_header = header;
    [self.view addSubview:_tab];
    [_tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    [_tab.mj_header beginRefreshing];
}

- (void)refreshTableData:(NSNotification *)notification{
    NSString *str = notification.userInfo[@"state"];
    if (_tab.mj_header.state == MJRefreshStateRefreshing) {
        if ([str isEqualToString:@"YES"]) {
            if (!_dataArray.count) {
                _dataArray = _dataModel.YWdataArray.mutableCopy;
            }else {
                [_dataModel.YWdataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj[@"created_at"] isEqualToString:
                         self.dataArray[idx][@"created_at"]]){
                        *stop = YES;
                    }
                    else {
                        [self.dataArray insertObject:obj atIndex:0];
                    }
                }];
            }
            [_tab reloadData];
            [_tab.mj_header endRefreshing];
        }
        else {
            [_tab.mj_header endRefreshing];
        }
    }
    else{
        if ([str isEqualToString:@"YES"]) {
            [_dataArray addObjectsFromArray:_dataModel.YWdataArray];
            [_tab reloadData];
            [_tab.mj_footer endRefreshing];
        }
        else {
            [_tab.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void)getNewData{
    [_dataModel newYWDate];
}

- (void)getNewPageData{
    _YWpage ++;
    [_dataModel newPage:[NSString stringWithFormat:@"%ld", (long)_YWpage]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *dic = _dataArray[indexPath.row];
    YouWenTableViewCell *cell = [self.tab dequeueReusableCellWithIdentifier:@"YouWenTableViewCell"];
    if (!cell) {
        cell = [[YouWenTableViewCell alloc] initWithDic:dic];
    }
    
    cell.dataDic = dic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YouWenDetailViewController *detailVC = [[YouWenDetailViewController alloc] init];
    YouWenTableViewCell *cell = (YouWenTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    detailVC.question_id = cell.qusId;
    detailVC.questionTitle = cell.title;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.superController.navigationController pushViewController:detailVC animated:YES];
}

@end
