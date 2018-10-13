//
//  WeatherService.swift
//  Weather
//
//  Created by Anthony Hoang on 10/12/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import Foundation

enum WeatherService {

    static func getCurrentWeather(lat: Double, long: Double, success: ((City) -> Void)? = nil, error: ((Error) -> Void)? = nil) {
        request(endPoint: "weather", queryItems: createParams(lat: lat, long: long), success: success, fail: error)
    }

    static func getForecast(lat: Double, long: Double, success: ((City) -> Void)? = nil, error: ((Error) -> Void)? = nil) {
        request(endPoint: "forcast", queryItems: createParams(lat: lat, long: long), success: success, fail: error)
    }

    private static func createParams(lat: Double, long: Double) -> [URLQueryItem] {
        return [URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(long)")]
    }

    private static func request<T: Codable>(endPoint: String, queryItems: [URLQueryItem] = [], success: ((T) -> Void)?, fail: ((Error) -> Void)?) {
        var urlComp = URLComponents(string: Constants.BaseUrl + endPoint)
        urlComp?.queryItems = queryItems + [Constants.APIKey]

        guard let url = urlComp?.url else {
            fail?(Constants.GenericError)
            return
        }

        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let object = try? JSONDecoder().decode(T.self, from: data) {
                success?(object)
            } else {
                fail?(error ?? Constants.GenericError)
            }
            }.resume()
    }

    enum Constants {
        static let BaseUrl = "http://api.openweathermap.org/data/2.5/"
        static let APIKey = URLQueryItem(name: "appid", value: "c6e381d8c7ff98f0fee43775817cf6ad")
        static let GenericError = NSError(domain: "com.weather.GenericError", code: 0, userInfo: nil)
    }
}
