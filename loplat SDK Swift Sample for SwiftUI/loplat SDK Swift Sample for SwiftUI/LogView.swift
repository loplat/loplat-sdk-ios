//
//  LogView.swift
//  loplat SDK Swift Sample for SwiftUI
//

import SwiftUI

struct LogView: View {
    let locationLogs: [LocationLog]

    var body: some View {
        List {
            ForEach(locationLogs) { log in
                LocationLogRow(log: log)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let urlString = "https://www.google.com/maps/place/"+"\(log.latitude),\(log.longitude)"
                        
                        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
                        UIApplication.shared.open(url)
                    }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("위치 로그")
        .navigationBarTitleDisplayMode(.large)
    }
}
