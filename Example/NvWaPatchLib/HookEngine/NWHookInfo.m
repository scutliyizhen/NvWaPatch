//
//  NWHookInfo.m
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/1.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import "NWHookInfo.h"

@implementation NWHookInfo
+ (NSString*)getKeyWithSel:(SEL)sel hookCls:(Class)hookCls {
    return [NSString stringWithFormat:@"%@_%@",NSStringFromSelector(sel),NSStringFromClass(hookCls)];
}

- (NSString*)key {
    return [NSString stringWithFormat:@"%p",self];
}
@end
