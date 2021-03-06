//
//  Utilities.swift
//  Kagami
//
//  Created by Eric Chang on 3/1/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation
import UIKit

struct ColorPalette {
    static let blackColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
    static let whiteColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
    static let grayColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
    static let accentColor = UIColor(red:0.76, green:0.83, blue:0.90, alpha:1.0)
}

// Widget protocol
protocol Widgetable: class {
    var category: String { get }
    var iconImage: UIImage { get }
    var description: String { get }
}
