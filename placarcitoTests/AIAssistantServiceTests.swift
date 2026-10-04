//
//  AIAssistantServiceTests.swift
//  placarcitoTests
//

import Foundation

public struct AIAssistantServiceTests {
    public static func runTests() -> (passed: Int, failed: Int, logs: [String]) {
        var passed = 0
        var failed = 0
        var logs: [String] = []

        func assert(_ condition: Bool, _ message: String) {
            if condition {
                passed += 1
                logs.append("  PASS: \(message)")
            } else {
                failed += 1
                logs.append("  FAIL: \(message)")
            }
        }

        logs.append("--- [Suite 3: AIAssistantServiceTests] ---")

        let service = AIAssistantService()

        // Test 1: Initial welcome message
        assert(service.messages.count == 1, "Initial message list contains 1 welcome message")
        assert(service.messages.first?.sender == .assistant, "First message sender is assistant")

        // Test 2: Sample items
        let upper = ClothingItem(name: "Camisa Trabajo", category: .upper, occasion: .work)
        let lower = ClothingItem(name: "Pantalón Trabajo", category: .lower, occasion: .work)
        let items = [upper, lower]

        // Test 3: Send message sets isGenerating true and appends user message
        service.sendMessage("Necesito un outfit para la oficina", availableItems: items, currentTemp: 22)
        assert(service.messages.count == 2, "User message appended immediately to messages")
        assert(service.isGenerating == true, "isGenerating is true while generating response")

        // Test 4: Pump RunLoop to wait for async completion (1.0s timer)
        let expectation = RunLoopWait()
        expectation.wait(seconds: 1.2)

        assert(service.isGenerating == false, "isGenerating becomes false after response generation completes")
        assert(service.messages.count == 3, "Assistant response appended to messages list")
        assert(service.messages.last?.sender == .assistant, "Generated message sender is assistant")
        assert(service.messages.last?.suggestedOutfitName == "Look Oficina Nordisk", "Work query generates 'Look Oficina Nordisk'")

        return (passed, failed, logs)
    }
}

private final class RunLoopWait {
    func wait(seconds: TimeInterval) {
        let start = Date()
        while Date().timeIntervalSince(start) < seconds {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.05))
        }
    }
}
