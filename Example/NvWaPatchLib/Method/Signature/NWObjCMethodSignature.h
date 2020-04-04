//
//  NWObjCMethodSignature.h
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/1.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import "NWMethodSignature.h"

NS_ASSUME_NONNULL_BEGIN

@interface NWObjCMethodSignature : NWMethodSignature
@property (nonatomic, readonly) NSString *types;
@property (nonatomic, readonly) NSArray *argumentTypes;
@property (nonatomic, readonly) NSString *returnType;

- (instancetype)initWithObjCTypes:(NSString *)objCTypes;
@end

NS_ASSUME_NONNULL_END
