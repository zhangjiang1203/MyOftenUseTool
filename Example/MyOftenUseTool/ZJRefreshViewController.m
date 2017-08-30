//
//  ZJRefreshViewController.m
//  MyOftenUseTool
//
//  Created by DFHZ on 2017/8/15.
//  Copyright © 2017年 zhangjiang. All rights reserved.
//

#import "ZJRefreshViewController.h"
#import "ZJCustomRefreshView.h"
@interface ZJRefreshViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong,nonatomic) ZJCustomRefreshView *refreshControl;

@end

@implementation ZJRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.refreshControl = [[ZJCustomRefreshView alloc]initWithRefreshBlock:^{
        NSLog(@"开始刷新");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_refreshControl endRefreshing];
        });
    }];
    self.myTableView.refreshControl = self.refreshControl;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"当前显示===%zd",indexPath.row];
    return cell;
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.contentOffset.y);
//}

@end
