//
//  OutfitEngineTests.swift
//  placarcitoTests
//

import Foundation

public struct OutfitEngineTests {
    public static func runTests() -> (passed: Int, failed: Int, logs: [String]) {
        var passed = 0
        var failed = 0
        var logs: [String] = []

        func assert(_ condition: Bool, _ message: String) {
            if condition {
                passed += 1
                logs.append("  ✅ PASS: \(message)")
            } else {
                failed += 1
                logs.append("  ❌ FAIL: \(message)")
            }
        }

        logs.append("--- [Suite 1: OutfitEngineTests] ---")

        // Setup test data
        let cleanUpper = ClothingItem(
            name: "Remera Blanca",
            category: .upper,
            primaryColorHex: "#FFFFFF",
            occasion: .casual,
            laundryStatus: .clean
        )
        let dirtyUpper = ClothingItem(
            name: "Remera Sucia",
            category: .upper,
            primaryColorHex: "#000000",
            occasion: .casual,
            laundryStatus: .dirty
        )
        let cleanLower = ClothingItem(
            name: "Jeans Negros",
            category: .lower,
            primaryColorHex: "#18181B",
            occasion: .casual,
            laundryStatus: .clean
        )
        let cleanFootwear = ClothingItem(
            name: "Zapatillas Blancas",
            category: .footwear,
            primaryColorHex: "#FFFFFF",
            occasion: .casual,
            laundryStatus: .clean
        )
        let cleanCoat = ClothingItem(
            name: "Campera Invierno",
            category: .outerwear,
            primaryColorHex: "#000000",
            occasion: .casual,
            laundryStatus: .clean
        )

        let allItems = [cleanUpper, dirtyUpper, cleanLower, cleanFootwear, cleanCoat]

        // Test 1: strictly filter clean items when onlyClean is true
        let outfitCleanOnly = OutfitEngine.generateOutfit(from: allItems, temperatureC: 20, onlyClean: true)
        assert(!outfitCleanOnly.contains(where: { $0.id == dirtyUpper.id }), "onlyClean filter excludes dirty items")

        // Test 2: include outerwear when temp < 18°C
        let coldOutfit = OutfitEngine.generateOutfit(from: allItems, temperatureC: 12, onlyClean: true)
        assert(coldOutfit.contains(where: { $0.category == .outerwear }), "Outerwear included when temperature < 18°C")

        // Test 3: exclude outerwear when temp >= 18°C
        let warmOutfit = OutfitEngine.generateOutfit(from: allItems, temperatureC: 25, onlyClean: true)
        assert(!warmOutfit.contains(where: { $0.category == .outerwear }), "Outerwear excluded when temperature >= 18°C")

        // Test 4: color harmony score for neutrals
        let scoreNeutrals = OutfitEngine.colorHarmonyScore(color1: "#FFFFFF", color2: "#000000")
        assert(scoreNeutrals == 10, "Neutral color score returns 10")

        // Test 5: color harmony score for un-trimmed / uppercase hex
        let scoreUppercase = OutfitEngine.colorHarmonyScore(color1: " #FFFFFF ", color2: "18181b")
        assert(scoreUppercase == 10, "Uppercase and trimmed hex score returns 10")

        return (passed, failed, logs)
    }
}
