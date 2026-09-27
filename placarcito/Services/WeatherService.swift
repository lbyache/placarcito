//
//  WeatherService.swift
//  placarcito
//

import Foundation
import SwiftUI
import Observation

@Observable
public final class WeatherService {
    public var currentWeather: WeatherInfo = WeatherInfo()
    
    public init() {}
    
    public func updateTemperature(_ temp: Int) {
        var updated = currentWeather
        updated.temperatureC = temp
        if temp < 12 {
            updated.condition = "Frío Intenso"
            updated.iconName = "snowflake"
        } else if temp < 18 {
            updated.condition = "Fresco / Templado"
            updated.iconName = "cloud.sun.fill"
        } else if temp < 26 {
            updated.condition = "Agradable"
            updated.iconName = "sun.max.fill"
        } else {
            updated.condition = "Cálido / Sol"
            updated.iconName = "sun.max.fill"
        }
        self.currentWeather = updated
    }
}
