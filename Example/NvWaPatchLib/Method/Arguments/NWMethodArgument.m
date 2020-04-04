//
//  NWMethodArgument.m
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/10.
//  Copyright © 2019 liyizhen. All rights reserved.
//
#import "NWUtils.h"
#import "NWMethodArgument.h"

@interface NWMethodArgument() {
    const char * _argumentType;
}
@property (nonatomic ,strong ,readwrite)JSValue* arg;
@end

@implementation NWMethodArgument
- (instancetype)initWithJSArg:(JSValue*)arg argumentType:(const char *)argumentType {
    if (self = [super init]) {
        self.arg = arg;
        _argumentType = argumentType;
    }
    return self;
}

- (void)setArgumentValueInvocation:(NSInvocation*)invocation index:(NSInteger)index {
    id valObj = [NWUtils formatJSObjToNativeObj:self.arg];
//    void* returnValue = NULL;
    switch (_argumentType[0] == 'r' ? _argumentType[1] : _argumentType[0]) {
        #define NW_ARG_TYPE_VALUE(_typeString, _type, _selector) \
        case _typeString: {         \
        _type value = [valObj _selector];    \
        [invocation setArgument:&value atIndex:index];  \
        break;   \
        }
        NW_ARG_TYPE_VALUE('c', char, charValue)
        NW_ARG_TYPE_VALUE('C', unsigned char, unsignedCharValue)
        NW_ARG_TYPE_VALUE('s', short, shortValue)
        NW_ARG_TYPE_VALUE('S', unsigned short, unsignedShortValue)
        NW_ARG_TYPE_VALUE('i', int, intValue)
        NW_ARG_TYPE_VALUE('I', unsigned int, unsignedIntValue)
        NW_ARG_TYPE_VALUE('l', long, longValue)
        NW_ARG_TYPE_VALUE('L', unsigned long, unsignedLongValue)
        NW_ARG_TYPE_VALUE('q', long long, longLongValue)
        NW_ARG_TYPE_VALUE('Q', unsigned long long, unsignedLongLongValue)
        NW_ARG_TYPE_VALUE('f', float, floatValue)
        NW_ARG_TYPE_VALUE('d', double, doubleValue)
        NW_ARG_TYPE_VALUE('B', BOOL, boolValue)
        case '{': {
            NSString *typeString = [self extractStructName:[NSString stringWithUTF8String:_argumentType]];
            #define NW_ARG_STRUCT_VALUE(_type, _methodName) \
            if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
            _type value = [_arg _methodName];  \
            [invocation setArgument:&value atIndex:index];       \
            break; \
            }
            NW_ARG_STRUCT_VALUE(CGRect, toRect)
            NW_ARG_STRUCT_VALUE(CGPoint, toPoint)
            NW_ARG_STRUCT_VALUE(CGSize, toSize)
            NW_ARG_STRUCT_VALUE(NSRange, toRange)
            break;
        }
        default:
//            returnValue = &valObj;
            [invocation setArgument:&valObj atIndex:index];  \
            break;
    }
//    long long value = [valObj longLongValue];
//    long long* add = &value;
//    int a = 10;
//
//    return  add;
}

-(NSString*)extractStructName:(NSString*)typeEncodeString
{
    NSArray *array = [typeEncodeString componentsSeparatedByString:@"="];
    NSString *typeString = array[0];
    int firstValidIndex = 0;
    for (int i = 0; i< typeString.length; i++) {
        char c = [typeString characterAtIndex:i];
        if (c == '{' || c=='_') {
            firstValidIndex++;
        }else {
            break;
        }
    }
    return [typeString substringFromIndex:firstValidIndex];
}
@end
