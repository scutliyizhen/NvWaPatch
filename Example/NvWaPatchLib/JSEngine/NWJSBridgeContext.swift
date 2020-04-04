//
//  NWJSBridgeContext.swift
//  NWPatch
//
//  Created by 李义真 on 2019/7/26.
//

import UIKit
import JavaScriptCore

class NWJSBridgeContext: NSObject {
    //MARK:调用方法
    func callInstanceNativeFunction(obj:JSValue, selectorName:String, arguments:JSValue, isSuper:Bool) -> Any? {
        if let instance:NSObject = NWUtils.formatJSObj(toNativeObj:obj) as? NSObject {
            let sel = NSSelectorFromString(selectorName);
            let method = NWObjCMethod.init(hookCls: instance.classForCoder, selector: sel, isClsMethod: false);
            let result = method.invoke(arguments, target: instance);
            return NWUtils.formatNativeObj(toJSObj: result);
        }
        return nil;
    }
    
    func callClassMethodNativeFunction(clsName:String , selectorName:String, arguments:JSValue) -> Any? {
        if let cls = NSClassFromString(clsName) {
            let sel = NSSelectorFromString(selectorName);
            let method = NWObjCMethod.init(hookCls: cls, selector:sel , isClsMethod: true);
            let result = method.invoke(arguments, target: cls);
            return NWUtils.formatNativeObj(toJSObj: result);
        }
        return nil;
    }
    
    //MARK:重新定义类与方法协议等
    func defineClassNativeFunction(classDeclaration:String, instanceMethods:JSValue, classMethods:JSValue) -> Dictionary<String,Any>? {
        let parse = NWDefineDSLParse.init(classDeclaration: classDeclaration);
        
        var clsNameNS:NSString? = nil;
        var result:[String:String] = [String:String]();
        if let cls = parse.cls {
            //实例方法注册
            self.overrideNativeInstanceMethods(cls: cls, instanceMethods: instanceMethods);
            let clsName = NSStringFromClass(cls);
            clsNameNS = NSString.init(string: clsName);
            
            result["cls"] = clsName;
        }
       
        if let clsUtf8 = clsNameNS?.utf8String,let metaCls = objc_getMetaClass(clsUtf8) as? AnyClass {
            //类方法注册
            self.overrideNativeClassMethod(metaCls: metaCls, clsMethods: classMethods);
        }
        
        if let superCls = parse.superCls {
            result["superCls"] = NSStringFromClass(superCls);
        } else {
            result["superCls"] = "NSObject";
        }
        return result;
    }
}

extension NWJSBridgeContext {
    private func overrideNativeInstanceMethods(cls:AnyClass, instanceMethods:JSValue) -> Void {
        if let jsMethodsMap = instanceMethods.toDictionary() as? Dictionary<String,Any> {
            for (jsMethodName, _) in jsMethodsMap {
                if let jsMethodArr = instanceMethods.forProperty(jsMethodName) {
                    let jsMethod = NWJSMethod.init(jsMethodName: jsMethodName, jsMethodArr: jsMethodArr, hookCls: cls, isClsMethod: false);
                    _ = NWFuncHook.hookMethod(jsMethod: jsMethod);
                }
            }
        }
    }

    private func overrideNativeClassMethod(metaCls:AnyClass, clsMethods:JSValue) -> Void {
        if let jsMethodsMap = clsMethods.toDictionary() as? Dictionary<String,Any> {
            for (jsMethodName, value) in jsMethodsMap {
                if let jsMethodArr = value as? JSValue {
                    let jsMethod = NWJSMethod.init(jsMethodName: jsMethodName, jsMethodArr: jsMethodArr, hookCls:metaCls, isClsMethod:true);
                    _ = NWFuncHook.hookMethod(jsMethod: jsMethod);
                }
            }
        }
    }
}
