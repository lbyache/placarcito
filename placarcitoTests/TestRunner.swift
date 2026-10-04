//
//  TestRunner.swift
//  placarcitoTests
//

import Foundation

@main
struct TestRunner {
    static func main() {
        print("==================================================")
        print("Suite de pruebas unitarias: placarcito")
        print("==================================================")

        var totalPassed = 0
        var totalFailed = 0

        let suites: [() -> (passed: Int, failed: Int, logs: [String])] = [
            OutfitEngineTests.runTests,
            ClothingItemTests.runTests,
            AIAssistantServiceTests.runTests,
            VisionServiceTests.runTests,
            OutfitTests.runTests,
            WeatherServiceTests.runTests
        ]

        for suite in suites {
            let res = suite()
            totalPassed += res.passed
            totalFailed += res.failed
            for log in res.logs {
                print(log)
            }
            print("")
        }

        print("==================================================")
        print("Resumen de ejecucion:")
        print("  - Pruebas superadas: \(totalPassed)")
        print("  - Pruebas fallidas:  \(totalFailed)")
        print("==================================================")

        if totalFailed > 0 {
            exit(1)
        } else {
            exit(0)
        }
    }
}
