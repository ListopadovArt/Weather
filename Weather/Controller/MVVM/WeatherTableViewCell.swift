
import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabelCell: UILabel!
    @IBOutlet weak var imageWeatherCell: UIImageView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dayLabelCell.text = nil
        self.imageWeatherCell.image = nil
    }
    
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
    
    func configure(with object: Datum) {
        let formatterGet = DateFormatter()
        formatterGet.dateFormat = Constants.formatReceivedDateCell
        let formatterPrint = DateFormatter()
        formatterPrint.dateFormat = Constants.formatDisplayedDateCell
        let date = Date(timeIntervalSince1970: TimeInterval(object.ts! as Int))
        self.dayLabelCell.text = formatterPrint.string(from: date)
        self.imageWeatherCell.image = UIImage(named: object.weather?.icon ?? "")
        if let temp = object.maxTemp{
            self.tempMaxLabel.text = "\(Int(temp))"+"\(Constants.degreeСelsius)"
        }
        if let temp = object.minTemp {
            self.tempMinLabel.text = "\(Int(temp))"+"\(Constants.degreeСelsius)"
        }
    }
}
