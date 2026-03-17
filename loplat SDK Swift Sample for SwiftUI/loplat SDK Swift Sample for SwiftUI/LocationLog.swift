//
//  LocationLog.swift
//  loplat SDK Swift Sample for SwiftUI
//

import SwiftUI

// MARK: - Location Log Model

struct LocationLog: Identifiable, Codable {
    let id: UUID
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let timestamp: String

    init(
        id: UUID = UUID(),
        name: String,
        address: String,
        latitude: Double,
        longitude: Double,
        timestamp: String
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}

// MARK: - Location Log Row

struct LocationLogRow: View {
    let log: LocationLog

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(log.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.blue)
                Spacer()
                Text("\(log.latitude, specifier: "%.4f"), \(log.longitude, specifier: "%.4f")")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
            HStack {
                Text(log.address)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                Spacer()
                Text(log.timestamp)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
