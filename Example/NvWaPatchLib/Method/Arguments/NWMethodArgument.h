//
//  NWMethodArgument.h
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/10.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JSValue.h>

NS_ASSUME_NONNULL_BEGIN

@interface NWMethodArgument : NSObject
@property (nonatomic ,strong ,readonly)JSValue* arg;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithJSArg:(JSValue*)arg argumentType:(const char *)argumentType;
- (void)setArgumentValueInvocation:(NSInvocation*)invocation index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
