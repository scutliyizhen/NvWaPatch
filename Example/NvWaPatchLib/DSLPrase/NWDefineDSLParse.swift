//
//  NWDefineDSLParse.swift
//  NuWaPatch_Example
//
//  Created by 李义真 on 2019/8/10.
//  Copyright © 2019 liyizhen. All rights reserved.
//

import UIKit

class NWDefineDSLParse: NSObject {
    private(set) var classDeclaration:String?;
    private(set) var cls:AnyClass?;
    private(set) var superCls:AnyClass?;
    private(set) var protocols:Array<Protocol> = Array<Protocol>();
    
    @available(iOS, unavailable)
    override init() {
        super.init();
    }
    
    init(classDeclaration:String) {
        super.init();
        self.classDeclaration = classDeclaration;
        self.parse(classDeclaration: classDeclaration);
    }
    
    private func parse(classDeclaration:String) -> Void {
        let scanner = Scanner.init(string: classDeclaration);
        var classNameNS:NSString? = nil;
        var superClassNameNS:NSString? = nil;
        var protocolNamesNS:NSString? = nil;
        scanner.scanUpTo(":", into: &classNameNS);
        if !scanner.isAtEnd  {
            scanner.scanLocation = scanner.scanLocation + 1;
            scanner.scanUpTo("<", into: &superClassNameNS);
            if !scanner.isAtEnd {
                scanner.scanLocation = scanner.scanLocation + 1;
                scanner.scanUpTo(">", into: &protocolNamesNS);
            }
        }
        
        //类
        let whiteNewLineSpaces = CharacterSet.whitespacesAndNewlines;
        if let clsNS = classNameNS {
            self.cls =  NSClassFromString(String.init(clsNS).trimmingCharacters(in: whiteNewLineSpaces))
        }
        
        //父类
        if let superNS = superClassNameNS  {
            let superClassName = String.init(superNS).trimmingCharacters(in: whiteNewLineSpaces);
            self.superCls =  NSClassFromString(superClassName);
        }
        
        //协议
        if let protocolsArr = protocolNamesNS?.components(separatedBy: ",") {
            for protocolName in protocolsArr {
                let protocolNameNS = NSString.init(string: protocolName.trimmingCharacters(in: whiteNewLineSpaces));
                if let utf8Str = protocolNameNS.utf8String,let protocolTmp = objc_getProtocol(utf8Str) {
                    self.protocols.append(protocolTmp)
                }
            }
        }
    }
}
