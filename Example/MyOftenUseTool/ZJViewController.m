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

#define keyPath(objc,keyPath) @(((void)objc.keyPath, #keyPath))


@interface ZJViewController ()
@property (weak, nonatomic) IBOutlet UITextField *testTextField;

@end

@implementation ZJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [WaveAnimation startAnimationToView:self.view];
    
    
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
