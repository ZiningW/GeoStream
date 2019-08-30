//
//  LaunchScreenViewController.swift
//  GeoStream
//
//  Created by Zining Wang on 8/28/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//

import UIKit
import FirebaseUI

class LaunchScreenViewController: UIViewController{
  
    private var userName: String = "None"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.addBackground(imageName: "LaunchScreen")
        userName = Auth.auth().currentUser?.displayName ?? "None"
        
        if userName == "None"{
            showLogInController()
        } else {
            showMainController()
        }
    }
    
    private func showLogInController() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            fatalError("Cannot instantiate view controller")
        }
        show(vc, sender: self)
    }
    
    private func showMainController() {
        
        let vc = ContainerViewController()
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
