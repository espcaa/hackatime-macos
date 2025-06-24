//
//  Fetcher.swift
//  hackatime macos
//
//  Created by alice on 24/06/2025.
//

import SwiftUI

@MainActor
class TimeFetcher: ObservableObject {
    @AppStorage("slackid") private var slackid = ""
    @AppStorage("timezone") private var timezone = TimeZone.current.identifier
    
    @Published var currentTime: String = "Fetching..."

    private var timer: Timer?

    init() {
        startTimer()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            Task {
                await self.fetchTime()
            }
        }
        Task {
            await fetchTime()
        }
    }

    func fetchTime() async {
        guard isValidSlackID(slackid) else {
            currentTime = "Wrong SlackID"
            return
        }
        
        // Get user's TimeZone from stored string, default to current if invalid
        let userTimeZone = TimeZone(identifier: timezone) ?? TimeZone.current
        
        // Get start and end of today in user's timezone, then convert to UTC ISO8601 strings
        let calendar = Calendar.current
        var calendarWithTZ = calendar
        calendarWithTZ.timeZone = userTimeZone
        
        let now = Date()
        guard let startOfDay = calendarWithTZ.date(from: calendarWithTZ.dateComponents([.year, .month, .day], from: now)),
              let endOfDay = calendarWithTZ.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay) else {
            currentTime = "Date error"
            return
        }
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        let startDateStr = isoFormatter.string(from: startOfDay)
        let endDateStr = isoFormatter.string(from: endOfDay)
        
        // Build API URL
        guard var urlComponents = URLComponents(string: "https://hackatime.hackclub.com/api/v1/users/\(slackid)/stats") else {
            currentTime = "Invalid URL"
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "start_date", value: startDateStr),
            URLQueryItem(name: "end_date", value: endDateStr),
            URLQueryItem(name: "features", value: "projects")
        ]
        
        guard let url = urlComponents.url else {
            currentTime = "Invalid URL"
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                currentTime = "HTTP Error"
                return
            }
            
            // Parse JSON
            struct ApiResponse: Codable {
                struct Project: Codable {
                    let total_seconds: Int
                }
                struct Data: Codable {
                    let projects: [Project]
                }
                let data: Data
            }
            
            let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
            
            let totalSeconds = apiResponse.data.projects.reduce(0) { $0 + $1.total_seconds }
            
            currentTime = formatDuration(totalSeconds)
            
        } catch {
            currentTime = "Fetch error: \(error.localizedDescription)"
        }
    }

    // Helper to format seconds as Hh Mm Ss
    func formatDuration(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        
        var components = [String]()
        if h > 0 { components.append("\(h)h") }
        if m > 0 { components.append("\(m)m") }
        if s > 0 && h == 0 { components.append("\(s)s") } // show seconds only if under 1h
        
        return components.joined(separator: " ")
    }


    deinit {
        timer?.invalidate()
    }
}

func isValidSlackID(_ id: String) -> Bool {
    let pattern = #"^[UWCGA][0-9A-Z]{8,}$"#
    return id.range(of: pattern, options: .regularExpression) != nil
}
