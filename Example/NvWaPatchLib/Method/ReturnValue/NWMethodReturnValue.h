//
//  NWMethodReturnValue.h
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/10.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NWMethodReturnValue : NSObject
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWith:(NSInvocation*)invocation sel:(SEL)sel returnType:(const char*)returnType;
- (id)getReturnValue;
@end

NS_ASSUME_NONNULL_END
