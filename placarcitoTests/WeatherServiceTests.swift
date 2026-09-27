//
//  WeatherServiceTests.swift
//  placarcitoTests
//

import Foundation

public struct WeatherServiceTests {
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

        logs.append("--- [Suite 6: WeatherServiceTests] ---")

        let weatherService = WeatherService()

        // Test 1: Cold temperature condition < 12°C
        weatherService.updateTemperature(8)
        assert(weatherService.currentWeather.condition == "Frío Intenso", "Temp 8°C produces 'Frío Intenso'")
        assert(weatherService.currentWeather.iconName == "snowflake", "Temp 8°C icon is 'snowflake'")

        // Test 2: Mild temperature condition 12-17°C
        weatherService.updateTemperature(15)
        assert(weatherService.currentWeather.condition == "Fresco / Templado", "Temp 15°C produces 'Fresco / Templado'")

        // Test 3: Pleasant temperature 18-25°C
        weatherService.updateTemperature(22)
        assert(weatherService.currentWeather.condition == "Agradable", "Temp 22°C produces 'Agradable'")

        // Test 4: Warm temperature >= 26°C
        weatherService.updateTemperature(30)
        assert(weatherService.currentWeather.condition == "Cálido / Sol", "Temp 30°C produces 'Cálido / Sol'")

        return (passed, failed, logs)
    }
}
