//
//  ViewController.swift
//  watchConnectivityBasic
//
//  Created by 長尾 聡一郎 on 2015/09/01.
//  Copyright © 2015年 長尾 聡一郎. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    @IBOutlet weak var pairdStatusLabel: UILabel!
    @IBOutlet weak var installedStatusLabel: UILabel!
    @IBOutlet weak var reachableStatusLabel: UILabel!
    @IBOutlet weak var compEnabledStatusLabel: UILabel!
    @IBOutlet weak var watchDirLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.reloadStatuslabel(WCSession.defaultSession(), isSupported: WCSession.isSupported())
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            print("activate session on BaseView")
            
            if session.paired != true {
                print("Apple Watch is not paired")
            }
            
            if session.watchAppInstalled != true {
                print("WatchKit app is not installed")
            }
        }else {
            print("WatchConnectivity is not supported on this device")
        }
    }
    
    //reachabilityが変更になったとき呼ばれる
    func sessionReachabilityDidChange(session: WCSession) {
        self.reloadStatuslabel(WCSession.defaultSession(), isSupported: WCSession.isSupported())
    }
    
    //statusが変更になったとき呼ばれる
    func sessionWatchStateDidChange(session: WCSession) {
        self.reloadStatuslabel(WCSession.defaultSession(), isSupported: WCSession.isSupported())
    }
    
    func reloadStatuslabel(session: WCSession, isSupported:Bool) {
        var reachableStatus, pairdStatus, installedStatus, compEnableStatus, watchDir:String
        if isSupported {
            reachableStatus = session.reachable ? "reachable" : "unreachable"
            pairdStatus = session.paired ? "true" : "false"
            installedStatus = session.watchAppInstalled ? "true" : "false"
            compEnableStatus = session.complicationEnabled ? "true" : "false"
            
            if let watchURL = session.watchDirectoryURL {
                watchDir = watchURL.path!
            }else {
                watchDir = "--"
            }
        }
        else {
            reachableStatus = "--"
            pairdStatus = "--"
            installedStatus = "--"
            compEnableStatus = "--"
            watchDir = "--"
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.reachableStatusLabel.text = reachableStatus
            self.pairdStatusLabel.text = pairdStatus
            self.installedStatusLabel.text = installedStatus
            self.compEnabledStatusLabel.text = compEnableStatus
            self.watchDirLabel.text = watchDir
        })
    }

}

