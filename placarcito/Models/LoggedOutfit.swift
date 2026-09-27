//
//  LoggedOutfit.swift
//  placarcito
//

import Foundation
import SwiftData

@Model
public final class LoggedOutfit {
    public var id: UUID
    public var date: Date
    public var notes: String
    
    @Relationship(deleteRule: .nullify)
    public var outfit: Outfit?
    
    @Relationship(deleteRule: .nullify)
    public var customItems: [ClothingItem]
    
    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        notes: String = "",
        outfit: Outfit? = nil,
        customItems: [ClothingItem] = []
    ) {
        self.id = id
        self.date = date
        self.notes = notes
        self.outfit = outfit
        self.customItems = customItems
    }
    
    public var allItems: [ClothingItem] {
        if let outfit = outfit {
            return outfit.items
        }
        return customItems
    }
}
