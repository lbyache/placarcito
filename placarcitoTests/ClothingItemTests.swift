//
//  ClothingItemTests.swift
//  placarcitoTests
//

import Foundation

public struct ClothingItemTests {
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

        logs.append("--- [Suite 2: ClothingItemTests] ---")

        // Test 1: costPerWear with 0 wears returns full purchasePrice
        let itemZeroWears = ClothingItem(
            name: "Camisa Oxford",
            category: .upper,
            wearCount: 0,
            purchasePrice: 100.0
        )
        assert(itemZeroWears.costPerWear == 100.0, "costPerWear with 0 wears equals purchasePrice ($100.0)")

        // Test 2: costPerWear with 5 wears returns purchasePrice / 5
        let itemWorn = ClothingItem(
            name: "Jeans Slim",
            category: .lower,
            wearCount: 5,
            purchasePrice: 100.0
        )
        assert(itemWorn.costPerWear == 20.0, "costPerWear with 5 wears equals $20.0")

        // Test 3: LaundryStatus rawValue and icons
        let cleanItem = ClothingItem(name: "Test", category: .upper, laundryStatus: .clean)
        assert(cleanItem.laundryStatus.rawValue == "Limpio", "LaundryStatus clean rawValue is Limpio")
        assert(cleanItem.laundryStatus.icon == "checkmark.circle.fill", "Clean status icon is checkmark.circle.fill")

        // Test 4: LaundryStatus state mutations
        cleanItem.laundryStatus = .dirty
        assert(cleanItem.laundryStatusRaw == "Para Lavar", "laundryStatusRaw updates when laundryStatus enum is set")

        return (passed, failed, logs)
    }
}
