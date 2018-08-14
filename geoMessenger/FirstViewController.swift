//
//  FirstViewController.swift
//  geoMessenger
//
//  Created by Tyler Crandall on 8/13/18.
//  Copyright © 2018 TCrandall. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class FirstViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var messageNodeRef : DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.mapView.delegate = self
        
        //initial location to MU
        let initialLocation = CLLocation(latitude: 43.038611, longitude: -87.928759)
        centerMapOnLocation(location: initialLocation)
        
        //create FDB ref
        messageNodeRef = Database.database().reference().child("messages")
        
        let pinMessageID = "msg-1"
        var pinMessage: Message?
        messageNodeRef.child(pinMessageID).observe(.value, with: {(snapshot: DataSnapshot) in
            if let dictionary = snapshot.value as? [String: Any]
            {
                if pinMessage != nil
                {
                    self.mapView.removeAnnotation(pinMessage!)
                }
                
                let pinLat = dictionary["latitude"] as! Double
                let pinLong = dictionary["longitude"] as! Double
                let messageDisabled = dictionary["isDisabled"] as! Bool
                
                let message = Message(title: (dictionary["title"] as? String)!, locationName: (dictionary["locationName"] as? String)!, username: (dictionary["username"] as? String)!, coordinate: CLLocationCoordinate2D(latitude: pinLat, longitude: pinLong),isDisabled: messageDisabled)
            
            print (pinLat)
            pinMessage = message
            
            if !message.isDisabled
            {
                self.mapView.addAnnotation(message)
            }
            }
        })
        
        let message = Message(title: "Marquette is Cool!", locationName: "MU", username: "John Smith", coordinate: CLLocationCoordinate2D(latitude: 43.038611, longitude: -87.928759), isDisabled: false)
        
        mapView.addAnnotation(message)
    }
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2, regionRadius*2)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }


}

