//
//  NWUtils.h
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/5.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN
static void (^_exceptionBlock)(NSString *log) = ^void(NSString *log) {
    NSCAssert(NO, log);
};
@interface NWUtils : NSObject
+ (id)formatNativeObjToJSObj:(id)obj;
+ (id)formatJSObjToNativeObj:(JSValue*)jsVal;
+ (void)synchronizedThreadSafeBlock:(id)obj block:(dispatch_block_t)block;
+ (const void * _Nonnull)getAssociatedObjKeyWith:(SEL)sel;
@end
NS_ASSUME_NONNULL_END
