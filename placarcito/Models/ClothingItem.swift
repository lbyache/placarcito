//
//  ClothingItem.swift
//  placarcito
//

import Foundation
import SwiftData
import SwiftUI

public enum ClothingCategory: String, Codable, CaseIterable, Identifiable {
    case upper = "Partes de Arriba"
    case lower = "Partes de Abajo"
    case footwear = "Calzado"
    case outerwear = "Abrigos"
    case accessory = "Accesorios"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .upper: return "tshirt"
        case .lower: return "square.split.2x1"
        case .footwear: return "shoe"
        case .outerwear: return "coat"
        case .accessory: return "eyeglasses"
        }
    }
}

public enum ClothingSeason: String, Codable, CaseIterable, Identifiable {
    case allYear = "Todo el Año"
    case summer = "Verano"
    case winter = "Invierno"
    case transitional = "Media Estación"
    
    public var id: String { rawValue }
}

public enum ClothingOccasion: String, Codable, CaseIterable, Identifiable {
    case casual = "Casual"
    case formal = "Formal"
    case smartCasual = "Elegante Sport"
    case sport = "Deportivo"
    case work = "Trabajo"
    
    public var id: String { rawValue }
}

public enum LaundryStatus: String, Codable, CaseIterable, Identifiable {
    case clean = "Limpio"
    case dirty = "Para Lavar"
    case inLaundry = "En Lavadero"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .clean: return "checkmark.circle.fill"
        case .dirty: return "exclamationmark.triangle.fill"
        case .inLaundry: return "washer.fill"
        }
    }
    
    public var colorHex: String {
        switch self {
        case .clean: return "#10B981"
        case .dirty: return "#F59E0B"
        case .inLaundry: return "#3B82F6"
        }
    }
}

@Model
public final class ClothingItem {
    public var id: UUID
    public var name: String
    public var categoryRaw: String
    public var subCategory: String
    public var primaryColorHex: String
    public var secondaryColorHex: String?
    public var colorName: String
    public var seasonRaw: String
    public var occasionRaw: String
    public var laundryStatusRaw: String
    public var wearCount: Int
    public var purchasePrice: Double
    public var purchaseDate: Date
    public var photoData: Data?
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        category: ClothingCategory,
        subCategory: String = "",
        primaryColorHex: String = "#000000",
        secondaryColorHex: String? = nil,
        colorName: String = "Negro",
        season: ClothingSeason = .allYear,
        occasion: ClothingOccasion = .casual,
        laundryStatus: LaundryStatus = .clean,
        wearCount: Int = 0,
        purchasePrice: Double = 0.0,
        purchaseDate: Date = Date(),
        photoData: Data? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.categoryRaw = category.rawValue
        self.subCategory = subCategory
        self.primaryColorHex = primaryColorHex
        self.secondaryColorHex = secondaryColorHex
        self.colorName = colorName
        self.seasonRaw = season.rawValue
        self.occasionRaw = occasion.rawValue
        self.laundryStatusRaw = laundryStatus.rawValue
        self.wearCount = wearCount
        self.purchasePrice = purchasePrice
        self.purchaseDate = purchaseDate
        self.photoData = photoData
        self.createdAt = createdAt
    }
    
    public var category: ClothingCategory {
        get { ClothingCategory(rawValue: categoryRaw) ?? .upper }
        set { categoryRaw = newValue.rawValue }
    }
    
    public var season: ClothingSeason {
        get { ClothingSeason(rawValue: seasonRaw) ?? .allYear }
        set { seasonRaw = newValue.rawValue }
    }
    
    public var occasion: ClothingOccasion {
        get { ClothingOccasion(rawValue: occasionRaw) ?? .casual }
        set { occasionRaw = newValue.rawValue }
    }
    
    public var laundryStatus: LaundryStatus {
        get { LaundryStatus(rawValue: laundryStatusRaw) ?? .clean }
        set { laundryStatusRaw = newValue.rawValue }
    }
    
    public var costPerWear: Double {
        guard wearCount > 0 else { return purchasePrice }
        return purchasePrice / Double(wearCount)
    }
}
