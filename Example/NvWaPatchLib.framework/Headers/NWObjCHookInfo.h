//
//  NWObjCHookInfo.h
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/1.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import "NWHookInfo.h"

@class NWJSMethod;

typedef void* NuwWaPatchIMP;

NS_ASSUME_NONNULL_BEGIN

@interface NWObjCHookInfo : NWHookInfo
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithJSMethod:(NWJSMethod*)jsMethod;
- (const char *)typeEncoding;
- (BOOL)isCanHook;
- (void)setupHook;
@end

NS_ASSUME_NONNULL_END
