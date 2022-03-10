//
//  ZoomStatusApp.swift
//  ZoomStatus
//
//  Created by Lam, Jarod on 10/3/2022.
//

import AppKit
import SwiftUI

@main
struct ZoomStatusApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var statusBar: StatusBarController?
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                EmptyView()
          }
          .hidden()
        }
    }
}
