
import Foundation
import CoreLocation

class WeatherViewModel: NSObject {
    
    
    // MARK: - Properties
    var forecast: [Datum]?
    var data = Bindable([Datum]())
    var placeHolder = Bindable<String>("Enter the city".localized)
    var city = Bindable<String>("")
    let temp = Bindable<String>("")
    let desc = Bindable<String>("")
    let hum = Bindable<String>("")
    let windSpeed = Bindable<String>("")
    let pressure = Bindable<String>("")
    private var locationManager = CLLocationManager()
    var latitude: String = ""
    var longitude: String = ""
    var isLoading = Bindable<Bool>(false)
    
    
    // MARK: - Prime functions
    func getWeather(cityName: String) {
        let urlString = "\(Constants.url)\(Constants.language.localized)\(Constants.key)&city=\(cityName)"
        request(with: urlString)
    }
    
    func getWeatherCoord() {
        let urlString = "\(Constants.url)\(Constants.language.localized)\(Constants.key)&lat=\(String(latitude))&lon=\(String(longitude))"
        request(with: urlString)
    }
    
    private func request(with urlString: String) {
        isLoading.value = true
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    return
                }
                if let safeData = data {
                    if let weather =  self.parseJSON(safeData) {
                        self.updateWeather(weather: weather)
                        if let data = weather.data{
                            self.data.value = data
                            self.forecast = data
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ weatherData: Data) -> ForecastData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ForecastData.self, from: weatherData)
            return decodedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func updateWeather(weather: ForecastData){
        DispatchQueue.main.async {
            if let name = weather.cityName{
                self.city.value = "\(name)"
            }
            if let temperature = weather.data?[Constants.today].temp! {
                self.temp.value = "\(Int(temperature))"+"\(Constants.degreeСelsius)"
            }
            if let description = weather.data?[Constants.today].weather?.description {
                self.desc.value = "\(description)"
            }
            if let humidity = weather.data?[Constants.today].rh {
                self.hum.value = "\(humidity)\(Constants.percent)"
            }
            if let wind = weather.data?[Constants.today].windSpd {
                self.windSpeed.value = "\(Int(wind))\(Constants.metersPerSecond)"
            }
            if let pressure = weather.data?[Constants.today].pres {
                self.pressure.value = "\(Int(pressure))\(Constants.millibars)"
            }
            self.isLoading.value = false
        }
    }
}


// MARK: - Extensions
extension WeatherViewModel:CLLocationManagerDelegate {
    func configureLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = String(location.coordinate.latitude)
            longitude = String(location.coordinate.longitude)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

