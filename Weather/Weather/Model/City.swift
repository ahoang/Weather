//
//  City.swift
//  Weather
//
//  Created by Anthony Hoang on 10/12/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import Foundation
import CoreLocation

struct City: Codable {
    let coordinates: Coordinate
    let name: String
    var currentWeather: Weather?
    var forecast: [Weather]?

    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case currentWeather = "main"
        case forecast = "list"

        case name
    }
}

struct Coordinate: Codable{
    let longitude: Double
    let latitude: Double

    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
