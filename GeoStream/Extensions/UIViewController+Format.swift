//
//  UIViewController+Format.swift
//  Nod N Talk
//
//  Created by Zining Wang on 3/28/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Utility to format radians as degrees with two decimal places and a degree symbol.
    func format(radians: Double) -> String {
        let degrees = radians * 180 / Double.pi
        return String(format: "%.02f°", degrees)
    }
    
    /// Utility to format radians as degrees with two decimal places and a degree symbol.
    func format(radians: Float) -> String {
        let degrees = radians * 180 / Float.pi
        return String(format: "%.02f°", degrees)
    }
    
    /// Utility to format degrees with two decimal places and a degree symbol.
    func format(degrees: Double) -> String {
        return String(format: "%.02f°", degrees)
    }
    
    /// Utility to format a double with four decimal places.
    func format(decimal: Double) -> String {
        return String(format: "%.04f", decimal)
    }
    
    /// Converts the byte sequence of this Data object into a hexadecimal representation (two lowercase characters per byte).
    func format(data: Data?) -> String? {
        return data?.map({ String(format: "%02hhX", $0) }).joined()
    }
}
