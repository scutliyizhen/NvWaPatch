//
//  NWJSDownloader.swift
//  NWPatch
//
//  Created by 李义真 on 2019/7/26.
//

import UIKit

class NWJSDownloader: NSObject,URLSessionDataDelegate {
    private lazy var session:URLSession = {
        let config = URLSessionConfiguration.default;
        let session = URLSession.init(configuration: config, delegate: self, delegateQueue: OperationQueue.main);
        return session;
    }();
    
    @objc func downloadJSResource(requestURL:URL, callBack:@escaping (_ success:Bool,_ script:String?, _ msg:String) -> Void) -> Void {
        var request = URLRequest.init(url: requestURL);
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData;
        let task:URLSessionDataTask = self.session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if let tmpData = data,let script = String.init(data: tmpData, encoding: String.Encoding.utf8) {
                callBack(true,script,"success");
            } else {
                callBack(false,nil, error?.localizedDescription ?? "脚本下载失败");
            }
        }
        task.resume();
    }
}
