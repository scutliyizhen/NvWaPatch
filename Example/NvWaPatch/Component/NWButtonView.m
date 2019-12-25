//
//  NWButtonView.m
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/8.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import "NWButtonView.h"

@interface NWButtonView()
@property (nonatomic ,strong)UIButton *runtimeBtn;
@property (nonatomic ,strong)UIButton *demoBtn;
@property (nonatomic ,strong)UIButton *testBtn;
@end


@implementation NWButtonView
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat gapW = 16.0;
    CGFloat gapH = 16.0;
    self.runtimeBtn.frame = CGRectMake(gapW, gapH, CGRectGetWidth(self.bounds) - 2* gapW, (CGRectGetHeight(self.bounds) - 4*gapH)/3);
    self.demoBtn.frame = CGRectMake(CGRectGetMinX(self.runtimeBtn.frame),CGRectGetMaxY(self.runtimeBtn.frame) + gapH, CGRectGetWidth(self.runtimeBtn.bounds), CGRectGetHeight(self.runtimeBtn.bounds));
    self.testBtn.frame = CGRectMake(CGRectGetMinX(self.demoBtn.frame),CGRectGetMaxY(self.demoBtn.frame) + gapH, CGRectGetWidth(self.demoBtn.bounds), CGRectGetHeight(self.demoBtn.bounds));
}

- (UIButton*)testBtn {
    if (_testBtn == nil) {
        _testBtn = [[UIButton alloc] init];
        [_testBtn setTitle:@"测试" forState:UIControlStateNormal];
        [_testBtn setBackgroundColor:UIColor.purpleColor];
        [_testBtn addTarget:self action:@selector(_testBtnClik:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_testBtn];
    }
    return _testBtn;
}

- (UIButton*)runtimeBtn {
    if (_runtimeBtn == nil) {
        _runtimeBtn = [[UIButton alloc] init];
        [_runtimeBtn setTitle:@"Runtime脚本刷新" forState:UIControlStateNormal];
        [_runtimeBtn setBackgroundColor:UIColor.blueColor];
        [_runtimeBtn addTarget:self action:@selector(_runtimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_runtimeBtn];
    }
    return _runtimeBtn;
}

- (UIButton*)demoBtn {
    if (_demoBtn == nil) {
        _demoBtn = [[UIButton alloc] init];
        [_demoBtn setTitle:@"demo脚本刷新" forState:UIControlStateNormal];
        [_demoBtn setBackgroundColor:UIColor.grayColor];
        [_demoBtn addTarget:self action:@selector(_demoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_demoBtn];
    }
    return _demoBtn;
}

- (void)_runtimeBtnClick:(UIButton*)btn {
    if (self.runtimeBtnClick) {
        self.runtimeBtnClick(btn);
    }
}

- (void)_demoBtnClick:(UIButton*)btn {
    if (self.demoBtnClick) {
        self.demoBtnClick(btn);
    }
}

- (void)_testBtnClik:(UIButton*)btn {
    if (self.testBtnClick) {
        self.testBtnClick(btn);
    }
}
@end
