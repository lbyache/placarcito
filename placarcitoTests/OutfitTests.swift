//
//  OutfitTests.swift
//  placarcitoTests
//

import Foundation

public struct OutfitTests {
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

        logs.append("--- [Suite 5: OutfitTests] ---")

        let cleanItem1 = ClothingItem(name: "Remera Blanca", category: .upper, laundryStatus: .clean)
        let cleanItem2 = ClothingItem(name: "Jeans Negros", category: .lower, laundryStatus: .clean)
        let dirtyItem = ClothingItem(name: "Camisa Azul", category: .upper, laundryStatus: .dirty)

        // Test 1: Outfit isAvailableToWear when all items are clean
        let cleanOutfit = Outfit(
            name: "Look Limpio",
            items: [cleanItem1, cleanItem2]
        )
        assert(cleanOutfit.isAvailableToWear == true, "Outfit isAvailableToWear returns true when all items clean")

        // Test 2: Outfit isAvailableToWear is false if any item is dirty
        let dirtyOutfit = Outfit(
            name: "Look Mixto",
            items: [cleanItem1, dirtyItem]
        )
        assert(dirtyOutfit.isAvailableToWear == false, "Outfit isAvailableToWear returns false when dirty item present")

        // Test 3: Outfit temperature bounds initial values
        let outfitTemp = Outfit(name: "Look Invierno", minTemp: 5, maxTemp: 15)
        assert(outfitTemp.minTemp == 5 && outfitTemp.maxTemp == 15, "Outfit stores minTemp and maxTemp correctly")

        return (passed, failed, logs)
    }
}
