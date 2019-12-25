//
//  NWStateView.h
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/8.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NWStateView : UIView
- (void)changeDemoState:(NSString*)msg;
- (void)changeRuntimeState:(NSString*)msg;
@end

NS_ASSUME_NONNULL_END
