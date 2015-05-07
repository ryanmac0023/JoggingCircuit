//
//  GetDataViewController.swift
//  JoggingCircuit
//
//  Created by Ryan McCollam on 4/20/15.
//  Copyright (c) 2015 Ryan McCollam. All rights reserved.
//

import UIKit
import CoreLocation

class GetDataViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var endingText: UITextField!
    
    @IBOutlet weak var startingText: UITextField!
    
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    
    @IBOutlet weak var startSwitch: UISwitch!
    
    @IBOutlet weak var endSwitch: UISwitch!
    
    let locManager = CLLocationManager()

    var currentPosition = CLLocationCoordinate2D()

    var endLat: CLLocationDegrees!
    var endLong: CLLocationDegrees!
    var startLat: CLLocationDegrees!
    var startLong: CLLocationDegrees!
    var taps: Int!
    var maps: [AnyObject] = []

    var startCurrent: Bool = false
    var endCurrent: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locManager.delegate = self
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locManager.requestWhenInUseAuthorization()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "running-path_00006124.jpg")!)

        storeButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.3)
        
        storeButton.layer.cornerRadius = 13.0
        showButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.3)
        showButton.layer.cornerRadius = 13.0
        
        self.endingText.delegate = self
        self.endingText.delegate = self
        startSwitch.setOn(false, animated: false);
        endSwitch.setOn(false, animated: false);
        startSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        endSwitch.addTarget(self, action: Selector("stateChanged2:"), forControlEvents: UIControlEvents.ValueChanged)
        showButton.hidden = true
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let gameNamesFromNSUD = defaults.stringArrayForKey("maps") {
            maps = gameNamesFromNSUD
        }
        

    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            
            
            self.locManager.startUpdatingLocation()
            

        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            currentPosition = location.coordinate
            
            self.locManager.stopUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error:" + error.localizedDescription)
    }

    
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            startCurrent = true
        } else {
            startCurrent = false
        }
    }
    
    func stateChanged2(switchState: UISwitch) {
        if switchState.on {
            endCurrent = true
        } else {
            endCurrent = false
        }
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        var address = self.endingText.text
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                self.endLat = placemark.location.coordinate.latitude
                self.endLong = placemark.location.coordinate.longitude

            }
        })
        
        var address2 = self.startingText.text
        var geocoder2 = CLGeocoder()
        geocoder2.geocodeAddressString(address2, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                self.startLat = placemark.location.coordinate.latitude
                self.startLong = placemark.location.coordinate.longitude

            }
        })
        
        self.taps = 5
        showButton.hidden = false


    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "createRoute")
        {
            var viewController:ViewController = segue.destinationViewController as! ViewController
            if(endCurrent == true)
            {
                viewController.endLat = currentPosition.latitude
                viewController.endLong = currentPosition.longitude
            }
            else{
                viewController.endLat = endLat
                viewController.endLong = endLong
            }
            if(startCurrent == true){
                viewController.startLat = currentPosition.latitude
                viewController.startLong = currentPosition.longitude
            }
            else{
                viewController.startLat = startLat
                viewController.startLong = startLong
            }
            
            viewController.taps = taps
            viewController.startCurrent = startCurrent
            viewController.endCurrent = endCurrent
            viewController.currentPosition = currentPosition
            // let defaults = NSUserDefaults.standardUserDefaults()
            // defaults.setObject(maps, forKey: "maps")
            
            
        }
        
        
    }

}
