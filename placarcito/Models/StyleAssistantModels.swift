//
//  StyleAssistantModels.swift
//  placarcito
//

import Foundation
import SwiftUI

public enum ChatSender: String, Codable {
    case user
    case assistant
}

public struct ChatMessage: Identifiable, Codable {
    public var id: UUID
    public var sender: ChatSender
    public var text: String
    public var timestamp: Date
    public var suggestedItemIds: [UUID]?
    public var suggestedOutfitName: String?
    
    public init(
        id: UUID = UUID(),
        sender: ChatSender,
        text: String,
        timestamp: Date = Date(),
        suggestedItemIds: [UUID]? = nil,
        suggestedOutfitName: String? = nil
    ) {
        self.id = id
        self.sender = sender
        self.text = text
        self.timestamp = timestamp
        self.suggestedItemIds = suggestedItemIds
        self.suggestedOutfitName = suggestedOutfitName
    }
}

public struct WeatherInfo {
    public var city: String
    public var temperatureC: Int
    public var condition: String
    public var iconName: String
    public var HighTempC: Int
    public var LowTempC: Int
    
    public init(city: String = "Buenos Aires", temperatureC: Int = 19, condition: String = "Parcialmente Nublado", iconName: String = "cloud.sun.fill", HighTempC: Int = 22, LowTempC: Int = 14) {
        self.city = city
        self.temperatureC = temperatureC
        self.condition = condition
        self.iconName = iconName
        self.HighTempC = HighTempC
        self.LowTempC = LowTempC
    }
}
