//
//  UIDatePickerExtension.swift
//  LifeMode
//
//  Created by Pogosian on 5/8/21.
//

import UIKit

extension UIDatePicker {

var textColor: UIColor? {
    set {
        setValue(newValue, forKeyPath: "textColor")
    }
    get {
        return value(forKeyPath: "textColor") as? UIColor
    }
  }
}
