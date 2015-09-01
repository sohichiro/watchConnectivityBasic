//
//  InterfaceController.swift
//  watchConnectivityBasicWatch Extension
//
//  Created by 長尾 聡一郎 on 2015/09/01.
//  Copyright © 2015年 長尾 聡一郎. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet var unlockAfterRebootLabel: WKInterfaceLabel!
    @IBOutlet var reachabilityLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()
            print("active Session in InterfaceController")
        }
        
        self.reloadView( WCSession.defaultSession() )
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func sessionReachabilityDidChange(session: WCSession) {
        self.reloadView(session)
    }
    
    func reloadView(session: WCSession){
        let deviceFlg = session.iOSDeviceNeedsUnlockAfterRebootForReachability ? "true=we should unlock" : "false=we can use"
        let reachabilityFlg = session.reachable ? "reachable" : "unreachable"
        
        dispatch_async(dispatch_get_main_queue(), {
            self.unlockAfterRebootLabel.setText(deviceFlg)
            self.reachabilityLabel.setText(reachabilityFlg)
        })
    }
}
