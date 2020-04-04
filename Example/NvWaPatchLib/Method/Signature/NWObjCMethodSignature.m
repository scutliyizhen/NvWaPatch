//
//  NWObjCMethodSignature.m
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/1.
//  Copyright © 2019 liyizhen. All rights reserved.
//

#import "NWObjCMethodSignature.h"

@implementation NWObjCMethodSignature
{
    NSString *_typeNames;
    NSMutableArray *_argumentTypes;
    NSString *_returnType;
    NSString *_types;
}

- (instancetype)initWithObjCTypes:(NSString *)objCTypes {
    self = [super init];
    if (self) {
        _types = objCTypes;
        [self _genarateTypes];
    }
    return self;
}

//sel: v24@0:8@16 -> v,@,:,@
//block: v24@?0@\"<StingerParams>\"8@\"NSString\"16 -> v,@?,@,@
- (void)_genarateTypes {
    _argumentTypes = [[NSMutableArray alloc] init];
    NSInteger descNum1 = 0; // num of '\"' in block signature type encoding
    NSInteger descNum2 = 0; // num of '<' or '>' in block signature type encoding
    for (int i = 0; i < _types.length; i ++) {
        unichar c = [_types characterAtIndex:i];
        
        NSString *arg;
        if (c == '\"') ++descNum1;
        if ((descNum1 % 2) != 0 || c == '\"' || isdigit(c)) {
            continue;
        }
        
        if (c == '<' || c == '>') ++descNum2;
        if ((descNum2 % 2) != 0 || c == '<' || c == '>') {
            continue;
        }
        
        BOOL skipNext = NO;
        if (c == '^') {
            skipNext = YES;
            arg = [_types substringWithRange:NSMakeRange(i, 2)];
            
        } else if (c == '?') {
            // @? is block
            arg = [_types substringWithRange:NSMakeRange(i - 1, 2)];
            [_argumentTypes removeLastObject];
            
        } else if (c == '{') {
            NSUInteger end = [[_types substringFromIndex:i] rangeOfString:@"}"].location + i;
            arg = [_types substringWithRange:NSMakeRange(i, end - i + 1)];
            if (i == 0) {
                _returnType = arg;
            } else {
                [_argumentTypes addObject:arg];
            }
            i = (int)end;
            continue;
            
        } else {
            
            arg = [_types substringWithRange:NSMakeRange(i, 1)];
        }
        
        if (i == 0) {
            _returnType = arg;
        } else {
            [_argumentTypes addObject:arg];
        }
        if (skipNext) i++;
    }
}

- (NSArray *)argumentTypes {
    return _argumentTypes;
}

- (NSString *)types {
    return _types;
}

- (NSString *)returnType {
    return _returnType;
}
@end
