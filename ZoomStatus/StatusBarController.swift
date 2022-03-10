//
//  StatusBarController.swift
//  ZoomStatus
//
//  Created by Lam, Jarod on 10/3/2022.
//

import AppKit
import SwiftUI

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private weak var timer: Timer?
    private var scriptObject: NSAppleScript?
    private var menuTitleItem: NSMenuItem
    
    let appleScriptBody: String = """
        property appName : "zoom.us"
        tell application "System Events"
            if not (exists process appName) then
                return "INVALID"
            end if
            tell process appName
                if not (exists (menu "Meeting" of menu bar 1)) then
                    return "INVALID"
                end if
                if (exists (menu item "Mute Audio" of menu "Meeting" of menu bar 1)) then
                    return "UNMUTED"
                end if
                if (exists (menu item "Unmute Audio" of menu "Meeting" of menu bar 1)) then
                    return "MUTED"
                end if
            end tell
        end tell
        return "INVALID"
        """
    
    init() {
        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        
        if let statusBarButton = statusItem.button {
//            statusBarButton.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: "Unmuted.")
//            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
//            statusBarButton.image?.isTemplate = true
            statusBarButton.title = "•"
        }
        
        let statusItemMenu = NSMenu(title: "Zoom Status")
        statusItem.menu = statusItemMenu
        menuTitleItem = NSMenuItem(
            title: "Initialising",
            action: nil,
            keyEquivalent: ""
        )
        statusItemMenu.addItem(menuTitleItem)
        statusItemMenu.addItem(
            withTitle: "Quit ZoomStatus",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: ""
        )
        
        scriptObject = NSAppleScript(source: appleScriptBody)
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(update),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func update() {
        // https://www.jessesquires.com/blog/2018/11/17/executing-applescript-in-mac-app-on-macos-mojave/
        print("Timer fired!")
        
        var status: String = "INVALID"
        var error: NSDictionary?
        if let script = scriptObject {
            print("Executing AppleScript...")
            let output: NSAppleEventDescriptor = script.executeAndReturnError(&error)
            print(output.stringValue ?? "no output")
            status = output.stringValue ?? "INVALID"
            
            if let error = error {
                print("error: \(String(describing: error))")
                changeStatusText(to: error["NSAppleScriptErrorMessage"] as! String)
                return
            }
        }
        
        switch status {
        case "MUTED":
            changeButtonText(to: "🔴")
            changeStatusText(to: "Muted")
        case "UNMUTED":
            changeButtonText(to: "🟢")
            changeStatusText(to: "Unmuted")
        default:
            changeButtonText(to: "•")
            changeStatusText(to: "No Zoom meeting detected")
        }
    }
    
    func changeButtonText(to: String) {
        if let statusBarButton = statusItem.button {
            statusBarButton.title = to
        }
    }
    
    func changeStatusText(to: String) {
        menuTitleItem.title = to
    }
    
}
