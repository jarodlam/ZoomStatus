//
//  AppDelegate.swift
//  ZoomStatus
//
//  Created by Lam, Jarod on 10/3/2022.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBar = StatusBarController.init()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
