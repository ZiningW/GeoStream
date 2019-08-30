//
//  customFirebase.swift
//  GeoStream
//
//  Created by Zining Wang on 8/28/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//
//
import FirebaseDatabase
import FirebaseUI
import CoreLocation
import AVKit

class FirebaseHandler: NSObject {
    
    // MARK: - Class declarations
    // Reference to my own firebase
    var myBase: DatabaseReference
    // Reference to entire UserBase on firebase
    var base: DatabaseReference
    // Reference to channels firebase
    private var channelBase: DatabaseReference?
    
    // Names and ID's
    let myId: String
    let myName: String
    
    var broadcastID: String?
    
    var selfFirebaseTracker = [String:Any]()
    
    // Mark: Status Identifier
    enum ConnectionStatus: String {
        case Connected
        case Connecting
        case NotConnected
    }
    
    
    //Mark: - Functions
    override init() {
        // Mark: Default Values
        self.myId = Auth.auth().currentUser?.uid ?? constants.defaultID
        self.myName = Auth.auth().currentUser?.displayName ?? constants.defaultUser
        self.myBase = Database.database().reference().child("UserBase").child(self.myId)
        self.base = Database.database().reference().child("UserBase")
        self.channelBase = Database.database().reference().child("Channels")
        
    }
    
    func initializeUser(lat: Double, long: Double) {
        // initialize firebase values on login
        let initData = [FirebaseFields.onlineStatus: constants.onlineStatus,
                        FirebaseFields.username: myName,
                        FirebaseFields.uid: myId,
                        FirebaseFields.lat: lat,
                        FirebaseFields.long: long,
                        FirebaseFields.broadcasting: broadcastContants.notBroadcasting,
                        FirebaseFields.broadCastChannel: constants.notConnected,
                        FirebaseFields.broadCastRole: constants.notConnected,
                        FirebaseFields.broadCastToken: constants.notConnected] as [String : Any]
        
        selfFirebaseTracker = initData
        // push initial values to firebase
        self.myBase.updateChildValues(initData)
    }
    
    func sendLocation(lat: Double, long: Double){
        let selfLocation = ["\(FirebaseFields.lat)": lat,
                            "\(FirebaseFields.long)": long] as [String : Any]
        // push initial values to firebase
        self.myBase.updateChildValues(selfLocation)
    }
   
}

// For managing video broadcasting
extension FirebaseHandler{
    func hostBroadcast(streamID: String, token: String){
        // If we're hosting, send our session information created in VideoViewController to Firebase so viewers can join our stream
        broadcastID = streamID
        let broadCastData = ["\(myId)/\(FirebaseFields.broadCastRole)": broadcastContants.hostBroadcast,
                             "\(myId)/\(FirebaseFields.broadCastChannel)": streamID,
                             "\(myId)/\(FirebaseFields.broadcasting)": broadcastContants.isBroadcasting,
                             "\(myId)/\(FirebaseFields.broadCastToken)": token]
        
        self.base.updateChildValues(broadCastData)
    }
    
    func stopStream(){
        // Update our own firebase values if either we stop our stream or the publisher stops publishing
        let broadCastData = ["\(myId)/\(FirebaseFields.broadCastRole)": constants.notConnected,
                             "\(myId)/\(FirebaseFields.broadCastChannel)": constants.notConnected,
                             "\(myId)/\(FirebaseFields.broadcasting)": broadcastContants.notBroadcasting,
                             "\(myId)/\(FirebaseFields.broadCastToken)": constants.notConnected]
        
        self.base.updateChildValues(broadCastData)
    }
    
    func watchBroadcast(streamID: String, token: String){
        // Update our firebase values based on which stream we joined
        let broadCastData = ["\(myId)/\(FirebaseFields.broadCastRole)": broadcastContants.audBroadcast,
                             "\(myId)/\(FirebaseFields.broadCastChannel)": streamID,
                             "\(myId)/\(FirebaseFields.broadcasting)": broadcastContants.notBroadcasting,
                             "\(myId)/\(FirebaseFields.broadCastToken)": token]
        
        self.base.updateChildValues(broadCastData)
    }
    
    
}




