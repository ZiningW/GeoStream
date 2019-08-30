//
//  MainViewController.swift
//  GeoStream
//
//  Created by Zining Wang on 8/28/19.
//  Copyright © 2019 Zining Wang. All rights reserved.

import simd
import UIKit
// For location services
import CoreLocation

// For Firebase Database
import FirebaseDatabase
import FirebaseUI
// For Apple Maps
import MapKit

// For authentification
import LocalAuthentication

class MainViewController: UIViewController, UITextFieldDelegate {

    
    // MARK: - class declarations
    let fHandler = FirebaseHandler()
    let videoVC = VideoChatViewController()
    // Variable for map annotation
    let selfAnnotation = CustomAnnotation()
    //MARK: - For sliding panels
    var delegate: MainViewControllerDelegate?
    
    // MARK: - Variable Declarations
    // Segment control for left panel
    var selectedSegment: Int = 0
    
    var timedFetch = Timer()

    // init buttons
    @IBOutlet var centerButton: UIButton!
    @IBOutlet weak var centerUserFormat: ImageButton!
    @IBOutlet weak var leftMenuFormat: ImageButton!
    // for checking if user centered themselves on the map
    var centerTapped: Bool = true
    
    // for checking if user dragged map
    private var mapChangedFromUserInteraction = false
    
    // Init Sensor Values for Bose
    var selfLatValue: Double = 0
    var selfLongValue: Double = 0
    var selfLocationValue: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    // MARK: - For location services and heading
    // Location manager for receiving location information
    private var locationManager = CLLocationManager()
    /// The current location.
    private var currentLocation: CLLocation?

    // For Firebase
    // For referencing database, referencing only the node under "UserBase"
    var ref = Database.database().reference().child("UserBase")
    
    // Self User UID - Unique ID
    var selfUserUid: String = "None"
    var selfUserName: String = "None"
    
    // Dictionaries for pulling data from firebase
    // Initialize a dictionary
    var postDict = [String:
        [String:AnyObject]
        ]()
    // New Dictionary of bearings and uid
    var trackedUID = [String: String]()
    // Tracking a list of annotation objects for other users
    var annoObjectDict = [String: CustomAnnotation]()
    // Tracking a list of annotation uid created from status button press
    var statusAnnoObjectList = [String]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - On load
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // get your own username
        selfUserName = fHandler.myName
        selfUserUid = fHandler.myId
        
        // Initialize all user values on firebase
        fHandler.initializeUser(lat: selfLatValue, long: selfLongValue)
        
        // For map self annotation
        selfAddAnnotation()
        
        currentLocation = nil
        enableLocationServices()
        // For mapView delegates
        mapView.delegate = self
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 50, longitudinalMeters: 50)
            mapView.setRegion(viewRegion, animated: false)
        }
        self.locationManager = locationManager
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }

        // For fetching firebase initially
        fetchFirebaseInfo()
        
        timedFunction()
    }
    
    // check if user touched map, basically removes tracking if the user dragged the map
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    // Log back out to launchscreen, signsout of firebase auth, stops listeners for sensors and sets firebase value to signout
    private func logOutReturnToMain(){
        
        let onlineStatus = selfUserUid + "/" + "OnlineStatus"
        ref.child(onlineStatus).setValue("Offline")
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func centerUser(_ sender: Any) {
        // Centers the user to current location
        let viewRegion = MKCoordinateRegion(center: selfLocationValue, latitudinalMeters: 50, longitudinalMeters: 50)
        mapView.setRegion(viewRegion, animated: true)
        
        centerTapped = true
    }
    
    @IBAction func leftMenu(_ sender: Any) {
        // Trigers the left menu with device options and logout
        delegate?.toggleLeftPanel()
    }
    
    @IBAction func videoStreamAction(_ sender: Any) {
        hostStream()
    }
    
}

// MARK: - For streaming
extension MainViewController{
    func hostStream(){
        let videoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "videoView") as! VideoChatViewController
        videoVC.isPublisher = true
        self.view.addSubview(videoVC.view)
        addChild(videoVC)
        videoVC.didMove(toParent: self)
    }
    
    func viewStream(streamID: String, api: String, token: String){
        let videoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "videoView") as! VideoChatViewController
        videoVC.isPublisher = false
        videoVC.kSessionId = streamID
        videoVC.kApiKey = api
        videoVC.kToken = token
        self.view.addSubview(videoVC.view)
        addChild(videoVC)
        videoVC.didMove(toParent: self)
    }
}

// MARK: - for map annotations
extension MainViewController{
    // extensions for map annotations
    func movePosition(annotation: CustomAnnotation, newCoordinate: CLLocationCoordinate2D) {
        // for changing location of other users' annotations
        UIView.animate(withDuration: 0.0, delay: 0, options: [.curveLinear, .beginFromCurrentState], animations: {
            annotation.coordinate = newCoordinate
        }, completion: nil)
    }
    
    func addAnnotation(uid: String, name: String, coordinate: CLLocationCoordinate2D){
        // for adding annotation
        let annotation = CustomAnnotation()
        annotation.title = name
        annotation.coordinate = coordinate
        annotation.uid = uid
        annotation.identifier = uid
        annoObjectDict[uid] = (annotation)
        mapView.addAnnotation(annotation)
    }
    
    func selfAddAnnotation(){
        // for adding our own annotation
        selfAnnotation.coordinate = selfLocationValue
        selfAnnotation.title = selfUserName
        selfAnnotation.identifier = AnnoStruct.selfID
        mapView.addAnnotation(selfAnnotation)
    }
}

extension MainViewController: MKMapViewDelegate {
    // for assigning annotation graphics
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? CustomAnnotation else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier")
        
        
        if annotation.identifier == AnnoStruct.selfID {
            // if the annotation is our custom annotation
            selfAnnotation.annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            selfAnnotation.addSelfAnnotationImage(imageName: "013-pin-10")
            selfAnnotation.glowingAnnotation(color: UIColor.green.cgColor)
            annotationView = selfAnnotation.annotationView
            
            
        } else {
            annotation.annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            annotation.addAnnotationImage(imageName: "location_video")
            annotation.statusGlow(color: UIColor.green.cgColor)
            annotationView = annotation.annotationView
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Map button applied to other user's annotations for calling
        let userAnno = view.annotation as! CustomAnnotation
        
        guard let channelStreamID = userAnno.streamChannelID else {return}
        guard let api = userAnno.streamAPI else {return}
        guard let token = userAnno.streamToken else {return}
        viewStream(streamID: channelStreamID, api: api, token: token)

    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        // for determining if user dragged the map
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if (mapChangedFromUserInteraction) {
            centerTapped = false
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (mapChangedFromUserInteraction) {
            centerTapped = false
        }
    }
}

extension MainViewController {
    func timedFunction(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timedFetch = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fetchFirebase), userInfo: nil, repeats: true)
    }
    
    @objc func fetchFirebase(){
        // Fetch all user information from firebase every second, probably not the best way to do this
        self.fetchFirebaseInfo()
    }
}

// MARK: - for FireBase get users
extension MainViewController{
    
    func fetchFirebaseInfo(){
        // Fetches user information every second
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.postDict = snapshot.value as? [String : [String:AnyObject]] ?? [:]
            // Remove ourself from the dictionary
            self.postDict.removeValue(forKey: self.selfUserUid)
            
            for (uid, values) in self.postDict {
                
                let lat = values["LatValue"]! as! Double
                let long = values["LongValue"]! as! Double
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let broadcastChannel = values["BroadcastChannel"] as! String
                
                let broadcasting = values["Broadcasting"] as! String
                let broadcastAPI = values["API"] as! String
                let broadcastToken = values["Token"] as! String
                

                let userName = values["UserNameValue"] as! String
                
                if broadcasting == broadcastContants.isBroadcasting &&
                    self.annoObjectDict[uid]?.streaming != "true" {
                    print("found broadcaster \(userName)")
                    if self.annoObjectDict[uid]?.annotationView != nil {
                        self.annoObjectDict[uid]?.streaming = "true"
                        self.annoObjectDict[uid]?.streamChannelID = broadcastChannel
                        self.annoObjectDict[uid]?.streamAPI = broadcastAPI
                        self.annoObjectDict[uid]?.streamToken = broadcastToken
                    }
                }
                
                if broadcasting == broadcastContants.isBroadcasting && self.trackedUID.index(forKey: uid) == nil{
                    // If they're broadcasting and this is the first time, add a map annotation
                    self.trackedUID[uid] = "Broadcasting"
                    self.addAnnotation(uid: uid, name: userName, coordinate: coordinate)
                } else if broadcasting == broadcastContants.isBroadcasting && self.trackedUID.index(forKey: uid) != nil{
                    // If they're broadcasting but we already know that, then move annotation based on location udpates
                    guard let anno = self.annoObjectDict[uid] else {return}
                    self.movePosition(annotation: anno, newCoordinate: coordinate)
                } else if broadcasting == broadcastContants.notBroadcasting{
                    // If they stopped broadcasting, remove their annotation from the map
                    self.trackedUID.removeValue(forKey: uid)
                    guard let anno = self.annoObjectDict[uid] else {return}
                    self.mapView.removeAnnotation(anno)
                    self.annoObjectDict.removeValue(forKey: uid)
                    
                }
            }
            
        })
        
    }
    
}

// MARK: - Location Services and CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    
    /// Call this when the view loads to enable location services. Note that `NSLocationWhenInUseUsageDescription` must be defined in your Info.plist or the authorization status will be `.denied`.
    private func enableLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Requesting authorization to use location services")
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location services enabled")
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            print("Cannot enable location services")
            currentLocation = nil
        @unknown default:
            debugPrint("Location services error")
        }
    }
    
    /// Delegate method called when the authorization status changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location services authorized -- enabled")
            locationManager.startUpdatingLocation()
            
        case .notDetermined, .restricted, .denied:
            print("Location services not authorized -- disabled")
            currentLocation = nil
        @unknown default:
            debugPrint("location manager error")
        }
    }
    
    /// Delegate method called when the location changes.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // We are only interested in the last location in the array.
        guard let location = locations.last else {
            return
        }
        // Save and display the current location.
        currentLocation = location
        selfLatValue = location.coordinate.latitude
        selfLongValue = location.coordinate.longitude
        selfLocationValue = location.coordinate
        selfLocationValue = CLLocationCoordinate2D(latitude: selfLatValue, longitude: selfLongValue)
        fHandler.sendLocation(lat: selfLatValue, long: selfLongValue)
        
        // if user tapped the center button, then we track and recenter the map to user location
        if self.centerTapped == true{
            let viewRegion = MKCoordinateRegion(center: self.selfLocationValue, latitudinalMeters: 50, longitudinalMeters: 50)
            self.mapView.setRegion(viewRegion, animated: true)
        }
        // check if user moved and animate the move
        self.movePosition(annotation: self.selfAnnotation, newCoordinate: self.selfLocationValue)
        
    }
    
}


extension MainViewController: LeftPanelViewControllerDelegate {
    
    func logOut() {
        // for the logout button
        logOutReturnToMain()
    }
    
    func satelliteMapButtons(){
        // for setting our image button formats when the user wants to get a satellite view
        centerUserFormat.setShadowWhite()
        leftMenuFormat.setShadowWhite()
    }
    
    func flatMapButtons(){
        // for setting our image button formats when the user wants a flat map view
        centerUserFormat.setShadow()
        leftMenuFormat.setShadow()
    }
    func switchMapType(type: Int) {
        // for switching our map type based on the segment selector in the left panel
        switch type{
            case 0:
                mapView.mapType = .standard
                flatMapButtons()
                selectedSegment = 0
            case 1:
                mapView.mapType = .satellite
                satelliteMapButtons()
                selectedSegment = 1
            case 2:
                mapView.mapType = .hybrid
                satelliteMapButtons()
                selectedSegment = 2
            default:
                break
        }
    }
}

protocol MainViewControllerDelegate {
    func toggleLeftPanel()
    func collapseSidePanels()
}
