//
//  customCallButton.swift
//  Nod N Talk
//
//  Created by Zining Wang on 6/21/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//

import UIKit

class CustomCallButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton(){
        
        backgroundColor       = Colors.evilBlue
        titleLabel?.font      = UIFont(name: "AvenirNext-DemiBold", size: 18)
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius    = 10
        layer.borderWidth     = 3.0
        layer.borderColor     = Colors.borderGray.cgColor
    }
    
    func setupButton(channel: String) {
        setShadow()
        setTitle("Join \(channel)", for: .normal)
        backgroundColor       = Colors.evilBlue
        titleLabel?.font      = UIFont(name: "AvenirNext-DemiBold", size: 18)
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius    = 10
        layer.borderWidth     = 3.0
        layer.borderColor     = Colors.borderGray.cgColor
        
    }
    
    func loadingButton(channel: String){
        setShadow()
        setTitle(channel, for: .normal)
        backgroundColor       = Colors.evilBlue
        titleLabel?.font      = UIFont(name: "AvenirNext-DemiBold", size: 18)
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius    = 10
        layer.borderWidth     = 3.0
        layer.borderColor     = Colors.borderGray.cgColor
    }
    
    func setLeaveCall(){
        setShadow()
        setTitle("Leave Call", for: .normal)
        backgroundColor       = Colors.deepRedButton
        titleLabel?.font      = UIFont(name: "AvenirNext-DemiBold", size: 18)
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius    = 10
        layer.borderWidth     = 3.0
        layer.borderColor     = Colors.borderGray.cgColor
    }
    
    func setLeaveChannel(channel: String){
        setShadow()
        setTitle("Leave \(channel)", for: .normal)
        backgroundColor       = Colors.deepRedButton
        titleLabel?.font      = UIFont(name: "AvenirNext-DemiBold", size: 18)
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius    = 10
        layer.borderWidth     = 3.0
        layer.borderColor     = Colors.borderGray.cgColor
    }
    
    
    private func setShadow() {
        layer.shadowColor    = UIColor.black.cgColor
        layer.shadowOffset   = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius   = 8
        layer.shadowOpacity  = 0.5
        clipsToBounds        = true
        layer.masksToBounds  = false
    }
    
    func inCall(){
        setTitle("Cancel Call", for: .normal)
        backgroundColor         = UIColor.red
    }
    
    func cancelledCall(){
        setTitle("Call", for: .normal)
        backgroundColor         = Colors.fadedEvilBlue
    }
    
    func shake() {
        let shake            = CABasicAnimation(keyPath: "position")
        shake.duration       = 0.1
        shake.repeatCount    = 2
        shake.autoreverses   = true
        
        let fromPoint        = CGPoint(x: center.x - 8, y: center.y)
        let fromValue        = NSValue(cgPoint: fromPoint)
        
        let toPoint          = CGPoint(x: center.x + 8, y: center.y)
        let toValue          = NSValue(cgPoint: toPoint)
        
        shake.fromValue      = fromValue
        shake.toValue        = toValue
        
        layer.add(shake, forKey: "position")
    }
}


class GroupLabel: UILabel{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    func setupLabel() {
        setShadow()
        font = UIFont(name: Fonts.helveticaLight, size: 20)
        textColor = UIColor.black
    }
    private func setShadow() {
        layer.backgroundColor = Colors.fadedDepressionGray.cgColor
        layer.shadowColor    = UIColor.black.cgColor
        layer.shadowOffset   = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius   = 8
        layer.shadowOpacity  = 0.5
        clipsToBounds        = true
        layer.masksToBounds  = false
    }
    
    func callingUser(){
        textColor = Colors.rottenOrange
    }
    
    func inCall(){
        textColor = Colors.nauseaGreen
    }
}

class CustomStatusButton: UIButton {
    var oldText: String?
    var oldColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton(){
        
        backgroundColor       = Colors.fadedDepressionGray
        titleLabel?.font      = UIFont(name: "AvenirNext-DemiBold", size: 14)
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius    = 10
        layer.borderWidth     = 3.0
        layer.borderColor     = Colors.borderGray.cgColor
    }
    
    func setupButton(text: String) {
        setShadow()
        oldText = text
        oldColor = Colors.fadedEvilBlue
        setTitle(text, for: .normal)
        backgroundColor       = Colors.fadedEvilBlue
        titleLabel?.font      = UIFont(name: "AvenirNext-DemiBold", size: 18)
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius    = 10
        layer.borderWidth     = 3.0
        layer.borderColor     = Colors.borderGray.cgColor
        
    }
    
    private func setShadow() {
        layer.backgroundColor = Colors.fadedDepressionGray.cgColor
        layer.shadowColor    = UIColor.black.cgColor
        layer.shadowOffset   = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius   = 8
        layer.shadowOpacity  = 0.5
        clipsToBounds        = true
        layer.masksToBounds  = false
    }
    
    func pressed(){
        setTitle("Turn Off Group View", for: .normal)
        titleLabel?.font      = UIFont(name: "AvenirNext-DemiBold", size: 16)
        setTitleColor(UIColor.red, for: .normal)
        layer.shadowRadius   = 20
        layer.shadowOpacity  = 1
    }
    
    func unpressed(){
        setTitle(oldText, for: .normal)
        backgroundColor = oldColor
        layer.removeAllAnimations()
        titleLabel?.font      = UIFont(name: "AvenirNext-DemiBold", size: 18)
        setTitleColor(UIColor.white, for: .normal)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius   = 8
        layer.shadowOpacity  = 0.5
    }
    
    
    func glowingButton(color: CGColor){
        layer.backgroundColor = nil
        layer.borderWidth   = 0
        layer.shadowColor = color
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 15
        layer.shadowOpacity = 1
        clipsToBounds       = true
        layer.masksToBounds = false
        
        startAnimation()
    }
    
    private func startAnimation() {
        
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = 15
        layerAnimation.toValue = 0
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = CFTimeInterval(1/2)
        layerAnimation.fillMode = CAMediaTimingFillMode.forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        self.layer.add(layerAnimation, forKey: "glowingAnimation")
        
    }
    
}

class sensorLabels: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    func setupLabel() {
        textColor = Colors.sadGray
    }
}
