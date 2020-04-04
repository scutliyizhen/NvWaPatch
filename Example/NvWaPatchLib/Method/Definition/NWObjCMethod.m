//
//  NWObjCMethod.m
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/3.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import <objc/runtime.h>
#import "ffi.h"
#import "NWUtils.h"
#import "NWObjCMethod.h"
#import "NWMethodArgument.h"
#import "NWMethodReturnValue.h"
#import "NWObjCMethodSignature.h"

@interface NWObjCMethod() {
    const char * _typeEncoding;
}
@property (nonatomic, strong, readwrite)NWObjCMethodSignature *signature;
@property (nonatomic, readwrite) SEL sel;
@property (nonatomic, readwrite) IMP imp;
@property (nonatomic, weak, readwrite)Class cls;
@property (nonatomic ,assign ,readwrite)BOOL isClsMethod;
@end

@implementation NWObjCMethod
- (instancetype)initWithHookCls:(Class)cls selector:(SEL)selector isClsMethod:(BOOL)isClsMethod {
    if (self = [super init]) {
        _cls = cls;
        _sel = selector;
        _isClsMethod = isClsMethod;
        
        Method m = nil;
        if (isClsMethod) {
            m = class_getClassMethod(self.cls, self.sel);
        } else {
            m = class_getInstanceMethod(self.cls, self.sel);
        }
        _typeEncoding = method_getTypeEncoding(m);
        _imp = method_getImplementation(m);
        _signature = [[NWObjCMethodSignature alloc] initWithObjCTypes:[NSString stringWithUTF8String:_typeEncoding]];
    }
    return self;
}

- (const char*)typeEncoding {
    return _typeEncoding;
}

- (id)invoke:(JSValue *)arguments target:(id)target {
    //方法签名
    NSMethodSignature *signature = nil;
    if (self.isClsMethod == YES) {
        signature = [target methodSignatureForSelector:self.sel];
    } else {
        signature = [self.cls instanceMethodSignatureForSelector:self.sel];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = self.sel;
    
    //方法入参
    for (NSUInteger i = 2; i < signature.numberOfArguments; i++) {
        const char *argumentType = [signature getArgumentTypeAtIndex:i];
        JSValue* argument = arguments[i-2];
        NWMethodArgument *arg = [[NWMethodArgument alloc] initWithJSArg:argument argumentType:argumentType];
        [arg setArgumentValueInvocation:invocation index:i];
    }
    
    //动态调用方法
    [invocation invoke];
    
    //方法返回值
    const char *returnType = [signature methodReturnType];
    NWMethodReturnValue *returnValueObj = [[NWMethodReturnValue alloc] initWith:invocation sel:self.sel returnType:returnType];
    id returnValue = [returnValueObj getReturnValue];
    return returnValue;
}
@end
