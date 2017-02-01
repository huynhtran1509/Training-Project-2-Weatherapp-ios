//
//  SettingsTableViewController.swift
//  Project2
//
//  Created by KFernandez on 1/26/17.
//  Copyright © 2017 KFernandez. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsTableViewController: UITableViewController, CLLocationManagerDelegate {

    // MARK: - Variables
    var temp: String?
    var userDefaults = UserDefaults.standard
    
    var latitude: String?
    var longitude: String?
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    // MARK: - Outlets
    @IBOutlet weak var temperatureControl: UISegmentedControl!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var locationTextField: UITextField!
    
    // MARK: - Actions
    @IBAction func indexControlChange(_ sender: UISegmentedControl) {
        switch temperatureControl.selectedSegmentIndex {
        case 0:
            temp = "metric"
            userDefaults.set("metric", forKey: "Temperature")
        case 1:
            temp = "imperial"
            userDefaults.set("imperial", forKey: "Temperature")
        default:
            break
        }
    }

    @IBAction func locationSwitchChange(_ sender: UISwitch) {
        locationTextField.isEnabled = !locationSwitch.isOn
        userDefaults.set(locationSwitch.isOn, forKey: "AutomaticLocation")
        
        if locationSwitch.isOn {
            // Disable the location text field
            locationManager.startUpdatingLocation()
        } else {
            // Enable the location text field
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func locationTextChange(_ sender: Any) {
        let location = locationTextField.text
        userDefaults.set(location, forKey: "Location")
    }
    
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Get user preferences
        locationTextField.text = userDefaults.string(forKey: "Location")
        
        if let temperatureFormat = userDefaults.string(forKey: "Temperature") {
            if temperatureFormat == "metric" {
                temperatureControl.selectedSegmentIndex = 0
            } else {
                temperatureControl.selectedSegmentIndex = 1
            }
        }
        
        if userDefaults.bool(forKey: "AutomaticLocation") {
            locationSwitch.isOn = true
            locationTextField.isEnabled = false
            
            // Get user location
            locationManager.startUpdatingLocation()
        } else {
            locationSwitch.isOn = false
        }
        
        locationTextField.addTarget(self, action: #selector(locationTextChange(_:)), for: .editingChanged)
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarStyles()
    }
    
    // MARK: - NavigationBar style
    func setNavigationBarStyles() {
        let backImage = UINavigationBar.appearance().backgroundImage(for: .default)
        navigationController?.navigationBar.setBackgroundImage(backImage, for: .default)
        navigationController?.navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
        navigationController?.navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        navigationController?.navigationBar.backgroundColor = UINavigationBar.appearance().backgroundColor
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        latitude = String(format: "%.4f", latestLocation.coordinate.latitude)
        userDefaults.set(latitude, forKey: "Latitude")
        longitude = String(format: "%.4f", latestLocation.coordinate.longitude)
        userDefaults.set(longitude, forKey: "Longitude")
    }
    
}
