//
//  GetDataViewController.swift
//  JoggingCircuit
//
//  Created by Ryan McCollam on 4/20/15.
//  Copyright (c) 2015 Ryan McCollam. All rights reserved.
//

import UIKit

class GetDataViewController: UIViewController {
    
    
    @IBOutlet weak var endingText: UITextField!
    
    @IBOutlet weak var tapsText: UITextField!
    @IBOutlet weak var startingText: UITextField!
    
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    var endLat: CLLocationDegrees!
    var endLong: CLLocationDegrees!
    var startLat: CLLocationDegrees!
    var startLong: CLLocationDegrees!
    var taps: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "running-path_00006124.jpg")!)

        storeButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.3)
        
        storeButton.layer.cornerRadius = 13.0
        showButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.3)
        showButton.layer.cornerRadius = 13.0

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
        
        self.taps = tapsText.text.toInt()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        

            var viewController:ViewController = segue.destinationViewController as! ViewController
            viewController.endLat = endLat
            viewController.endLong = endLong
            viewController.startLat = startLat
            viewController.startLong = startLong
            viewController.taps = taps

    }

}
