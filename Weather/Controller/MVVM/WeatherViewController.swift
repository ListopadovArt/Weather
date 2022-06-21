
import UIKit


class WeatherViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var imageId: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageWind: UIImageView!
    @IBOutlet weak var imageHum: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var pressureImage: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var buttonLocations: UIButton!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView! {
        didSet {
            loadingView.layer.cornerRadius = 6
        }
    }
    
    
    // MARK: - Private Properties
    private let model = WeatherViewModel()
    
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.configureLocationManager()
        guard let city = UserDefaults.standard.value(forKey: "city") as? String else { return }
        bindViewModel()
        loadWeather()
        model.getWeather(cityName: city)
        reloadTableView()
    }
    
    
    // MARK: - Prime functions
    private func bindViewModel(){
        model.placeHolder.bind { [weak self] value in
            self?.cityTextField.placeholder = value
            self?.imageHum.image = UIImage(named: "humidity")
            self?.imageWind.image = UIImage(named: "wind")
            self?.imageId.image = UIImage(named: "temperature")
            self?.pressureImage.image = UIImage(named: "pressure")
        }
    }
    
    private func loadWeather() {
        model.city.bind { [weak self] value in
            self?.cityLabel.text = value
        }
        model.temp.bind { [weak self] value in
            self?.tempLabel.text = value
        }
        model.desc.bind { [weak self] value in
            self?.descLabel.text = value
        }
        model.hum.bind { [weak self] value in
            self?.humLabel.text = value
        }
        model.windSpeed.bind { [weak self] value in
            self?.windSpeedLabel.text = value
        }
        model.pressure.bind { [weak self] value in
            self?.pressureLabel.text = value
        }
    }
    
    private func reloadTableView(){
        self.model.data.bind { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.model.isLoading.value {
                    self.showSpinner()
                } else {
                    self.hideSpinner()
                }
            }
        }
    }
    
    
    // MARK: - Spiner functions
    private func showSpinner() {
        spiner.startAnimating()
        loadingView.isHidden = false
    }
    
    private func hideSpinner() {
        spiner.stopAnimating()
        loadingView.isHidden = true
    }
    
    
    // MARK: - IBActions
    @IBAction func navigationButtonPressed(_ sender: UIButton) {
        model.getWeatherCoord()
        bindViewModel()
        loadWeather()
        reloadTableView()
    }
}


// MARK: - Extensions
extension WeatherViewController: UITextFieldDelegate  {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Enter the name of the city".localized
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let name = cityTextField.text?.replacingOccurrences(of: " ", with: "") {
            UserDefaults.standard.set(name, forKey: "city")
            bindViewModel()
            loadWeather()
            model.getWeather(cityName: name)
            cityTextField.text = ""
            reloadTableView()
        }
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.forecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.weatherTableViewCell, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: (model.forecast?[indexPath.row])!)
        return cell
    }
}
