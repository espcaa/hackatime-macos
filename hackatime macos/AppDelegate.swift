//
//  AppDelegate.swift
//  hackatime macos
//
//  Created by alice on 24/06/2025.
//


import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "sparkles", accessibilityDescription: "MenuBarApp")
            button.toolTip = "Hello from the menu bar!"
        }

        // Create the menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(showSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    @objc func showSettings() {
        print("👋 Hello from the menu bar!")
    }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }
}
