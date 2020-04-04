//
//  NWJSMethod.m
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/6.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import <objc/runtime.h>
#import "NWUtils.h"
#import "pthread.h"
#import "NWJSMethod.h"

@interface NWJSMethod()
{
    JSValue *_jsMethodArr;
    JSValue *_jsFunction;
    int _numberOfArg;
    
    //锁
    pthread_mutex_t _mutex;
    pthread_mutexattr_t _mutexAttr;
}
@property (nonatomic, readwrite)SEL origionSEL;
@property (nonatomic, strong, readwrite)NSString *jsMethodName;
@property (nonatomic, weak, readwrite)Class hoolCls;
@property (nonatomic, assign ,readwrite)BOOL isClsMethod;
@end

@implementation NWJSMethod
- (instancetype)initWithJSMethodName:(NSString*)jsMethodName
                        jsMethodArr:(JSValue*)jsMethodArr
                             hookCls:(Class)hookCls
                         isClsMethod:(BOOL)isClsMethod {
    if (self = [super init]) {
        pthread_mutexattr_init(&_mutexAttr);
        pthread_mutexattr_settype(&_mutexAttr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&_mutex, &_mutexAttr);
        
        _jsMethodName = jsMethodName;
        _jsMethodArr = jsMethodArr;
        _hoolCls = hookCls;
        _isClsMethod = isClsMethod;
        [self _setupJSMethodAttr:jsMethodArr jsMethodName:jsMethodName];
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_mutex);
    pthread_mutexattr_destroy(&_mutexAttr);
}

- (BOOL)canHook {
    if(class_respondsToSelector(self.hoolCls,self.origionSEL)) {
        return YES;
    } else {
        return NO;
    }
}

- (id)callJSFunctionWithArguments:(NSArray *)arguments {
    id __autoreleasing ret = nil;
    NSArray *params = [self _formatNativeObjToJSList:arguments];
    pthread_mutex_lock(&_mutex);
    JSValue *jsVal = [_jsFunction callWithArguments:params];
    ret = [NWUtils formatJSObjToNativeObj:jsVal];
    pthread_mutex_unlock(&_mutex);
    return ret;
}

- (NSArray*)_formatNativeObjToJSList:(NSArray*)list {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id obj in list) {
        [arr addObject:[NWUtils formatNativeObjToJSObj:obj]];
    }
    return [arr copy];
}

- (void)_setupJSMethodAttr:(JSValue*)jsMethodArr jsMethodName:(NSString*)jsMethodName {
    _numberOfArg = [jsMethodArr[0] toInt32];
    NSString *selectorName = [self _convertJPSelectorString:jsMethodName];
    if ([selectorName componentsSeparatedByString:@":"].count - 1 < _numberOfArg) {
        selectorName = [selectorName stringByAppendingString:@":"];
    }
    _origionSEL = NSSelectorFromString(selectorName);
    _jsFunction = jsMethodArr[1];
}

- (NSString*)_convertJPSelectorString:(NSString*)selectorString
{
    NSString *tmpJSMethodName = [selectorString stringByReplacingOccurrencesOfString:@"__" withString:@"-"];
    NSString *selectorName = [tmpJSMethodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
    return [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
}
@end
