//
//  hackatime_macosApp.swift
//  hackatime macos
//
//  Created by alice on 24/06/2025.
//

import SwiftUI

@main
struct MenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView() // We don't need any window
        }
    }
}
