//
//  OutfitEngine.swift
//  placarcito
//

import Foundation

public struct OutfitEngine {
    
    public static func generateOutfit(
        from items: [ClothingItem],
        occasion: ClothingOccasion = .casual,
        temperatureC: Int = 20,
        onlyClean: Bool = true
    ) -> [ClothingItem] {
        var availableItems = items
        if onlyClean {
            availableItems = availableItems.filter { $0.laundryStatus == .clean }
        }
        
        // Filter by occasion if possible (fallback to all if too few)
        let occasionItems = availableItems.filter { $0.occasion == occasion || $0.occasion == .casual }
        let candidatePool = occasionItems.isEmpty ? availableItems : occasionItems
        
        // Group by category
        let uppers = candidatePool.filter { $0.category == .upper }
        let lowers = candidatePool.filter { $0.category == .lower }
        let footwears = candidatePool.filter { $0.category == .footwear }
        let outerwears = candidatePool.filter { $0.category == .outerwear }
        let accessories = candidatePool.filter { $0.category == .accessory }
        
        var selectedOutfit: [ClothingItem] = []
        
        // 1. Pick Upper
        guard let upper = uppers.shuffled().first ?? availableItems.first(where: { $0.category == .upper }) else {
            return []
        }
        selectedOutfit.append(upper)
        
        // 2. Pick Lower that matches color / style
        let matchingLowers = lowers.sorted { l1, l2 in
            colorHarmonyScore(color1: upper.primaryColorHex, color2: l1.primaryColorHex) >
            colorHarmonyScore(color1: upper.primaryColorHex, color2: l2.primaryColorHex)
        }
        if let lower = matchingLowers.first {
            selectedOutfit.append(lower)
        }
        
        // 3. Pick Footwear
        let matchingFootwear = footwears.sorted { f1, f2 in
            colorHarmonyScore(color1: upper.primaryColorHex, color2: f1.primaryColorHex) >
            colorHarmonyScore(color1: upper.primaryColorHex, color2: f2.primaryColorHex)
        }
        if let footwear = matchingFootwear.first {
            selectedOutfit.append(footwear)
        }
        
        // 4. Add Outerwear if temp < 18°C
        if temperatureC < 18 {
            if let outerwear = outerwears.shuffled().first {
                selectedOutfit.append(outerwear)
            }
        }
        
        // 5. Add Accessory optional
        if let accessory = accessories.shuffled().first {
            selectedOutfit.append(accessory)
        }
        
        return selectedOutfit
    }
    
    // Simple color harmony score between hex colors (Neutral anchors vs high contrast vs complementary)
    public static func colorHarmonyScore(color1: String, color2: String) -> Int {
        let c1 = color1.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let c2 = color2.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Neutrals (White, Black, Gray, Navy, Beige) match everything
        let neutrals = ["#ffffff", "#000000", "#18181b", "#27272a", "#f4f4f5", "#d4d4d8", "#1e293b", "#bae6fd", "ffffff", "000000"]
        if neutrals.contains(c1) || neutrals.contains(c2) {
            return 10
        }
        
        if c1 == c2 {
            return 8 // Monochromatic look
        }
        
        return 5
    }
}
