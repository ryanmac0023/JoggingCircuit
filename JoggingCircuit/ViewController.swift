//
//  ViewController.swift
//  JoggingCircuit
//
//  Created by Ryan McCollam on 4/8/15.
//  Copyright (c) 2015 Ryan McCollam. All rights reserved.
//

import UIKit
import CoreLocation
import Darwin



class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    
    
    let dataProvider = GoogleDataProvider()
    let locManager = CLLocationManager()
    let undoButton = UIButton()
    let startButton = UIButton()
    let backButton = UIButton()
    let timerLabel = UILabel()
    var mapView = GMSMapView()
    var currentPosition = CLLocationCoordinate2D()
    var endingPosition = CLLocationCoordinate2D()
    var endLat: CLLocationDegrees!
    var endLong: CLLocationDegrees!
    var startLat: CLLocationDegrees!
    var startLong: CLLocationDegrees!
    var taps: Int!
    var startCurrent: Bool!
    var endCurrent: Bool!
    var markerStart = GMSMarker()
    var markerEnd = GMSMarker()
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    

 
    
    var coordsArray: Array<CLLocationCoordinate2D> = []
    var markersArray: Array<GMSMarker> = []
       var test: Int = 0
        var check: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(1)
        // Do any additional setup after loading the view, typically from a nib.
        self.locManager.delegate = self
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locManager.requestWhenInUseAuthorization()
        
        if(endCurrent == true){
            endLat = currentPosition.latitude
            endLong = currentPosition.longitude
        }
        
        

        self.testFunc()


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testFunc(){
        
        
            
            var camera = GMSCameraPosition.cameraWithLatitude(startLat, longitude: startLong, zoom: 15)
            mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
            mapView.myLocationEnabled = true
            mapView.delegate = self
            var position = CLLocationCoordinate2DMake(startLat,  startLong)
            coordsArray.append(position)
            markerStart = GMSMarker(position: position)
            endingPosition = CLLocationCoordinate2DMake(endLat, endLong)
            markerStart.title = "Start"
            markerStart.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
            markerStart.map = mapView
            markersArray.append(markerStart)
            markerEnd = GMSMarker(position: endingPosition)
            markerEnd.title = "End"
            markerEnd.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
            markerEnd.map = mapView
            markersArray.append(markerEnd)
            
            self.view = mapView
        
        
        undoButton.setTitle("Undo Tap", forState: .Normal)
        undoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        undoButton.frame = CGRectMake(15, 510, 100, 50)
        undoButton.addTarget(self, action: "undoPressed:", forControlEvents: .TouchUpInside)
        undoButton.backgroundColor = UIColor(white: 0.667, alpha: 0.5)
        undoButton.layer.cornerRadius = 13.0
        self.view.addSubview(undoButton)
        
        startButton.setTitle("Start Route", forState: .Normal)
        startButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        startButton.frame = CGRectMake(120, 510, 100, 50)
        startButton.addTarget(self, action: "startPressed:", forControlEvents: .TouchUpInside)
        startButton.backgroundColor = UIColor(white: 0.667, alpha: 0.5)
        startButton.layer.cornerRadius = 13.0
        self.view.addSubview(startButton)
        
        backButton.setTitle("Back", forState: .Normal)
        backButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        backButton.frame = CGRectMake(0, 0, 100, 50)
        backButton.addTarget(self, action: "backPressed:", forControlEvents: .TouchUpInside)
        backButton.backgroundColor = UIColor(white: 0.667, alpha: 0.5)
        backButton.layer.cornerRadius = 13.0
        self.view.addSubview(backButton)
        
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            
            
            self.locManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }


    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            
            currentPosition = location.coordinate

            if(check == 0){
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                        self.locManager.stopUpdatingLocation()
            }
            else if(check == 1){
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error:" + error.localizedDescription)
    }
    
    func backPressed(sender:UIButton!){
        performSegueWithIdentifier("backSegue", sender: sender)
    }
    
    func startPressed(sender:UIButton!){
        
        timerLabel.frame = CGRectMake(120, 510, 100, 50)
        timerLabel.font = UIFont(name: timerLabel.font.fontName, size: 20)
                self.view.addSubview(timerLabel)
        
        while(markersArray.count > 2)
        {
            var marker = markersArray[markersArray.count - 1]
            marker.map = nil
            markersArray.removeLast()
        }
        
        startButton.hidden = true
        undoButton.hidden = true
        
        self.locManager.startUpdatingLocation()
        self.check = 1
        
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()

    
    }
    
    func updateTime(){
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
        let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    func undoPressed(sender: UIButton!) {

        if(markersArray.count > 2)
        {
        var marker = markersArray[markersArray.count - 1]
        
        self.mapView.clear()
        markersArray.removeLast()
        coordsArray.removeLast()
        var startMarker = markersArray[0]
        var endMarker = markersArray[1]
        
        startMarker.map = mapView
        endMarker.map = mapView
            
        
            
            if (coordsArray.count < (taps + 2))
            {
                var i = 0
                var j = 2
                

                
                
                
                while(i < coordsArray.count - 1)
                {
                    
                    var marker = markersArray[j]
                    marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
                    
                    marker.map = mapView

                    self.dataProvider.fetchDirectionsFrom(coordsArray[i], to: coordsArray[i+1]) {optionalRoute in
                        if let encodedRoute = optionalRoute {
                            let path = GMSPath(fromEncodedPath: encodedRoute)
                            let line = GMSPolyline(path: path)
                            
                            line.strokeWidth = 4.0
                            line.tappable = true
                            line.map = self.mapView
                        }
                        
                    }
                    i++
                    j++
                    if(coordsArray.count - 1 == taps)
                    {
                        coordsArray.append(endingPosition)
                        
                        
                        var position = CLLocationCoordinate2DMake(endLat, endLong)
                        var marker = GMSMarker(position: position)
                        marker.title = "End"
                        marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
                        marker.map = self.mapView
                        
                        self.dataProvider.fetchDirectionsFrom(coordsArray[coordsArray.count - 3], to: coordsArray[coordsArray.count - 2]) {optionalRoute in
                            if let encodedRoute = optionalRoute {
                                let path = GMSPath(fromEncodedPath: encodedRoute)
                                let line = GMSPolyline(path: path)
                                
                                line.strokeWidth = 4.0
                                line.tappable = true
                                line.map = self.mapView
                                
                                
                            }
                            
                        }
                        self.dataProvider.fetchDirectionsFrom(coordsArray[coordsArray.count - 2], to: coordsArray[coordsArray.count - 1]) {optionalRoute in
                            if let encodedRoute = optionalRoute {
                                let path = GMSPath(fromEncodedPath: encodedRoute)
                                let line = GMSPolyline(path: path)
                                
                                line.strokeWidth = 4.0
                                line.tappable = true
                                line.map = self.mapView
                            }
                        }
                        check = 1
                        
                        
                    }
                }

        }
        }
        
    }
    

    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        coordsArray.append(coordinate)

        if (coordsArray.count < (taps + 2))
        {
            var i = 0
        
                var position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                var marker = GMSMarker(position: position)
                marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        
                marker.map = mapView
            markersArray.append(marker)
            


        while(i < coordsArray.count - 1)
        {
            
        self.dataProvider.fetchDirectionsFrom(coordsArray[i], to: coordsArray[i+1]) {optionalRoute in
            if let encodedRoute = optionalRoute {
                let path = GMSPath(fromEncodedPath: encodedRoute)
                let line = GMSPolyline(path: path)
                
                line.strokeWidth = 4.0
                line.tappable = true
                line.map = mapView
            }
            
            }
            i++

            if(coordsArray.count - 1 == taps)
            {
                coordsArray.append(endingPosition)
                
                
                var position = CLLocationCoordinate2DMake(endLat, endLong)
                var marker = GMSMarker(position: position)
                marker.title = "End"
                marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
                marker.map = mapView

                self.dataProvider.fetchDirectionsFrom(coordsArray[coordsArray.count - 3], to: coordsArray[coordsArray.count - 2]) {optionalRoute in
                    if let encodedRoute = optionalRoute {
                        let path = GMSPath(fromEncodedPath: encodedRoute)
                        let line = GMSPolyline(path: path)
                        
                        line.strokeWidth = 4.0
                        line.tappable = true
                        line.map = mapView
                        
                        
                    }
                    
                }
                self.dataProvider.fetchDirectionsFrom(coordsArray[coordsArray.count - 2], to: coordsArray[coordsArray.count - 1]) {optionalRoute in
                    if let encodedRoute = optionalRoute {
                        let path = GMSPath(fromEncodedPath: encodedRoute)
                        let line = GMSPolyline(path: path)
                        
                        line.strokeWidth = 4.0
                        line.tappable = true
                        line.map = mapView
                    }
                }


            }
            }
        }
        

    }
}


