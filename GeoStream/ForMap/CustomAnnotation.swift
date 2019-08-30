//
//  annotationHelper.swift
//  Nod N Talk
//
//  Created by Zining Wang on 6/20/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//

import MapKit

class CustomAnnotation: MKPointAnnotation {
    
    var uid: String?
    var image: UIImage?
    var identifier: String?
    var annotationView: MKAnnotationView?
    var streaming: String?
    var streamChannelID: String?
    var streamToken: String?
    
    override init() {
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    func glowingAnnotation(color: CGColor){
        
        self.annotationView?.layer.backgroundColor = nil
        self.annotationView?.layer.borderWidth = 0
        self.annotationView?.layer.shadowColor = color
        self.annotationView?.layer.shadowOffset = CGSize.zero
        self.annotationView?.layer.shadowRadius = 5
        self.annotationView?.layer.shadowOpacity = 1
        self.annotationView?.clipsToBounds = true
        self.annotationView?.layer.masksToBounds = false
        setAnimation(annotation: self.annotationView!)
    }
    
    func statusGlow(color: CGColor){
        self.annotationView?.layer.backgroundColor = nil
        self.annotationView?.layer.borderWidth = 0
        self.annotationView?.layer.shadowColor = color
        self.annotationView?.layer.shadowOffset = CGSize.zero
        self.annotationView?.layer.shadowRadius = 10
        self.annotationView?.layer.shadowOpacity = 1
        self.annotationView?.clipsToBounds = true
        self.annotationView?.layer.masksToBounds = false
        setStatusAnimation(annotation: self.annotationView!)
    }
    
    func removeGlow(){
        self.annotationView?.layer.removeAllAnimations()
        self.annotationView?.layer.shadowColor = UIColor.clear.cgColor
    }
    
    private func setStatusAnimation(annotation: MKAnnotationView){
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = 10
        layerAnimation.toValue = 2
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = CFTimeInterval(1/2)
        layerAnimation.fillMode = CAMediaTimingFillMode.forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        annotation.layer.add(layerAnimation, forKey: "glowingAnimation")
    }
    
    private func setAnimation(annotation: MKAnnotationView){
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = 5
        layerAnimation.toValue = 2
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = CFTimeInterval(3/2)
        layerAnimation.fillMode = CAMediaTimingFillMode.forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        annotation.layer.add(layerAnimation, forKey: "glowingAnimation")
    }
    
    func addAnnotationImage(imageName: String){
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named :"video")?.withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        rightButton.imageView?.contentMode = .scaleAspectFit
        
        let pinImage = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        self.annotationView!.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.annotationView!.image = resizedImage
        self.annotationView!.rightCalloutAccessoryView = rightButton
        self.annotationView!.canShowCallout = true
    }
    
    func addAnnotationStreamImage(imageName: String){
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named :"video")?.withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        rightButton.imageView?.contentMode = .scaleAspectFit
        
//        let leftButton = UIButton()
//        leftButton.setImage(UIImage(named :"video")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        leftButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        leftButton.imageView?.contentMode = .scaleAspectFit
        
        let pinImage = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        self.annotationView!.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.annotationView!.image = resizedImage
        self.annotationView!.rightCalloutAccessoryView = rightButton
//        self.annotationView!.leftCalloutAccessoryView = leftButton
        self.annotationView!.canShowCallout = true
    }
    
    func addSelfAnnotationImage(imageName: String){
        let pinImage = UIImage(named: imageName)
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        self.annotationView!.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.annotationView!.image = resizedImage
    }
    
    func addSelfHeadingAnnotationImage(imageName: String){
        let pinImage = UIImage(named: imageName)
        let size = CGSize(width: 250, height: 250)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        self.annotationView!.image = resizedImage
    }
}

