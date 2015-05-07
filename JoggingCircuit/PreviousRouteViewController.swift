//
//  PreviousRouteViewController.swift
//  JoggingCircuit
//
//  Created by Ryan McCollam on 4/27/15.
//  Copyright (c) 2015 Ryan McCollam. All rights reserved.
//

import Foundation



class PreviousRouteViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    //var workArray: [AnyObject] = []
    var index: Int!
    let dataProvider = GoogleDataProvider()
    let locManager = CLLocationManager()
    let undoButton = UIButton()
    let startButton = UIButton()
    let resetButton = UIButton()
    let playPauseButton = UIButton()
    let backButton = UIButton()
    let timerLabel = UILabel()
    var mapView = GMSMapView()
    var currentPosition = CLLocationCoordinate2D()
    var endingPosition = CLLocationCoordinate2D()
    var endLat: CLLocationDegrees!
    var endLong: CLLocationDegrees!
    var startLat: CLLocationDegrees!
    var startLong: CLLocationDegrees!
    var asdf: Double!
    var taps: Int!
    var startCurrent: Bool!
    var endCurrent: Bool!
    var markerStart = GMSMarker()
    var markerEnd = GMSMarker()
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var maps: [AnyObject] = []
    var workArray: Array<Double> = []
    var pauseElapsedTime = NSTimeInterval()
    var stopped: Bool!
    var pastTime = NSTimeInterval()



    
    
    
    
    var coordsArray: Array<CLLocationCoordinate2D> = []
    var markersArray: Array<GMSMarker> = []
    var test: Int = 0
    var check: Int = 0
    var complete: Int = 0
    var blah: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(1)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let scoreFromNSUD = defaults.arrayForKey("maps"){
            maps = scoreFromNSUD
        }
        workArray = maps[index] as! Array<Double>


        // Do any additional setup after loading the view, typically from a nib.
       self.locManager.delegate = self
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locManager.requestWhenInUseAuthorization()

                

        startLat = workArray[0]
        startLong = workArray[1]
        endLat = workArray[2]
        endLong = workArray[3]
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



        
        self.dataProvider.fetchDirectionsFrom(CLLocationCoordinate2DMake(workArray[0], workArray[1]), to:             CLLocationCoordinate2DMake(workArray[4], workArray[5])) {optionalRoute in
            if let encodedRoute = optionalRoute {
                let path = GMSPath(fromEncodedPath: encodedRoute)
                let line = GMSPolyline(path: path)
                
                line.strokeWidth = 4.0
                line.tappable = true
                line.map = self.mapView
            }
            
        }
        
        var i = 6

        while(i < workArray.count - 1)
        {
            var lat1 = workArray[i - 2]
            var long1 = workArray[i - 1]
            var lat2 = workArray[i]
            var long2 = workArray[i+1]
            
            
            self.dataProvider.fetchDirectionsFrom(CLLocationCoordinate2DMake(lat1, long1), to:             CLLocationCoordinate2DMake(lat2, long2)) {optionalRoute in
                if let encodedRoute = optionalRoute {
                    let path = GMSPath(fromEncodedPath: encodedRoute)
                    let line = GMSPolyline(path: path)
                    
                    line.strokeWidth = 4.0
                    line.tappable = true
                    line.map = self.mapView
                }
                
            }
            i = i + 2

        }
        self.dataProvider.fetchDirectionsFrom(CLLocationCoordinate2DMake(workArray[i-2], workArray[i-1]), to:             CLLocationCoordinate2DMake(workArray[2], workArray[3])) {optionalRoute in
            if let encodedRoute = optionalRoute {
                let path = GMSPath(fromEncodedPath: encodedRoute)
                let line = GMSPolyline(path: path)
                
                line.strokeWidth = 4.0
                line.tappable = true
                line.map = self.mapView
            }
            
        }


    
    
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
        performSegueWithIdentifier("back2", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(complete == 1){
            // maps.append(coordsArray)
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(workArray, forKey: "maps")
            
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
        self.view.addSubview(resetButton)
        self.view.addSubview(playPauseButton)
        check = 1
        timerLabel.frame = CGRectMake(120, 510, 100, 50)
        timerLabel.font = UIFont(name: timerLabel.font.fontName, size: 20)
        self.view.addSubview(timerLabel)
        

        
        startButton.hidden = true
        undoButton.hidden = true
        
        self.locManager.startUpdatingLocation()
        self.check = 1
        
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
        
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
}