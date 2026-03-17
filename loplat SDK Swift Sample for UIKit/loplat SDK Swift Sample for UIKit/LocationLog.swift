//
//  LocationLog.swift
//  loplat SDK Swift Sample for UIKit
//

import Foundation

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
