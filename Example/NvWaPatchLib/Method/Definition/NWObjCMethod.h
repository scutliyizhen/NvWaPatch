//
//  NWObjCMethod.h
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/3.
//  Copyright © 2019 liyizhen. All rights reserved.
//
#import <JavaScriptCore/JavaScriptCore.h>
#import "NWMethod.h"

@class NWObjCMethodSignature;

NS_ASSUME_NONNULL_BEGIN

@interface NWObjCMethod : NWMethod
@property (nonatomic, strong, readonly)NWObjCMethodSignature *signature;
@property (nonatomic, readonly) SEL sel;
@property (nonatomic, readonly) IMP imp;
@property (nonatomic, weak, readonly)Class cls;
@property (nonatomic ,assign ,readonly)BOOL isClsMethod;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHookCls:(Class)cls selector:(SEL)selector isClsMethod:(BOOL)isClsMethod;
- (id)invoke:(JSValue *)arguments target:(id)target;
- (const char*)typeEncoding;
@end

NS_ASSUME_NONNULL_END
