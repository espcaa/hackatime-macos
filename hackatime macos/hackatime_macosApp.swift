//
//  hackatime_macosApp.swift
//  hackatime macos
//
//  Created by alice on 24/06/2025.
//

import SwiftUI

import SwiftUI

@main
struct MenuBarApp: App {
    @StateObject private var timeFetcher = TimeFetcher()

    var body: some Scene {
        MenuBarExtra {
            BarView()
                .environmentObject(timeFetcher)
        } label: {
            HStack {
                Image(systemName: "clock.fill")
                Text(timeFetcher.currentTime)
            }
        }
        Settings {
            SettingsView()
        }
    }
}


