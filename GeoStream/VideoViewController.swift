//
//  VideoViewController.swift
//  GeoStream
//
//  Created by Zining Wang on 8/28/19.
//  Copyright © 2019 Zining Wang. All rights reserved.

import UIKit
import OpenTok

class VideoChatViewController: UIViewController {
    
    var session: OTSession?
    var publisher: OTPublisher?
    var subscriber: OTSubscriber?
    
    // Replace with your OpenTok API key
    var kApiKey = ""
    // Replace with your generated session ID
    var kSessionId = ""
    // Replace with your generated token
    var kToken = ""
    
    var isPublisher: Bool = false
    

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var switchCamera: UIButton!
    
    // for if we're the audience, if we're the host we pull directly from firebasehandler
    var streamID: String?
    var fHandler = FirebaseHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        if isPublisher == true {
            // If we're hosting the stream, create a session
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            let url = URL(string: "https://geo-stream.herokuapp.com/room/:name")
            let dataTask = session.dataTask(with: url!) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                guard error == nil, let data = data else {
                    print(error!)
                    return
                }
                
                let dict = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
                self.kApiKey = dict?["apiKey"] as? String ?? ""
                self.kSessionId = dict?["sessionId"] as? String ?? ""
                self.kToken = dict?["token"] as? String ?? ""
                self.connectToAnOpenTokSession()
                
                self.fHandler.hostBroadcast(streamID: self.kSessionId, api: self.kApiKey, token: self.kToken)
            }
            
            dataTask.resume()
            session.finishTasksAndInvalidate()
        } else {
            // if we're watching a stream, join using session id and other information received from FireBase
            self.fHandler.watchBroadcast(streamID: self.kSessionId, api: self.kApiKey, token: self.kToken)
            self.connectToAnOpenTokSession()
        }
        
        
        if isPublisher == false {
            switchCamera.isHidden = true
        }
        
    }
    
    func connectToAnOpenTokSession() {
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)
        var error: OTError?
        session?.connect(withToken: kToken, error: &error)
        if error != nil {
            print(error!)
        }
    }

    
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        print("video side hang up")
        fHandler.stopStream()
        leaveChannel()
    }
    
    @IBAction func didClickAudHangUpButton(_ sender: UIButton) {
        fHandler.stopStream()
        leaveChannel()
    }
    
    
    func leaveChannel() {
        // Leave the stream as soon as we hand up or the publisher stops the stream (OTSessionDelegate)
        fHandler.stopStream()
        print("isPublisher", isPublisher)
        var error: OTError?
        guard let session = session else {return}
        
        if isPublisher == true{
            print("unpublish", publisher!)
            guard let publisher = publisher else {return}
            session.unpublish(publisher, error: &error)
        } else {
            print("unsubscribe", subscriber!)
            guard let subscriber = subscriber else {return}
            session.unsubscribe(subscriber, error: &error)
        }
        
        UIApplication.shared.isIdleTimerDisabled = false
        guard let viewTest = videoView else {return}
        viewTest.removeFromSuperview()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if isPublisher == true{
            publisher?.publishAudio = sender.isSelected
        } else {
            subscriber?.subscribeToAudio = sender.isSelected
        }
        
    }

    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            publisher?.cameraPosition = AVCaptureDevice.Position.front
        } else {
            publisher?.cameraPosition = AVCaptureDevice.Position.back
        }        
    }
    
    
    @IBAction func returnToMainView(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
}

// MARK: - OTSubscriberDelegate callbacks
extension VideoChatViewController: OTSubscriberDelegate {
    public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
        print("The subscriber did connect to the stream.")
    }
    
    public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("The subscriber failed to connect to the stream.")
    }
}

// MARK: - OTPublisherDelegate callbacks
extension VideoChatViewController: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("The publisher failed: \(error)")
    }
}

// MARK: - OTSessionDelegate callbacks
extension VideoChatViewController: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("The client connected to the OpenTok session.")
        
        if isPublisher == true{
        
            let settings = OTPublisherSettings()
            settings.name = UIDevice.current.name
            guard let pub = OTPublisher(delegate: self, settings: settings) else {
                return
            }
            
            pub.publishAudio = false
            pub.cameraPosition = AVCaptureDevice.Position.back
            print("publisher connected", pub)
            var error: OTError?
            session.publish(pub, error: &error)
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let publisherView = pub.view else {
                return
            }

            // Our view should take up the entire screen. What we see depends on if we're the publisher or subscriber
            publisherView.frame = videoView.frame
            videoView.addSubview(publisherView)
            publisher = pub
        }
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("The client disconnected from the OpenTok session.")
        leaveChannel()
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("The client failed to connect to the OpenTok session: \(error).")
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("A stream was created in the session.")
        
        if isPublisher == false {
            subscriber = OTSubscriber(stream: stream, delegate: self)
            guard let subscriber = subscriber else {
                return
            }
            subscriber.subscribeToAudio = false
            var error: OTError?
            session.subscribe(subscriber, error: &error)
            
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let subscriberView = subscriber.view else {
                return
            }
            // Our view should take up the entire screen. What we see depends on if we're the publisher or subscriber
            subscriberView.frame = videoView.frame
            videoView.insertSubview(subscriberView, at: 0)
            
        }
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("A stream was destroyed in the session.")
        leaveChannel()
    }
}
