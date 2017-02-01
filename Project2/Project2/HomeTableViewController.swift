//
//  HomeTableViewController.swift
//  Project2
//
//  Created by KFernandez on 1/26/17.
//  Copyright © 2017 KFernandez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Variables
    var gradientLayer: CAGradientLayer?
    var titleT: UILabel!
    var subtitleT: UILabel!
    var titleViewWeather = ""
    let actualDayViewCell = "todayViewCell"
    let weekViewCell = "weekViewCell"
    
    let userDefaults = UserDefaults.standard
    var locationSelected = false
    
    let appi = "http://api.openweathermap.org/data/2.5/forecast/daily?"
    let key = "9b266f76f2e50ffa3c2f481451954376"
    var country = "Montevideo"
    var units = "metric"
    let cantDays = "16"
    
    var latitude = "32.5228"
    var longitude = "-122.4064"
    
    var allTheDays = [DayForecast]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientView: UIView!
    
    // MARK: - Load View
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarStyles()
        view.backgroundColor = .it2DodgerBlue
        
        getAPIData()
        navigationItem.titleView = setTitle(title: titleViewWeather, subtitle: country)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if gradientLayer == nil {
            let layer = CAGradientLayer()
            layer.colors = [UIColor.it2DodgerBlue.cgColor, UIColor.it2RobinEggBlue.cgColor]
            layer.frame = gradientView.bounds
            gradientView.layer.addSublayer(layer)
        }
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTheDays.count
    }

    // MARK: - TableView functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.row == 0 ? actualDayViewCell : weekViewCell, for: indexPath) as? WeekDayTableViewCell ?? WeekDayTableViewCell()
        let dayInfo = allTheDays[indexPath.row]
        
        if indexPath.row == 0 {
            cell.configureCurrentDay(with: dayInfo)
            titleViewWeather = dayInfo.generalDefinition
        } else {
            cell.configure(with: dayInfo)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.backgroundColor = .clear
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 201
        } else {
            return 72
        }
    }
    
    // MARK: - Set title
    func setTitle(title: String, subtitle: String) -> UIView {
        titleT = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        titleT.backgroundColor = UIColor.clear
        titleT.textColor = UIColor.white
        titleT.font = UIFont.boldSystemFont(ofSize: 17)
        titleT.text = title
        titleT.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.font = UIFont.systemFont(ofSize: 11)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleT.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleT)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleT.frame.size.width
        
        if widthDiff > 0 {
            var frame = titleT.frame
            frame.origin.x = widthDiff / 2
            titleT.frame = frame.integral
        } else {
            var frame = subtitleLabel.frame
            frame.origin.x = abs(widthDiff) / 2
            titleT.frame = frame.integral
        }
        
        return titleView
    }
    
    // MARK: - NavigationBar style
    func setNavigationBarStyles() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .it2DodgerBlue
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    // MARK: - Get API's data
    // http://api.openweathermap.org/data/2.5/forecast/daily?q=Montevideon&APPID=9b266f76f2e50ffa3c2f481451954376&cnt=16&units=metric
    func getAPIData () {
        readingUserPreferences()
        var parameters: Parameters = ["APPID" : key, "cnt": cantDays, "units" : units]

        // If location is ON
        if locationSelected {
            parameters["lat"] = latitude
            parameters["lon"] = longitude
        } else {
            parameters["q"] = country
        }
        Alamofire.request(appi, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if let days = json["list"].array {
                    let cantDays = days.count
                    
                    // New array to add the data
                    var theDays = [DayForecast]()
                    
                    for index in 0...cantDays-1 {
                        
                        let day1970 = days[index]["dt"]
                        let day: Double = day1970.double!
                        let date = Date(timeIntervalSince1970: day)
                        
                        let actual = days[index]["temp"]["day"].intValue
                        let min = days[index]["temp"]["min"].intValue
                        let max = days[index]["temp"]["max"].intValue
                        let description = days[index]["weather"][0]["main"].string
                        
                        let dayForescast = DayForecast(day: date, actualTemp: actual, min: min, max: max, generalDefinition: description!)
                        theDays.append(dayForescast)
                    }
                    self.allTheDays = theDays
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Reading user data preferences
    func readingUserPreferences() {
        if let temperatureFormat = userDefaults.string(forKey: "Temperature") {
            units = temperatureFormat
        }
        if let location = userDefaults.string(forKey: "Location") {
            country = location
        }
        
        locationSelected = userDefaults.bool(forKey: "AutomaticLocation")
        if userDefaults.bool(forKey: "AutomaticLocation") {
            if let lat = userDefaults.string(forKey: "Latitude") {
                latitude = lat
            }
            if let lon = userDefaults.string(forKey: "Longitude") {
                longitude = lon
            }
            
            country = ""
        }
    }
    
}
