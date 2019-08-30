//
//  MapAnnotationFormating.swift
//  GeoStream
//
//  Created by Zining Wang on 8/28/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//

import UIKit
import MapKit

class GlowingAnnotation: MKAnnotationView {
    @IBInspectable var animDuration : CGFloat = 3
    @IBInspectable var cornerRadius : CGFloat = 5
    @IBInspectable var maxGlowSize : CGFloat = 10
    @IBInspectable var minGlowSize : CGFloat = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentScaleFactor = UIScreen.main.scale
        layer.masksToBounds = false
        setupButton()
        startAnimation()
    }
    
    func setupButton(){
        layer.backgroundColor = nil
        layer.borderWidth   = 0
        layer.shadowColor = Colors.evilBlue.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = maxGlowSize
        layer.shadowOpacity = 1
        clipsToBounds       = true
        layer.masksToBounds = false
        
        startAnimation()
        
    }
    
    func startAnimation() {
        
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = maxGlowSize
        layerAnimation.toValue = minGlowSize
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = CFTimeInterval(animDuration/2)
        layerAnimation.fillMode = CAMediaTimingFillMode.forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        self.layer.add(layerAnimation, forKey: "glowingAnimation")
        
    }
}
