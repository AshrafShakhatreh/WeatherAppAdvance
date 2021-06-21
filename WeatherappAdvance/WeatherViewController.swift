//
//  ViewController.swift
//  WeatherappAdvance
//
//  Created by Admin on 21/06/2021.
//  Copyright © 2021 Ashraf. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {

    @IBOutlet var CondtionImage: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var TempretuerLabel: UILabel!
    @IBOutlet var serachTextFiled: UITextField!
   let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    override func viewDidLoad() {
        super.viewDidLoad()
      manageDelegatesAndAuthristion()
    }
    func manageDelegatesAndAuthristion(){
     
            locationManager.delegate = self
             locationManager.requestWhenInUseAuthorization()
             locationManager.requestLocation()
              weatherManager.delegate = self
              serachTextFiled.delegate = self
    }


}
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        serachTextFiled.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        serachTextFiled.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = serachTextFiled.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        serachTextFiled.text = ""
        
    }
}
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.TempretuerLabel.text = weather.temperatureString
            self.CondtionImage.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

