//
//  WeekDayTableViewCell.swift
//  Project2
//
//  Created by KFernandez on 1/27/17.
//  Copyright © 2017 KFernandez. All rights reserved.
//

import UIKit

class WeekDayTableViewCell: UITableViewCell {
    
    let dateFormatter = DateFormatter()
    
    // MARK: Outlets
    @IBOutlet weak var dayImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!  // Number of the day
    @IBOutlet weak var weatherLabel: UILabel! // Rain / Snow
    @IBOutlet weak var actualTempLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!  // Min - Max
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset existing data
        dayImage?.image = nil
        weatherLabel?.text = nil
        actualTempLabel?.text = nil
        dayTempLabel?.text = nil
    }
    
    // MARK: Set image to week cells
    func configure(with dayForescast: DayForecast) {
        configuration(with: dayForescast)
        if dayForescast.generalDefinition == "Rain" {
            dayImage.image = UIImage(named: "icRain")
        } else if dayForescast.generalDefinition == "Clear" {
            dayImage.image = UIImage(named: "icClear")
        } else if dayForescast.generalDefinition == "Clouds" {
            dayImage.image = UIImage(named: "icCloudy")
        } else if dayForescast.generalDefinition == "Storm" {
            dayImage.image = UIImage(named: "icStorm")
        } else {
            dayImage.image = UIImage(named: "icFog")
        }
    }
    
    // MARK: Set image to current day cell
    func configureCurrentDay(with dayForescast: DayForecast) {
        configuration(with: dayForescast)
        if dayForescast.generalDefinition == "Rain" {
            dayImage.image = UIImage(named: "artRain")
        } else if dayForescast.generalDefinition == "Clear" {
            dayImage.image = UIImage(named: "artClear")
        } else if dayForescast.generalDefinition == "Clouds" {
            dayImage.image = UIImage(named: "artClouds")
        } else if dayForescast.generalDefinition == "Storm" {
            dayImage.image = UIImage(named: "artStorm")
        } else {
            dayImage.image = UIImage(named: "artFog")
        }
    }
    
    // MARK: Update UI both type of cells
    func configuration (with dayForescast: DayForecast) {
        weatherLabel?.text = dayForescast.generalDefinition
        actualTempLabel?.text = "\(dayForescast.actualTemp.description)°"
        dayTempLabel?.text = "\(dayForescast.min.description)° / \(dayForescast.max.description)°"
        dayLabel?.text = dateFormatter.string(from: dayForescast.day)
    }

}
