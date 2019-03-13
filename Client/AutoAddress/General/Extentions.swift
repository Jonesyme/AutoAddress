//
//  Extentions.swift
//  AutoAddress
//
//  Created by Mike Jones on 3/13/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import Foundation
import UIKit


// MARK - UISearchBar textColor
extension UISearchBar {
    var textColor:UIColor? {
        get {
            let textField = self.value(forKey: "searchField") as? UITextField
            return textField?.textColor
        }
        set (newValue) {
            let textField = self.value(forKey: "searchField") as? UITextField
            textField?.textColor = newValue
        }
    }
}
