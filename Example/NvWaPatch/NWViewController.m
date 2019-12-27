//
//  NWViewController.m
//  NvWaPatch
//
//  Created by 李义真 on 12/26/2019.
//  Copyright (c) 2019 李义真. All rights reserved.
//

#import <NvWaPatchLib/NvWaPatchLib-Swift.h>
#import "NWStateView.h"
#import "NWButtonView.h"
#import "NWViewController.h"

@interface NWViewController ()
@property (nonatomic ,strong)UIView *testArea;
@property (nonatomic ,strong)NWStateView *stateView;
@property (nonatomic ,strong)NWButtonView *btnView;
@end

@implementation NWViewController
#pragma mark--生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    //启动js engine
    [[NWJSEngine shared] startEngine];
    __weak typeof(self) weakSelf = self;
    [[NWJSEngine shared] refreshRuntimeLoadJavascriptWithJsURL:@"http://127.0.0.1:8080/nuwa-runtime.js" callBack:^(BOOL success, NSString * _Nonnull msg) {
        if(success == true) {
            [weakSelf.stateView changeRuntimeState:@"Runtime更新成功"];
        } else {
           [weakSelf.stateView changeRuntimeState:@"Runtime更新失败"];
        }
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.testArea.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)/2.0);
    self.stateView.frame = CGRectMake(0, CGRectGetMaxY(self.testArea.frame), CGRectGetWidth(self.view.bounds), 100);
    self.btnView.frame = CGRectMake(0, CGRectGetMaxY(self.stateView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)/2.0 - 100);
}

#pragma mark--属性懒加载
- (UIView*)testArea {
    if (_testArea == nil) {
        _testArea = [[UIView alloc] init];
        _testArea.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:_testArea];
    }
    return _testArea;
}

- (NWButtonView*)btnView {
    if (_btnView == nil) {
        _btnView = [[NWButtonView alloc] init];
         __weak typeof(self) weakSelf = self;
        _btnView.runtimeBtnClick = ^(UIButton * _Nullable btn) {
            [weakSelf _runtimeRefresh];
        };
        _btnView.demoBtnClick1 = ^(UIButton * _Nullable btn) {
            [weakSelf _demoRefresh:@"http://127.0.0.1:8080/testDemo1.js"];
        };
        
        _btnView.demoBtnClick2 = ^(UIButton * _Nullable btn) {
            [weakSelf _demoRefresh:@"http://127.0.0.1:8080/testDemo2.js"];
        };
        _btnView.testBtnClick = ^(UIButton * _Nullable btn) {
            [weakSelf _demoTest];
        };
        [self.view addSubview:_btnView];
    }
    return _btnView;
}

- (NWStateView*)stateView {
    if (_stateView == nil) {
        _stateView = [[NWStateView alloc] init];
        _stateView.backgroundColor = UIColor.grayColor;
        [self.view addSubview:_stateView];
    }
    return _stateView;
}
#pragma mark--私有方法
- (void)_runtimeRefresh {
    __weak typeof(self) weakSelf = self;
    [[NWJSEngine shared] refreshRuntimeLoadJavascriptWithJsURL:@"http://127.0.0.1:8080/nuwa-runtime-backup.js" callBack:^(BOOL success, NSString * _Nonnull msg) {
        if(success == true) {
            [weakSelf.stateView changeRuntimeState:@"Runtime更新成功"];
        } else {
           [weakSelf.stateView changeRuntimeState:@"Runtime更新失败"];
        }
    }];
}

- (void)_demoRefresh:(NSString*)demoURL {
    __weak typeof(self) weakSelf = self;
    [[NWJSEngine shared] refreshNuWaPatchTestDemoLoadJavascriptWithJsURL:demoURL callBack:^(BOOL success, NSString * _Nonnull msg) {
        if(success == true) {
            [weakSelf.stateView changeDemoState:@"demoJS更新成功"];
        } else {
            [weakSelf.stateView changeDemoState:@"demoJS更新失败"];
        }
    }];
}

- (void)_demoTest {
    self.testArea.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 60)];
    label.backgroundColor = UIColor.greenColor;
    [label setTag:10000];
    label.text = @"未被修改测试";
    [self.testArea addSubview:label];
}
@end
