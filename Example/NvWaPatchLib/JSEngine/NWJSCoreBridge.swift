//
//  NWJSCoreBridge.swift
//  NWPatch_Example
//
//  Created by 李义真 on 2019/7/28.
//  Copyright © 2019 liyizhen. All rights reserved.
//

import Foundation
import JavaScriptCore


class NWJSCoreBridge: NSObject {
    private var jscoreContext:JSContext = JSContext.init();
    private var brigeContext: NWJSBridgeContext = NWJSBridgeContext();
    
    private var replaceStr = ".__c(\"$1\")(";
    private var regex:NSRegularExpression = try! NSRegularExpression.init(pattern:"(?<!\\\\)\\.\\s*(\\w+)\\s*\\(", options: NSRegularExpression.Options.caseInsensitive);
    
    //MARK:生命周期
    override init() {
        super.init();
        self.jscoreContext.name = "NWPatch JSContext";
    }
    
    //MARK:公开方法
    func initContext() -> Void {
        //脚本执行异常
        self.jscoreContext.exceptionHandler = {(jsContext:JSContext?, result:JSValue?) -> Void in
            print(String.init(format: "脚本执行错误：%@", result?.description ?? ""));
        };
        //注册通信方法
        self.registerJSCallFunction();
    }
    
    func evaluateRuntimeJavascript(script:String?) -> Void {
        _ = self.jscoreContext.evaluateScript(script);
    }
    
    func evaluateCaseJavascript(script:String?) -> Void {
        if let javascript = script {
             let formatedScript = String.init(format: ";(function(){try{\n%@\n}catch(e){_native_catch(e.message, e.stack)}})();", self.regex.stringByReplacingMatches(in: javascript, options:.withTransparentBounds , range: NSRange.init(location: 0, length: javascript.count), withTemplate: self.replaceStr));
            _ = self.jscoreContext.evaluateScript(formatedScript);
        }
    }
}

//客户端方法替换_native_defineClass
typealias NWJSCoreBridgeNativeDefineClassFunc = @convention(block) (_ classDeclaration:String, _ instanceMethods:JSValue, _ classMethods:JSValue) -> Dictionary<String,Any>?;
//调用客户端原生实例方法_Native_callI
typealias NWJSCoreBridgeNativeCallInstMethodsFunc = @convention(block) (_ obj:JSValue, _ selectorName:String, _ arguments:JSValue, _ isSuper:Bool) -> Any?;
//调用客户端原生类方法_Native_callC
typealias NWJSCoreBridgeNativeCallClsMethodsFunc =  @convention(block) (_ className:String, _ selectorName:String, _ arguments:JSValue) -> Any?;
 //客户端异常处理方法_native_catch
typealias NWJSCoreBridgeNativeExceptionCatchFunc =  @convention(block) (_ msg:JSValue, _ stack:JSValue) -> Void;
//打印调试
typealias NWJSCoreBridgeNativePoFunc =  @convention(block) (_ obj:JSValue) -> Void;

extension NWJSCoreBridge{
    //MARK:私有方法
    private func registerJSCallFunction() -> Void {
        weak var weakSelf = self;
        //客户端方法替换_native_defineClass
        let nativeDefineClass:NWJSCoreBridgeNativeDefineClassFunc = {(_ classDeclaration:String, _ instanceMethods:JSValue, _ classMethods:JSValue) -> Dictionary<String,Any>? in
            return weakSelf?.brigeContext.defineClassNativeFunction(classDeclaration: classDeclaration, instanceMethods: instanceMethods, classMethods: classMethods);
        };
        self.jscoreContext.setObject(nativeDefineClass, forKeyedSubscript: "_native_defineClass" as NSCopying & NSObjectProtocol);
        
        //调用客户端原生实例方法_Native_callI
        let nativeCallInstMethods:NWJSCoreBridgeNativeCallInstMethodsFunc = { (_ obj:JSValue, _ selectorName:String, _ arguments:JSValue, _ isSuper:Bool) -> Any? in
            return weakSelf?.brigeContext.callInstanceNativeFunction(obj: obj, selectorName: selectorName, arguments: arguments, isSuper: isSuper);
        };
        self.jscoreContext.setObject(nativeCallInstMethods, forKeyedSubscript: "_Native_callI" as NSCopying & NSObjectProtocol);
        
        //调用客户端原生类方法_Native_callC
        let nativeCallClsMethods:NWJSCoreBridgeNativeCallClsMethodsFunc = { (_ className:String, _ selectorName:String, _ arguments:JSValue) -> Any? in
            return weakSelf?.brigeContext.callClassMethodNativeFunction(clsName: className, selectorName: selectorName, arguments: arguments);
        };
        self.jscoreContext.setObject(nativeCallClsMethods, forKeyedSubscript: "_Native_callC" as NSCopying & NSObjectProtocol);
        
        //客户端异常处理方法_native_catch
        let nativeExceptionCatch:NWJSCoreBridgeNativeExceptionCatchFunc = {(_ msg:JSValue, _ stack:JSValue) -> Void in
            _exceptionBlock(String.init(format: "js exception, \nmsg: %@, \nstack: \n %@", msg.toObject().debugDescription, stack.toObject().debugDescription));
            return;
        };
        self.jscoreContext.setObject(nativeExceptionCatch, forKeyedSubscript: "_native_catch" as NSCopying & NSObjectProtocol);
        //客户端打印对象
        let nativePo:NWJSCoreBridgeNativePoFunc = {(_ obj:JSValue) -> Void in
            let nativeObj = NWUtils.formatJSObj(toNativeObj: obj) as AnyObject;
            print(nativeObj.debugDescription ?? "");
        };
        self.jscoreContext.setObject(nativePo, forKeyedSubscript: "po" as NSCopying & NSObjectProtocol);
    }
}
