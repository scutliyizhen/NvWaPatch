//
//  NWUtils.m
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/5.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import "NWUtils.h"

@implementation NWUtils
/*Objective-C type  |   JavaScript type
 --------------------+---------------------
 nil         |     undefined
 NSNull       |        null
 NSString      |       string
 NSNumber      |   number, boolean
 NSDictionary    |   Object object
 NSArray       |    Array object
 NSDate       |     Date object
 NSBlock (1)   |   Function object (1)
 id (2)     |   Wrapper object (2)
 Class (3)    | Constructor object (3)
 */
+ (id)formatNativeObjToJSObj:(id)obj {
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    if (obj) {
        mutableDic[@"__obj"] = obj;
        mutableDic[@"__clsName"] = NSStringFromClass([obj class]);
    } else {
        mutableDic[@"__isNil"] = @(YES);
    }
    return [mutableDic copy];
}

+ (id)formatJSObjToNativeObj:(JSValue*)jsVal {
    id obj = [jsVal toObject];
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *array = obj;
        NSMutableArray *newAttr = [[NSMutableArray alloc] init];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [newAttr addObject:[NWUtils formatJSObjToNativeObj:jsVal[idx]]];
        }];
        return [newAttr copy];
    }
    
    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = obj;
        if(dic[@"__obj"]) {
            return dic[@"__obj"];
        }
        
        Class cls = NSClassFromString(dic[@"__clsName"]);
        if(cls) {
            return cls;
        }
        
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            newDic[key] = [NWUtils formatJSObjToNativeObj:jsVal[key]];
        }];
        return [newDic copy];
    }
    
    return obj;
}

+ (void)synchronizedThreadSafeBlock:(id)obj block:(dispatch_block_t)block {
    if (obj == nil || block == nil) return;
    @synchronized (obj) {
        block();
    }
}

+ (const void * _Nonnull)getAssociatedObjKeyWith:(SEL)sel {
    return sel;
}
@end
