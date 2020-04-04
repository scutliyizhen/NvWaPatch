//
//  NWFuncHookInfoPool.swift
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/1.
//  Copyright © 2019 liyizhen. All rights reserved.
//

import UIKit

class NWFuncHookInfoPool: NSObject {
    private var mutex:pthread_mutex_t = pthread_mutex_t();
    private var mutexAttr:pthread_mutexattr_t = pthread_mutexattr_t();
    private var hookInfoMap:Dictionary<String,NWHookInfo> = [String:NWHookInfo]();
    
    //MARK:生命周期
    override init() {
        super.init();
        pthread_mutexattr_init(&self.mutexAttr);
        pthread_mutexattr_settype(&self.mutexAttr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&self.mutex, &self.mutexAttr);
    }
    
    deinit {
        pthread_mutex_destroy(&self.mutex);
        pthread_mutexattr_destroy(&self.mutexAttr);
    }
    
    //MARK:类方法
    class func getHookInfoPool(hookCls:AnyClass) -> NWFuncHookInfoPool? {
        var hookInfoPool:NWFuncHookInfoPool? = nil;
        NWUtils.synchronizedThreadSafeBlock(hookCls) {
            let sel = Selector.init("nw_hookinfo_pool" + NSStringFromClass(hookCls));
            let key = NWUtils.getAssociatedObjKey(with: sel);
            hookInfoPool = objc_getAssociatedObject(hookCls,key) as? NWFuncHookInfoPool;
        };
        return hookInfoPool;
    }
    
    class func setHookInfoPool(hookCls:AnyClass, hookInfoPool:NWFuncHookInfoPool) -> Void {
        NWUtils.synchronizedThreadSafeBlock(hookCls) {
            let sel = Selector.init("nw_hookinfo_pool" + NSStringFromClass(hookCls));
            let key = NWUtils.getAssociatedObjKey(with: sel);
            objc_setAssociatedObject(hookCls, key, hookInfoPool, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        };
    }
    
    //MARK：公开方法
    func setHookInfo(hookInfo:NWHookInfo) -> Void {
        pthread_mutex_lock(&self.mutex);
        let key = hookInfo.key
        self.hookInfoMap[key] = hookInfo;
        pthread_mutex_unlock(&self.mutex);
    }
    
    func getHookInfo(key:String) -> NWHookInfo? {
        var hookInfo:NWHookInfo? = nil;
        pthread_mutex_lock(&self.mutex);
        hookInfo = self.hookInfoMap[key];
        pthread_mutex_unlock(&self.mutex);
        return hookInfo;
    }
    
    @objc func removeHookInfo(key:String) -> Void {
        pthread_mutex_lock(&self.mutex);
        self.hookInfoMap.removeValue(forKey: key);
        pthread_mutex_unlock(&self.mutex);
    }
}
