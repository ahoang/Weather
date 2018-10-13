//
//  Weather.swift
//  Weather
//
//  Created by Anthony Hoang on 10/12/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let temp: Double
    let humidity: Double
    let pressure: Double
    let minTemp: Double
    let maxTemp: Double

    enum CodingKeys: String, CodingKey {
        case minTemp = "temp_min"
        case maxTemp = "temp_max"

        case temp
        case humidity
        case pressure
    }
}

