//
//  BarView.swift
//  hackatime macos
//
//  Created by alice on 24/06/2025.
//

import SwiftUI
import AppKit

struct BarView: View {
    var body: some View {
        VStack {
            Button("Settings") {
                SettingsWindowManager.shared.showSettings()
            }.keyboardShortcut("S")

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("Q")
        }
    }
}
