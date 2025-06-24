//
//  SettingsView.swift
//  hackatime macos
//
//  Created by alice on 24/06/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("slackid") private var slackid = ""
    @AppStorage("timezone") private var timezone = TimeZone.current.identifier

    private let timezones = TimeZone.knownTimeZoneIdentifiers.sorted()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Hackatime-Menubar").font(.largeTitle).padding(.bottom, 20)

            Text("What's your slackid?")
                .font(.headline)
            TextField("What's your slack id?", text: $slackid)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 5)
                .frame(width: 300)

            Text("Select your Timezone")
                .font(.headline)
            Picker("", selection: $timezone) {
                ForEach(timezones, id: \.self) { id in
                    Text(id).tag(id)
                }
            }
            .pickerStyle(PopUpButtonPickerStyle())
            .labelsHidden()
            .padding(.bottom, 5)
            .frame(width: 300)
        }
        .padding(20)
        .frame(minWidth: 350)
        // Add .frame(maxWidth: .infinity, maxHeight: .infinity) if this is the root of a sheet/full screen
        // or if you want it to take up all available space when presented.
        // If it's a sheet, consider adding a NavigationView around the content for better presentation.
    }
}
