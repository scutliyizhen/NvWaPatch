//
//  NWButtonView.h
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/8.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NWButtonViewBtnClick)(UIButton* _Nullable btn);

NS_ASSUME_NONNULL_BEGIN

@interface NWButtonView : UIView
@property (nonatomic ,copy)NWButtonViewBtnClick runtimeBtnClick;
@property (nonatomic ,copy)NWButtonViewBtnClick demoBtnClick;
@property (nonatomic ,copy)NWButtonViewBtnClick testBtnClick;
@end

NS_ASSUME_NONNULL_END
