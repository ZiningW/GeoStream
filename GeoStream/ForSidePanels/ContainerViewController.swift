//
//  ContainerViewController.swift
//  Nod N Talk
//
//  Created by Zining Wang on 6/21/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//

import UIKit
import simd

class ContainerViewController: UIViewController {
    enum SlideOutState {
        case bothCollapsed
        case leftPanelExpanded
    }
    
    var centerNavigationController: UINavigationController!
    var mainViewController: MainViewController!
    
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var leftViewController: LeftPanelViewController?

    let centerPanelExpandedOffset: CGFloat = 90
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewController = UIStoryboard.mainViewController()
        mainViewController.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: mainViewController)
        centerNavigationController.setNavigationBarHidden(true, animated: true)
        view.addSubview(centerNavigationController.view)
        addChild(centerNavigationController)
        
        centerNavigationController.didMove(toParent: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
  
    }

}

private extension UIStoryboard {
    static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    static func leftViewController() -> LeftPanelViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? LeftPanelViewController
    }
    
    static func mainViewController() -> MainViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
    }
}

// MARK: CenterViewController delegate

extension ContainerViewController: MainViewControllerDelegate {
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        
        guard leftViewController == nil else { return }
        
        if let vc = UIStoryboard.leftViewController() {
            vc.selfName = mainViewController.selfUserName
            vc.selectedSegment = mainViewController.selectedSegment
            
            addChildLeftSidePanelController(vc)
            leftViewController = vc
        }
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .bothCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }

    
    func collapseSidePanels() {
        switch currentState {
            
        case .leftPanelExpanded:
            toggleLeftPanel()
            
        default:
            break
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut, animations: {
                        self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    
    func addChildLeftSidePanelController(_ sidePanelController: LeftPanelViewController) {
        sidePanelController.delegate = mainViewController
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
            mainViewController.view.isUserInteractionEnabled = false
            
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
            mainViewController.view.isUserInteractionEnabled = true
            
        }
    }
}

// MARK: Gesture recognizer

extension ContainerViewController: UIGestureRecognizerDelegate {
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        
        switch recognizer.state {
        case .began:
            if currentState == .bothCollapsed {
                if gestureIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                }
                showShadowForCenterViewController(true)
            }
            
        case .changed:
            if let rview = recognizer.view {
                rview.center.x = rview.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
            
        case .ended:
            if let _ = leftViewController,
                let rview = recognizer.view {
                // animate the side panel open or closed based on whether the view
                // has moved more or less than halfway
                let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            
        default:
            break
        }
    }
    
    
}

