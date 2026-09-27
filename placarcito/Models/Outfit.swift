//
//  Outfit.swift
//  placarcito
//

import Foundation
import SwiftData

@Model
public final class Outfit {
    public var id: UUID
    public var name: String
    public var occasionRaw: String
    public var minTemp: Int
    public var maxTemp: Int
    public var isFavorite: Bool
    public var wearCount: Int
    public var createdAt: Date
    
    @Relationship(deleteRule: .nullify)
    public var items: [ClothingItem]
    
    public init(
        id: UUID = UUID(),
        name: String,
        occasion: ClothingOccasion = .casual,
        minTemp: Int = 10,
        maxTemp: Int = 25,
        isFavorite: Bool = false,
        wearCount: Int = 0,
        createdAt: Date = Date(),
        items: [ClothingItem] = []
    ) {
        self.id = id
        self.name = name
        self.occasionRaw = occasion.rawValue
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.isFavorite = isFavorite
        self.wearCount = wearCount
        self.createdAt = createdAt
        self.items = items
    }
    
    public var occasion: ClothingOccasion {
        get { ClothingOccasion(rawValue: occasionRaw) ?? .casual }
        set { occasionRaw = newValue.rawValue }
    }
    
    public var isAvailableToWear: Bool {
        items.allSatisfy { $0.laundryStatus == .clean }
    }
}
