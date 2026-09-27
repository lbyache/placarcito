//
//  SeedData.swift
//  placarcito
//

import Foundation
import SwiftData
import UIKit
import SwiftUI

public struct SeedData {
    public static func populateIfNeeded(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<ClothingItem>()
        do {
            let existingItems = try modelContext.fetch(descriptor)
            guard existingItems.isEmpty else { return }
            
            // Generate items
            let tShirtWhite = ClothingItem(
                name: "Remera Blanca Minimalist",
                category: .upper,
                subCategory: "Remera",
                primaryColorHex: "#FFFFFF",
                secondaryColorHex: "#E4E4E7",
                colorName: "Blanco",
                season: .allYear,
                occasion: .casual,
                laundryStatus: .clean,
                wearCount: 14,
                purchasePrice: 28.00,
                photoData: makeSampleImage(symbolName: "tshirt.fill", color: .black, bgColor: .white)
            )
            
            let leatherJacket = ClothingItem(
                name: "Campera de Cuero Biker",
                category: .outerwear,
                subCategory: "Campera",
                primaryColorHex: "#18181B",
                colorName: "Negro",
                season: .transitional,
                occasion: .smartCasual,
                laundryStatus: .clean,
                wearCount: 8,
                purchasePrice: 195.00,
                photoData: makeSampleImage(symbolName: "coat.fill", color: .white, bgColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
            )
            
            let blackJeans = ClothingItem(
                name: "Jeans Slim Fit Charcoal",
                category: .lower,
                subCategory: "Jeans",
                primaryColorHex: "#27272A",
                colorName: "Gris Oscuro",
                season: .allYear,
                occasion: .casual,
                laundryStatus: .clean,
                wearCount: 22,
                purchasePrice: 65.00,
                photoData: makeSampleImage(symbolName: "square.split.2x1.fill", color: .white, bgColor: UIColor(red: 0.15, green: 0.15, blue: 0.17, alpha: 1))
            )
            
            let whiteSneakers = ClothingItem(
                name: "Zapatillas Nordic Leather",
                category: .footwear,
                subCategory: "Zapatillas",
                primaryColorHex: "#F4F4F5",
                colorName: "Blanco Off-White",
                season: .allYear,
                occasion: .casual,
                laundryStatus: .clean,
                wearCount: 30,
                purchasePrice: 120.00,
                photoData: makeSampleImage(symbolName: "shoe.fill", color: .black, bgColor: UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1))
            )
            
            let woolBlazer = ClothingItem(
                name: "Saco Estilo Escandinavo Navy",
                category: .outerwear,
                subCategory: "Blazer",
                primaryColorHex: "#1E293B",
                colorName: "Azul Marino",
                season: .transitional,
                occasion: .work,
                laundryStatus: .clean,
                wearCount: 5,
                purchasePrice: 240.00,
                photoData: makeSampleImage(symbolName: "square.dashed", color: .white, bgColor: UIColor(red: 0.12, green: 0.16, blue: 0.23, alpha: 1))
            )
            
            let OxfordShirt = ClothingItem(
                name: "Camisa Oxford Celeste",
                category: .upper,
                subCategory: "Camisa",
                primaryColorHex: "#BAE6FD",
                colorName: "Azul Claro",
                season: .allYear,
                occasion: .smartCasual,
                laundryStatus: .dirty,
                wearCount: 11,
                purchasePrice: 55.00,
                photoData: makeSampleImage(symbolName: "tshirt", color: UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 1), bgColor: UIColor(red: 0.85, green: 0.93, blue: 0.98, alpha: 1))
            )
            
            let ChinoPants = ClothingItem(
                name: "Pantalón Chino Beige",
                category: .lower,
                subCategory: "Pantalón",
                primaryColorHex: "#D4D4D8",
                colorName: "Beige / Arena",
                season: .allYear,
                occasion: .smartCasual,
                laundryStatus: .clean,
                wearCount: 9,
                purchasePrice: 70.00,
                photoData: makeSampleImage(symbolName: "square.split.2x1", color: .darkGray, bgColor: UIColor(red: 0.88, green: 0.85, blue: 0.8, alpha: 1))
            )
            
            let BlackLoafers = ClothingItem(
                name: "Mocasines de Cuero Noir",
                category: .footwear,
                subCategory: "Zapatos",
                primaryColorHex: "#09090B",
                colorName: "Negro",
                season: .allYear,
                occasion: .formal,
                laundryStatus: .inLaundry,
                wearCount: 6,
                purchasePrice: 150.00,
                photoData: makeSampleImage(symbolName: "shoe", color: .white, bgColor: .black)
            )
            
            let WatchMinimal = ClothingItem(
                name: "Reloj Dial Monocromo",
                category: .accessory,
                subCategory: "Reloj",
                primaryColorHex: "#27272A",
                colorName: "Plata / Negro",
                season: .allYear,
                occasion: .smartCasual,
                laundryStatus: .clean,
                wearCount: 45,
                purchasePrice: 180.00,
                photoData: makeSampleImage(symbolName: "clock.fill", color: .white, bgColor: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
            )

            // Insert Items
            modelContext.insert(tShirtWhite)
            modelContext.insert(leatherJacket)
            modelContext.insert(blackJeans)
            modelContext.insert(whiteSneakers)
            modelContext.insert(woolBlazer)
            modelContext.insert(OxfordShirt)
            modelContext.insert(ChinoPants)
            modelContext.insert(BlackLoafers)
            modelContext.insert(WatchMinimal)
            
            // Create Sample Outfits
            let urbanMinimalOutfit = Outfit(
                name: "Minimal Urban Monochrome",
                occasion: .casual,
                minTemp: 12,
                maxTemp: 22,
                isFavorite: true,
                wearCount: 7,
                items: [tShirtWhite, leatherJacket, blackJeans, whiteSneakers, WatchMinimal]
            )
            
            let smartBusinessOutfit = Outfit(
                name: "Smart Nordic Business",
                occasion: .work,
                minTemp: 14,
                maxTemp: 24,
                isFavorite: false,
                wearCount: 3,
                items: [OxfordShirt, woolBlazer, ChinoPants, BlackLoafers, WatchMinimal]
            )
            
            modelContext.insert(urbanMinimalOutfit)
            modelContext.insert(smartBusinessOutfit)
            
            // Logged History
            let todayLog = LoggedOutfit(
                date: Date(),
                notes: "Look para oficina y café por la tarde",
                outfit: urbanMinimalOutfit
            )
            modelContext.insert(todayLog)
            
            try modelContext.save()
        } catch {
            print("Error initializing seed data: \(error)")
        }
    }
    
    private static func makeSampleImage(symbolName: String, color: UIColor, bgColor: UIColor) -> Data? {
        let size = CGSize(width: 400, height: 400)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            bgColor.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            let config = UIImage.SymbolConfiguration(pointSize: 140, weight: .semibold)
            if let symbolImage = UIImage(systemName: symbolName, withConfiguration: config)?.withTintColor(color, renderingMode: .alwaysOriginal) {
                let symbolSize = symbolImage.size
                let rect = CGRect(
                    x: (size.width - symbolSize.width) / 2,
                    y: (size.height - symbolSize.height) / 2,
                    width: symbolSize.width,
                    height: symbolSize.height
                )
                symbolImage.draw(in: rect)
            }
        }
        
        return image.jpegData(compressionQuality: 0.8)
    }
}
