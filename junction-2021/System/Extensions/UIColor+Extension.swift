//
//  UIColor+Extension.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//

import UIKit

extension UIColor {
	// #f2f5f8
	class func appBackground() -> UIColor {
		return UIColor(red: 242.0 / 255.0, green: 245.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
	}
	
	// #3A3A3C
	class func appBackgroundDark() -> UIColor {
		return UIColor(red: 58.0 / 255.0, green: 58.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
	}
	
	class func appModal() -> UIColor {
		return .white
	}
	
	class func appText() -> UIColor {
		return .black
	}
	
	// #C7C7CC
	class func appModalSub() -> UIColor {
		return UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
	}
	
	// #FF9500
	class func appAcentOrange() -> UIColor {
		return UIColor(red: 255.0 / 255.0, green: 149.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
	}
	
	// #5AC8FA
	class func appAcentBlue() -> UIColor {
		return UIColor(red: 90.0 / 255.0, green: 200.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
	}

    class func shadow() -> UIColor {
        return UIColor(red: 129.0 / 255.0, green: 135.0 / 255.0, blue: 189.0 / 255.0, alpha: 0.14)
    }
}
