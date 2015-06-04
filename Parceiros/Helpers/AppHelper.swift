//
//  AppHelper.swift
//  Parceiros
//
//  Created by Caio Cezar Lopes dos Santos on 04/06/15.
//  Copyright (c) 2015 Corpo na Medida. All rights reserved.
//

import UIKit

class AppHelper: NSObject {
    
    private static var online = false    
    
    class func isOnline() -> Bool {
        return AFNetworkReachabilityManager.sharedManager().reachable
    }
    
    class func startMonitoringConnection() {
        let block:(status: AFNetworkReachabilityStatus) -> (Void) = { (status) -> (Void) in
            
            let oldStatus = self.online
            let stringStatus = AFStringFromNetworkReachabilityStatus(status)
            println(stringStatus)
            
            var reachable:Bool
            
            switch (status.rawValue) {
            case 0:
                self.online = false
            case 1...2:
                self.online = true
            default:
                self.online = false
            }
            
            if self.online == false && oldStatus == true {
                self.showAlert("Você está sem conexão a internet")
            }
        }
        
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock(block)
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
    }
    
    class func stopMonitoringConnection() {
        AFNetworkReachabilityManager.sharedManager().stopMonitoring()
    }
    
    class func showAlert(message: String) -> Void {
        showAlert(nil, message: message, button: "OK")
    }
    
    class func showAlert(title: String?, message: String?, button: String?) -> Void {
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: button).show()
    }
    
}
