//
//  NWStateView.m
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/8.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import "NWStateView.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface NWStateView()
@property (nonatomic ,strong)UILabel *runtimeLabel;
@property (nonatomic ,strong)UILabel *demoLabel;
@end


@implementation NWStateView
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat gapW = 16.0;
    CGFloat GapH = 8.0;
    CGFloat labelWidth = (CGRectGetWidth(self.bounds) - 3 * gapW)/2;
    CGFloat labelHeight = (CGRectGetHeight(self.bounds) - 2 * GapH);
    self.runtimeLabel.frame = CGRectMake(gapW, GapH, labelWidth, labelHeight);
    self.demoLabel.frame = CGRectMake(CGRectGetMaxX(self.runtimeLabel.frame) + gapW, GapH, labelWidth, labelHeight);
}

- (UILabel*)runtimeLabel {
    if (_runtimeLabel == nil) {
        _runtimeLabel = [[UILabel alloc] init];
        _runtimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_runtimeLabel];
    }
    return _runtimeLabel;
}

- (UILabel*)demoLabel {
    if (_demoLabel == nil) {
        _demoLabel = [[UILabel alloc] init];
        _demoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_demoLabel];
    }
    return _demoLabel;
}

- (void)changeDemoState:(NSString*)msg {
    self.demoLabel.backgroundColor = randomColor;
    self.demoLabel.text = msg;
}

- (void)changeRuntimeState:(NSString*)msg {
    self.runtimeLabel.text = msg;
    self.runtimeLabel.backgroundColor = randomColor;
}
@end
