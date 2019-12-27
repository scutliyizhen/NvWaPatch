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
@property (nonatomic ,strong)UIButton *demoBtn1;
@property (nonatomic ,strong)UIButton *demoBtn2;
@property (nonatomic ,strong)UIButton *testBtn;
@end


@implementation NWButtonView
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat gapW = 16.0;
    CGFloat gapH = 16.0;
    self.runtimeBtn.frame = CGRectMake(gapW, gapH, CGRectGetWidth(self.bounds) - 2* gapW, (CGRectGetHeight(self.bounds) - 4*gapH)/3);
    self.demoBtn1.frame = CGRectMake(CGRectGetMinX(self.runtimeBtn.frame),CGRectGetMaxY(self.runtimeBtn.frame) + gapH, CGRectGetWidth(self.runtimeBtn.bounds)/2.0, CGRectGetHeight(self.runtimeBtn.bounds));
    self.demoBtn2.frame = CGRectMake(CGRectGetMaxX(self.demoBtn1.frame),CGRectGetMaxY(self.runtimeBtn.frame) + gapH, CGRectGetWidth(self.runtimeBtn.bounds)/2.0, CGRectGetHeight(self.runtimeBtn.bounds));
    self.testBtn.frame = CGRectMake(CGRectGetMinX(self.demoBtn1.frame),CGRectGetMaxY(self.demoBtn1.frame) + gapH, CGRectGetWidth(self.runtimeBtn.bounds), CGRectGetHeight(self.runtimeBtn.bounds));
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

- (UIButton*)demoBtn1 {
    if (_demoBtn1 == nil) {
        _demoBtn1 = [[UIButton alloc] init];
        [_demoBtn1 setTitle:@"demo脚本刷新1" forState:UIControlStateNormal];
        [_demoBtn1 setBackgroundColor:UIColor.grayColor];
        [_demoBtn1 addTarget:self action:@selector(_demoBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_demoBtn1];
    }
    return _demoBtn1;
}

- (UIButton*)demoBtn2 {
    if (_demoBtn2 == nil) {
        _demoBtn2 = [[UIButton alloc] init];
        [_demoBtn2 setTitle:@"demo脚本刷新2" forState:UIControlStateNormal];
        [_demoBtn2 setBackgroundColor:UIColor.systemPinkColor];
        [_demoBtn2 addTarget:self action:@selector(_demoBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_demoBtn2];
    }
    return _demoBtn2;
}

- (void)_runtimeBtnClick:(UIButton*)btn {
    if (self.runtimeBtnClick) {
        self.runtimeBtnClick(btn);
    }
}

- (void)_demoBtnClick1:(UIButton*)btn {
    if (self.demoBtnClick1) {
        self.demoBtnClick1(btn);
    }
}

- (void)_demoBtnClick2:(UIButton*)btn {
    if (self.demoBtnClick2) {
        self.demoBtnClick2(btn);
    }
}

- (void)_testBtnClik:(UIButton*)btn {
    if (self.testBtnClick) {
        self.testBtnClick(btn);
    }
}
@end
