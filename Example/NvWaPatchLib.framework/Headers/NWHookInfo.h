//
//  NWHookInfo.h
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/1.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NWHookInfo : NSObject
@property (nonatomic, strong, readonly)NSString *key;
+ (NSString*)getKeyWithSel:(SEL)sel hookCls:(Class)hookCls;
@end

NS_ASSUME_NONNULL_END
