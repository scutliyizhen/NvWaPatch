//
//  NWObjCHookInfo.m
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/1.
//  Copyright © 2019 liyizhen. All rights reserved.
//
#import <objc/runtime.h>

#import "ffi.h"
#import "NWJSMethod.h"
#import "NWObjCMethod.h"
#import "NWObjCHookInfo.h"
#import "NWObjCMethodSignature.h"

@interface NWObjCHookInfo(){
    ffi_cif _cif;
    ffi_cif _blockCif;
    ffi_type **_args;
    ffi_type **_blockArgs;
    ffi_closure *_closure;
}
@property (nonatomic ,strong)NWObjCMethod *method;
@property (nonatomic ,strong)NWJSMethod *jsMethod;
@property (nonatomic) IMP nuwaPatchIMP;
@end

@implementation NWObjCHookInfo
- (instancetype)initWithJSMethod:(NWJSMethod*)jsMethod {
    if (self = [super init]) {
        self.jsMethod = jsMethod;
        self.method = [[NWObjCMethod alloc] initWithHookCls:jsMethod.hoolCls selector:jsMethod.origionSEL isClsMethod:jsMethod.isClsMethod];
    }
    return self;
}

- (NSString*)key {
    return [NWHookInfo getKeyWithSel:self.method.sel hookCls:self.method.cls];
}

- (const char *)typeEncoding {
    const char * typeEncoding = [self.method typeEncoding];
    return typeEncoding;
}

- (BOOL)isCanHook {
    if (self.nuwaPatchIMP != self.method.imp) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setupHook {
    if([self isCanHook] == YES) {
        if (class_addMethod(self.method.cls, self.method.sel, self.nuwaPatchIMP, self.method.typeEncoding) == false) {
            class_replaceMethod(self.method.cls, self.method.sel, self.nuwaPatchIMP, self.method.typeEncoding);
        }
        SEL nw_origion_sel = NSSelectorFromString([NSString stringWithFormat:@"nw_original_%@",NSStringFromSelector(self.method.sel)]);
        if(class_addMethod(self.method.cls, nw_origion_sel, self.method.imp, self.method.typeEncoding) == false) {
            class_replaceMethod(self.method.cls, nw_origion_sel, self.method.imp, self.method.typeEncoding);
        }
    }
}

- (IMP)nuwaPatchIMP {
    if (_nuwaPatchIMP == NULL) {
        NWObjCMethodSignature *signature = self.method.signature;
        ffi_type *returnType = ffiTypeWithTypeh(signature.returnType);
        NSAssert(returnType, @"can't find a ffi_type of %@", signature.returnType);

        NSUInteger argumentCount = signature.argumentTypes.count;
        _args = malloc(sizeof(ffi_type *) * argumentCount) ;

        for (int i = 0; i < argumentCount; i++) {
            ffi_type* current_ffi_type = ffiTypeWithTypeh(signature.argumentTypes[i]);
            NSAssert(current_ffi_type, @"can't find a ffi_type of %@", signature.argumentTypes[i]);
            _args[i] = current_ffi_type;
        }

        _closure = ffi_closure_alloc(sizeof(ffi_closure), (void **)&_nuwaPatchIMP);

        if(ffi_prep_cif(&_cif, FFI_DEFAULT_ABI, (unsigned int)argumentCount, returnType, _args) == FFI_OK) {
            if (ffi_prep_closure_loc(_closure, &_cif, ffi_function, (__bridge void *)(self), _nuwaPatchIMP) != FFI_OK) {
                NSAssert(NO, @"genarate IMP failed");
            }
        } else {
            NSAssert(NO, @"FUCK");
        }
    }
    return _nuwaPatchIMP;
}

static void ffi_function(ffi_cif *cif, void *ret, void **args, void *userdata) {
    id userDataInfo = (__bridge id)userdata;
    if (userDataInfo && [userDataInfo isKindOfClass:[NWObjCHookInfo class]]) {
        NWObjCHookInfo *hookInfo = userDataInfo;
        //取参数
        NSMutableArray *argList = [[NSMutableArray alloc] init];
        void **slf = args[0];
        [argList addObject:(__bridge id)(*slf)];
        
        NSUInteger argumentCount = hookInfo.method.signature.argumentTypes.count;
        for (int i = 2; i < argumentCount; i++) {
            void **arg = args[i];
            [argList addObject:(__bridge id)(*arg)];
        }
        
        id result = [hookInfo.jsMethod callJSFunctionWithArguments:[argList copy]];
        ret = (void*)&result;
        //移除hookInfo
        //[NWFuncHookInfoPool.shared removeHookInfoWithKey:hookInfo.key];
    }
}

ffi_type * ffiTypeWithTypeh (NSString *type) {
    if ([type isEqualToString:@"@?"]) {
        return &ffi_type_pointer;
    }
    const char *c = [type UTF8String];
    switch (c[0]) {
        case 'v':
            return &ffi_type_void;
        case 'c':
            return &ffi_type_schar;
        case 'C':
            return &ffi_type_uchar;
        case 's':
            return &ffi_type_sshort;
        case 'S':
            return &ffi_type_ushort;
        case 'i':
            return &ffi_type_sint;
        case 'I':
            return &ffi_type_uint;
        case 'l':
            return &ffi_type_slong;
        case 'L':
            return &ffi_type_ulong;
        case 'q':
            return &ffi_type_sint64;
        case 'Q':
            return &ffi_type_uint64;
        case 'f':
            return &ffi_type_float;
        case 'd':
            return &ffi_type_double;
        case 'F':
#if CGFLOAT_IS_DOUBLE
            return &ffi_type_double;
#else
            return &ffi_type_float;
#endif
        case 'B':
            return &ffi_type_uint8;
        case '^':
            return &ffi_type_pointer;
        case '@':
            return &ffi_type_pointer;
        case '#':
            return &ffi_type_pointer;
        case ':':
            return &ffi_type_schar;
    }
    
    NSCAssert(NO, @"can't match a ffi_type of %@", type);
    return NULL;
}
@end

