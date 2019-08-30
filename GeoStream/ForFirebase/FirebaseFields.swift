//
//  FirebaseFields.swift
//  GeoStream
//
//  Created by Zining Wang on 8/28/19.
//  Copyright © 2019 Zining Wang. All rights reserved.
//

import Foundation
import FirebaseUI
import FirebaseDatabase

struct FirebaseFields{
    // Mark: - Firebase Fields
    static let userBase: String = "UserBase"
    static let lat: String = "LatValue"
    static let long: String = "LongValue"
    static let username: String = "UserNameValue"
    static let uid: String = "UserUIDValue"
    static let onlineStatus: String = "OnlineStatus"
    static let broadcasting: String = "Broadcasting"
    static let broadCastChannel: String = "BroadcastChannel"
    static let broadCastRole: String = "BroadcastRole"
    static let broadCastToken: String = "Token"
}

struct constants{
    // Constants for default user id
    static let defaultID: String = "OjelPnlZPdewEMG0xfm592Ojo0e2"
    static let defaultUser: String = "Zining Wang"
    // Constants for initializing or reverting different statuses
    static let noOne: String = ""
    static let onlineStatus: String = "Online"
    static let notConnected: String = "NotConnected"
    
}

struct broadcastContants{
    static let isBroadcasting: String = "true"
    static let notBroadcasting: String = "false"
    
    static let hostBroadcast: String = "host"
    static let audBroadcast: String = "audience"
}
