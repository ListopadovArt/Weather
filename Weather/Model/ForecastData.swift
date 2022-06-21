
import Foundation


// MARK: - ForecastData
struct ForecastData: Codable {
    let data: [Datum]?
    let cityName: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case cityName = "city_name"
    }
}


// MARK: - Datum
struct Datum: Codable {
    let rh: Int?
    let pres: Double?
    let ts: Int?
    let windSpd: Double?
    let weather: Weather?
    let maxTemp: Double?
    let minTemp: Double?
    let temp: Double?
    
    enum CodingKeys: String, CodingKey {
        case rh, pres
        case ts
        case windSpd = "wind_spd"
        case weather
        case maxTemp = "max_temp"
        case temp
        case minTemp = "min_temp"
    }
}


// MARK: - Weather
struct Weather: Codable {
    let icon: String?
    let code: Int?
    let description: String?
}


