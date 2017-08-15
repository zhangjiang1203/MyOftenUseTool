//
//  ZJViewController.m
//  MyOftenUseTool
//
//  Created by zhangjiang on 11/10/2016.
//  Copyright (c) 2016 zhangjiang. All rights reserved.
//

#import "ZJViewController.h"
#import "WaveAnimation.h"
#import "UI_Categories.h"
#import "ZJMethodHeader.h"
#import "ZJSegmentScrollView.h"
#import "ZJWaveView.h"

#import <MyOftenUseTool/ZJAFNRequestTool.h>

#define keyPath(objc,keyPath) @(((void)objc.keyPath, #keyPath))

@interface ZJViewController ()

@end

@implementation ZJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testMyCacheRequest];
}


-(void)testMyCacheRequest{
    [ZJAFNRequestTool postWithURL:@"http://api.budejie.com/api/api_open.php?a=list&c=data&type=10" param:nil hud:YES cache:^(id responseCache) {
        NSLog(@"当前缓存===%@",responseCache);
    } success:^(id responseObject) {
        NSLog(@"请求返回值===%@",responseObject);
    } fail:^(NSString *errorStr) {
        NSLog(@"请求失败===%@",errorStr);
    }];
}

-(void)segmentControl{
    ZJSegmentScrollView *segmentView = [[ZJSegmentScrollView alloc]initWithFrame:CGRectMake(0, 200, KScreenWidth, 40)];
    segmentView.lineWidth = 80;
    segmentView.segmentTitleArr = @[@"第一个",@"第二个",@"蒂萨跟",@"我们",@"测试数",@"我想说什么"];
    [self.view addSubview:segmentView];
    
    ZJWaveView *waveView = [[ZJWaveView alloc]initWithFrame:CGRectMake(0, 280, KScreenWidth, 200)];
    [self.view addSubview:waveView];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [WaveAnimation stopAnimation];
}

#pragma mark - 获取AppStore的info信息
- (void)getAppStoreInfo:(NSString *)appID success:(void(^)(NSDictionary *))success {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/CN/lookup?id=%@",appID]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil && data != nil && data.length > 0) {
                NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (success) {
                    success(respDict);
                }
            }
        });
    }] resume];
}

@end
