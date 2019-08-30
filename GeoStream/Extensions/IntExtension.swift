//
//  IntExtension.swift
//  Nod N Talk
//
//  Created by Zining Wang on 7/14/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//

import Foundation
public extension Int {
    var asWord: String {
        let numberValue = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter.string(from: numberValue)!
    }
}
