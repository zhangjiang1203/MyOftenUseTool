//
//  ZJUpdateAppManager.m
//  MyOftenUseTool
//
//  Created by DFHZ on 2017/4/18.
//  Copyright © 2017年 zhangjiang. All rights reserved.
//

#import "ZJUpdateAppManager.h"

@interface ZJUpdateAppManager ()

@property (strong,nonatomic) NSDictionary *infoDict;

@end

@implementation ZJUpdateAppManager

//因为在model中，没有对应的对应的属性，所以导致了程序崩溃。
//解决方式就是实现一个方法setValue:forUndefinedKey: 这个方法能过滤掉不存在的键值
#pragma mark -防止程序奔溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


-(NSDictionary *)infoDict{
    if (_infoDict== nil) {
        _infoDict = [NSBundle mainBundle].infoDictionary;
    }
    return _infoDict;
}

#pragma mark -单例
+(instancetype)shareMyVersion{
    static ZJUpdateAppManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}


+(void)checkNewVersionWithAppID:(NSString *)appID control:(UIViewController *)ctrl{
    
    [[ZJUpdateAppManager shareMyVersion]getAppInfoWithAppID:appID success:^(ZJUpdateAppManager *model) {
        
        //弹出提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"有新的版本%@",model.version] message:model.releaseNotes preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[ZJUpdateAppManager shareMyVersion]updateRightNow:model];
        }];
        
        UIAlertAction *delayAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleDefault handler:nil];
        
        UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[ZJUpdateAppManager shareMyVersion]ignoreNewVersion:model.version];
        }];
        [alert addAction:updateAction];
        [alert addAction:delayAction];
        [alert addAction:ignoreAction];
        [ctrl presentViewController:alert animated:YES completion:nil];
    }];
    
}

#pragma mark - 立即升级
- (void)updateRightNow:(ZJUpdateAppManager *)model {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.trackViewUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.trackViewUrl] options:@{} completionHandler:nil];
    }
}

#pragma mark - 忽略新版本
- (void)ignoreNewVersion:(NSString *)version {
    //保存忽略的版本号
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"ingoreVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)getAppInfoWithAppID:(NSString*)appId success:(void(^)(ZJUpdateAppManager *))success{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/CN/lookup?id=%@",appId]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求返回的信息
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil && data != nil && data.length > 0) {
                NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSInteger resultCount = [respDict[@"resultCount"] integerValue];
                if (resultCount == 1) {
                    NSArray *results = respDict[@"results"];
                    NSDictionary *appStoreInfo = [results firstObject];
                    
                    //字典转模型
                    ZJUpdateAppManager *model = [[ZJUpdateAppManager alloc] init];
                    [model setValuesForKeysWithDictionary:appStoreInfo];
                    //是否提示更新
                    BOOL result = [self isEqualEdition:model.version];
                    if (result) {
                        if(success)success(model);
                    }
                }else{
#ifdef DEBUG
                    NSLog(@"AppStore上面没有找到对应id的App");
#endif
                }
            }
        });
    }] resume];
}

#pragma mark -比较版本号
-(BOOL)isEqualEdition:(NSString*)newVersion{
    NSString *ignoreVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"ingoreVersion"];
    if([self.infoDict[@"CFBundleShortVersionString"] compare:newVersion] == NSOrderedDescending || [self.infoDict[@"CFBundleShortVersionString"] compare:newVersion] == NSOrderedSame ||
       [ignoreVersion isEqualToString:newVersion]) {
        return NO;
    } else {
        return YES;
    }
}

@end
