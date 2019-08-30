//
//  ViewController.swift
//  GeoStream
//
//  Created by Zining Wang on 8/28/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {
    
    @IBOutlet var needSignIn: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addBackground(imageName: "LogInScreen")
    }
    
    @IBAction func signinTapped(_ sender: Any) {
        
        // Create default Auth UI
        let authUI = FUIAuth.defaultAuthUI()
        
        // Check that it isn't nil
        guard authUI != nil else {
            return
        }
        
        // Set delegate and specify sign in options
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        
        // Get the auth view controller and present it
        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)

    }

    private func showMainController() {

        let vc = ContainerViewController()
        self.present(vc, animated: true, completion: nil)
        
    }
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        // Check for error
        guard error == nil else {
            print("error signing in")
            return
        }
        showMainController()
    }
    
}




