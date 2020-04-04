//
//  NWFuncHook.swift
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/7/31.
//  Copyright © 2019 liyizhen. All rights reserved.
//

import UIKit

let NWMethodPrefix = "nw_original_";

class NWFuncHook: NSObject {
    @objc(Result)
    enum Result:Int {
        case Success = -1
        case ErrorMethodNotFound = -2
        case Other = -3
    }
    
    @objc class func hookMethod(jsMethod:NWJSMethod) -> Result{
        if let hookCls = jsMethod.hoolCls {
            var hookInfoPool = NWFuncHookInfoPool.getHookInfoPool(hookCls: hookCls);
            if hookInfoPool == nil {
                let newHookInfoPool = NWFuncHookInfoPool.init();
                NWFuncHookInfoPool.setHookInfoPool(hookCls: hookCls, hookInfoPool: newHookInfoPool);
                hookInfoPool = newHookInfoPool;
            }
            if let pool = hookInfoPool {
                let newHookInfo = NWObjCHookInfo.init(jsMethod: jsMethod);
                pool.setHookInfo(hookInfo: newHookInfo);
                //hook(重复hook，暂时不考虑)
                if jsMethod.canHook() {
                    //hookInfo?.setupHook();
                    newHookInfo.setupHook();
                }
                return .Success;
            } else {
                return .Other;
            }
        } else {
            return .Other;
        }
    }
}
