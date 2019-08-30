//
//  UIFont+MonospacedNumbers.swift
//  Nod N Talk
//
//  Created by Zining Wang on 3/28/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//

import UIKit

extension UIFont {
    
    /// Utility to return a copy of this font using monospaced numbers, if supported.
    var withMonospacedNumbers: UIFont {
        let originalFontDescriptor = self.fontDescriptor
        let fontDescriptorFeatureSettings = [
            [
                UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
            ]
        ]
        
        let fontDescriptorAttributes = [UIFontDescriptor.AttributeName.featureSettings: fontDescriptorFeatureSettings]
        let fontDescriptor = originalFontDescriptor.addingAttributes(fontDescriptorAttributes)
        
        return UIFont(descriptor: fontDescriptor, size: 0)
    }
}

extension UILabel {
    
    /// Utility to use a copy of the current font using monospaced numbers, if supported.
    func useMonospacedNumbers() {
        self.font = self.font.withMonospacedNumbers
    }
}

