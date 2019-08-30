//
//  LeftPanelViewController.swift
//  Nod N Talk
//
//  Created by Zining Wang on 6/22/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LeftPanelViewController: UIViewController {
    
    var selfName: String?
    var selectedSegment: Int = 0
    
    
    @IBOutlet weak var selfNameOutlet: UILabel!
    @IBOutlet weak var logOutButton: ImageButton!

    var delegate: LeftPanelViewControllerDelegate?
    
    @IBOutlet weak var mapSelectSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addBackground(imageName: "LeftPullOut")
        selfNameOutlet.text = selfName
        
        mapSelectSegment.selectedSegmentIndex = selectedSegment
        mapSelectSegment.tintColor = Colors.evilBlue
        
        self.view.addSubview(logOutButton)
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        delegate?.logOut()
    }
    
    @IBAction func mapTypeSwitch(_ sender: UISegmentedControl) {
        delegate?.switchMapType(type: sender.selectedSegmentIndex)
    }

}

protocol LeftPanelViewControllerDelegate {

    func logOut()
    func switchMapType(type: Int)

}

