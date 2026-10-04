//
//  VisionServiceTests.swift
//  placarcitoTests
//

import Foundation
import UIKit

public struct VisionServiceTests {
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

        logs.append("--- [Suite 4: VisionServiceTests] ---")

        // Create dummy test image
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let sampleImage = renderer.image { ctx in
            UIColor.red.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }

        // Test 1: Image has valid cgImage
        assert(sampleImage.cgImage != nil, "Sample UIImage has valid cgImage reference")

        // Test 2: VisionService background removal completes & dispatches safely (handling ML context & fallback)
        let expectation = RunLoopSemaphore()
        var resultImage: UIImage? = nil

        VisionService.removeBackground(from: sampleImage) { processed in
            resultImage = processed
            expectation.signal()
        }

        let didFinish = expectation.wait(timeout: 3.0)
        assert(didFinish, "VisionService.removeBackground completes within timeout")
        assert(resultImage != nil, "VisionService returns non-nil processed image (either isolated object or original fallback)")

        return (passed, failed, logs)
    }
}

private final class RunLoopSemaphore {
    private var isSignaled = false

    func signal() {
        isSignaled = true
    }

    func wait(timeout: TimeInterval) -> Bool {
        let start = Date()
        while Date().timeIntervalSince(start) < timeout {
            if isSignaled { return true }
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.05))
        }
        return isSignaled
    }
}
