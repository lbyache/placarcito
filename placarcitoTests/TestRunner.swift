//
//  TestRunner.swift
//  placarcitoTests
//

import Foundation

@main
struct TestRunner {
    static func main() {
        print("==================================================")
        print("🚀 RUNNING PLACARCITO SUITE DE PRUEBAS AUTOMATIZADA")
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
        print("📊 RESUMEN FINAL DE EJECUCIÓN DE PRUEBAS")
        print("  - Total Pruebas Pasadas: \(totalPassed) ✅")
        print("  - Total Pruebas Fallidas: \(totalFailed) ❌")
        print("==================================================")

        if totalFailed > 0 {
            exit(1)
        } else {
            exit(0)
        }
    }
}
