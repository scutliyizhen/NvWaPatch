//
//  NWJSMethod.h
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/6.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import "NWMethod.h"
#import <JavaScriptCore/JSValue.h>



NS_ASSUME_NONNULL_BEGIN

@interface NWJSMethod : NWMethod
@property (nonatomic, readonly)SEL origionSEL;
@property (nonatomic, strong, readonly)NSString *jsMethodName;
@property (nonatomic, weak, readonly)Class hoolCls;
@property (nonatomic, assign ,readonly)BOOL isClsMethod;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithJSMethodName:(NSString*)jsMethodName
                         jsMethodArr:(JSValue*)jsMethodArr
                             hookCls:(Class)hookCls
                         isClsMethod:(BOOL)isClsMethod;
- (BOOL)canHook;
- (id)callJSFunctionWithArguments:(NSArray*)arguments;
@end

NS_ASSUME_NONNULL_END
