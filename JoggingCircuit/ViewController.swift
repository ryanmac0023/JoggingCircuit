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
    
    var routeName: String!
    
    let dataProvider = GoogleDataProvider()
    let locManager = CLLocationManager()
    let undoButton = UIButton()
    let startButton = UIButton()
    let playPauseButton = UIButton()
    let backButton = UIButton()
    let resetButton = UIButton()
    let timerLabel = UILabel()
    var mapView = GMSMapView()
    var currentPosition = CLLocationCoordinate2D()
    var endingPosition = CLLocationCoordinate2D()
    var endLat: CLLocationDegrees!
    var endLong: CLLocationDegrees!
    var startLat: CLLocationDegrees!
    var startLong: CLLocationDegrees!
    var stopped: Bool!
    var startCurrent: Bool!
    var endCurrent: Bool!
    var markerStart = GMSMarker()
    var markerEnd = GMSMarker()
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var arrMaps: [AnyObject] = []
    var maps: [AnyObject] = []
    
    var pauseElapsedTime = NSTimeInterval()
    var pastTime = NSTimeInterval()
    
    var workArray: Array<Double> = []
    var coordsArray: Array<CLLocationCoordinate2D> = []
    var markersArray: Array<GMSMarker> = []
    var test: Int = 0
    var check: Int = 0
    var complete: Int = 0
    var blah: Double = 0.0
    
    
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
        let defaults = NSUserDefaults.standardUserDefaults()
        if let scoreFromNSUD = defaults.arrayForKey("maps"){
            maps = scoreFromNSUD
        }
        
        stopped = false
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
        coordsArray.append(endingPosition)
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
        
        startButton.setTitle("Finish Route", forState: .Normal)
        startButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        startButton.frame = CGRectMake(120, 510, 130, 50)
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
        
        
        playPauseButton.setTitle("► ||", forState: .Normal)
        playPauseButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playPauseButton.frame = CGRectMake(15, 450, 100, 50)
        playPauseButton.addTarget(self, action: "playPausedPressed:", forControlEvents: .TouchUpInside)
        playPauseButton.backgroundColor = UIColor(white: 0.667, alpha: 0.5)
        playPauseButton.layer.cornerRadius = 13.0
        
        resetButton.setTitle("Reset", forState: .Normal)
        resetButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        resetButton.frame = CGRectMake(15, 510, 100, 50)
        resetButton.addTarget(self, action: "resetPressed:", forControlEvents: .TouchUpInside)
        resetButton.backgroundColor = UIColor(white: 0.667, alpha: 0.5)
        resetButton.layer.cornerRadius = 13.0
        
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
                check = 2;
                
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error:" + error.localizedDescription)
    }
    
    func backPressed(sender:UIButton!){
        performSegueWithIdentifier("backSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(complete == 1){
            maps.append(workArray)
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(maps, forKey: "maps")
            
        }
        
    }
    func playPausedPressed(sender:UIButton!){
        stopped = !stopped
    }
    
    func resetPressed(sender:UIButton!){
        startTime = NSDate.timeIntervalSinceReferenceDate()
        pauseElapsedTime = 0
        timerLabel.text = "00:00:00"
    }
    
    func startPressed(sender:UIButton!){
        
        if(startButton.titleLabel?.text == "Finish Route"){
            if(coordsArray.count > 2){
                startButton.setTitle("Start", forState: .Normal)
                self.dataProvider.fetchDirectionsFrom(coordsArray[0], to: coordsArray[2]) {optionalRoute in
                    if let encodedRoute = optionalRoute {
                        let path = GMSPath(fromEncodedPath: encodedRoute)
                        let line = GMSPolyline(path: path)
                        
                        
                        line.strokeWidth = 4.0
                        line.tappable = true
                        line.map = self.mapView
                    }
                    
                }
                
                var i = 0
                while(i < coordsArray.count - 1)
                {
                    
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
                }
                
                self.dataProvider.fetchDirectionsFrom(coordsArray[i], to: endingPosition) {optionalRoute in
                    if let encodedRoute = optionalRoute {
                        let path = GMSPath(fromEncodedPath: encodedRoute)
                        let line = GMSPolyline(path: path)
                        
                        
                        line.strokeWidth = 4.0
                        line.tappable = true
                        line.map = self.mapView
                    }
                    
                }
                
                var k = 0
                workArray.removeAll()
                while(k < coordsArray.count){
                    workArray.append(coordsArray[k].latitude)
                    workArray.append(coordsArray[k].longitude)
                    k++
                    
                }
                complete = 1;
            }
            else{
                let alertController = UIAlertController(title: "Error", message:
                    "Please tap the map at least once to generate a route!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
            
        else{
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
            self.view.addSubview(playPauseButton)
            self.view.addSubview(resetButton)
            
            self.locManager.startUpdatingLocation()
            self.check = 1
            
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
        
    }
    
    func updateTime(){
        if (stopped == false){
            var currentTime = NSDate.timeIntervalSinceReferenceDate()
            var elapsedTime: NSTimeInterval = currentTime - startTime - pauseElapsedTime
        
        
            let minutes = UInt8(elapsedTime / 60.0)
            elapsedTime -= (NSTimeInterval(minutes) * 60)
        
            let seconds = UInt8(elapsedTime)
            elapsedTime -= NSTimeInterval(seconds)
        
            let fraction = UInt8(elapsedTime * 100)
        
            let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
            let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
            let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        
            timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
            pastTime = currentTime
        }
        else {
            var currentTime = NSDate.timeIntervalSinceReferenceDate()
            
            pauseElapsedTime += currentTime - pastTime
            pastTime = currentTime
            //startTime = NSDate.timeIntervalSinceReferenceDate() reset
        }
    }
    
    func undoPressed(sender: UIButton!) {
        if (startButton.titleLabel?.text == "Start"){
            complete = 0
            startButton.setTitle("Finish Route", forState: .Normal)
        }
        if(markersArray.count > 2)
        {
            var marker = markersArray[markersArray.count - 1]
            
            self.mapView.clear()
            markersArray.removeLast()
            coordsArray.removeLast()
            var startMarker = markersArray[0]
            startMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
            var endMarker = markersArray[1]
            endMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
            
            startMarker.map = mapView
            endMarker.map = mapView
            
            for (var i = 2; i < markersArray.count - 1; i++)
            {
                var marker = markersArray[i]
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
            }
            if (markersArray.count > 2){
                self.dataProvider.fetchDirectionsFrom(coordsArray[0], to: coordsArray[2]) {optionalRoute in
                    if let encodedRoute = optionalRoute {
                        let path = GMSPath(fromEncodedPath: encodedRoute)
                        let line = GMSPolyline(path: path)
                    
                        line.strokeWidth = 4.0
                        line.tappable = true
                        line.map = self.mapView
                    }
                }
                var lastMarker = markersArray[coordsArray.count - 1]
                lastMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
            
                lastMarker.map = mapView
            }
        }
    }
    
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        
        if (complete != 1)
        {
            coordsArray.append(coordinate)

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
                
                var k = 0
                
                while(k < coordsArray.count){
                    workArray.append(coordsArray[k].latitude)
                    workArray.append(coordsArray[k].longitude)
                    k++
                    
                }
                
            }
            
        }
    }
}


