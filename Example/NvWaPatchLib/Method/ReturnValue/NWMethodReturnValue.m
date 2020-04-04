//
//  NWMethodReturnValue.m
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/10.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import "NWMethodReturnValue.h"

@interface NWMethodReturnValue()
{
    const char * _returnType;
}
@property (nonatomic ,strong)NSInvocation *invocation;
@property (nonatomic)SEL sel;
@end

@implementation NWMethodReturnValue
- (instancetype)initWith:(NSInvocation*)invocation sel:(SEL)sel returnType:(const char*)returnType {
    if (self = [super init]) {
        self.invocation = invocation;
        self.sel = sel;
        _returnType = returnType;
    }
    return  self;
}

- (id)getReturnValue {
    id returnValue;
    if (strncmp(_returnType, "v", 1) != 0) {
        if (strncmp(_returnType, "@", 1) == 0) {
            void *result;
            [_invocation getReturnValue:&result];
            
            NSString *selectorName = NSStringFromSelector(self.sel);
            
            if ([selectorName isEqualToString:@"alloc"] || [selectorName isEqualToString:@"new"] ||
                [selectorName isEqualToString:@"copy"] || [selectorName isEqualToString:@"mutableCopy"]) {
                returnValue = (__bridge_transfer id)result;
            } else {
                returnValue = (__bridge id)result;
            }
            return returnValue;
        } else {
            switch (_returnType[0] == 'r' ? _returnType[1] : _returnType[0]) {
                    
                #define NW_RETURN_VALUE_INVOCATION(_typeString, _type) \
                case _typeString: {                              \
                _type tempResultSet; \
                [_invocation getReturnValue:&tempResultSet];\
                returnValue = @(tempResultSet); \
                break; \
                }
                
                NW_RETURN_VALUE_INVOCATION('c', char)
                NW_RETURN_VALUE_INVOCATION('C', unsigned char)
                NW_RETURN_VALUE_INVOCATION('s', short)
                NW_RETURN_VALUE_INVOCATION('S', unsigned short)
                NW_RETURN_VALUE_INVOCATION('i', int)
                NW_RETURN_VALUE_INVOCATION('I', unsigned int)
                NW_RETURN_VALUE_INVOCATION('l', long)
                NW_RETURN_VALUE_INVOCATION('L', unsigned long)
                NW_RETURN_VALUE_INVOCATION('q', long long)
                NW_RETURN_VALUE_INVOCATION('Q', unsigned long long)
                NW_RETURN_VALUE_INVOCATION('f', float)
                NW_RETURN_VALUE_INVOCATION('d', double)
                NW_RETURN_VALUE_INVOCATION('B', BOOL)
            }
            return returnValue;
        }
    }
    return nil;
}
@end
