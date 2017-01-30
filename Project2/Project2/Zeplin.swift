//
//  Zeplin.swift
//  Project2
//
//  Created by KFernandez on 1/26/17.
//  Copyright © 2017 KFernandez. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var it2RobinEggBlue: UIColor {
        return UIColor(red: 129.0 / 255.0, green: 243.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0)
    }

    class var it2DodgerBlue: UIColor {
        return UIColor(red: 58.0 / 255.0, green: 155.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
    }
}

// Sample text styles
extension UIFont {
    class func it2HeaderFont() -> UIFont {
        return UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightRegular)
    }
}
