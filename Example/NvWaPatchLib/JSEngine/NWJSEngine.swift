//
//  NWJSEngine.swift
//  NWPatch
//
//  Created by 李义真 on 2019/7/26.
//

import Foundation;

public typealias NWJSEngineJavaScriptRefreshBlock = (_ success:Bool, _ msg:String) -> Void;

@objc
open class NWJSEngine: NSObject {
    private static let engine = NWJSEngine();
    //MARK:生命周期
    @objc public static var shared:NWJSEngine {
        return self.engine;
    }
    
    private lazy var downloader:NWJSDownloader = {
        let downloader = NWJSDownloader();
        return downloader;
    }();
    
    private lazy var jsCoreBridge:NWJSCoreBridge = {
        let bridge = NWJSCoreBridge();
        return bridge;
    }();
    
    //MARK:公开方法
    @objc
    open func startEngine() -> Void {
        self.jsCoreBridge.initContext();
    }
    
    @objc
    open func refreshRuntimeLoadJavascript(jsURL:String, callBack:@escaping NWJSEngineJavaScriptRefreshBlock) -> Void {
        self.downloadRuntimeJavascript(jsURL: jsURL, callBack: callBack);
    }
    
    @objc
    open func refreshNuWaPatchTestDemoLoadJavascript(jsURL:String, callBack:@escaping NWJSEngineJavaScriptRefreshBlock) -> Void {
        self.downloadNuWaPatchTestDemoJavascript(jsURL:jsURL, callBack: callBack);
    }
    
    //MARK:私有方法
    private func downloadRuntimeJavascript(jsURL:String, callBack:@escaping NWJSEngineJavaScriptRefreshBlock) -> Void {
        //下载脚本
        if let URL = URL.init(string: jsURL) {
            weak var weakSelf = self;
            self.downloader.downloadJSResource(requestURL: URL) { (success:Bool, script:String?, msg:String) in
                if let javascript = script {
                    weakSelf?.jsCoreBridge.evaluateRuntimeJavascript(script: javascript);
                    callBack(true,"success");
                } else {
                     callBack(false,"runtime脚本下载失败");
                }
            }
        }
    }
    
    private func downloadNuWaPatchTestDemoJavascript(jsURL:String, callBack:@escaping NWJSEngineJavaScriptRefreshBlock) -> Void {
        //下载脚本
        if let URL = URL.init(string:jsURL) {
            weak var weakSelf = self;
            self.downloader.downloadJSResource(requestURL: URL) { (success:Bool, script:String?, msg:String) in
                if let javascript = script {
                    weakSelf?.jsCoreBridge.evaluateCaseJavascript(script: javascript);
                    callBack(true,"success");
                } else {
                    callBack(false,"Demo脚本下载失败");
                }
            }
        }
    }
}
