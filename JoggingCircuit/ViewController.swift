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
        
        
        if(startCurrent == true && endCurrent == true){
            var camera = GMSCameraPosition.cameraWithLatitude(currentPosition.latitude, longitude: currentPosition.longitude, zoom: 15)
            mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
            mapView.myLocationEnabled = true
            mapView.delegate = self
            var position = CLLocationCoordinate2DMake(currentPosition.latitude,  currentPosition.longitude)
            coordsArray.append(position)
            markerStart = GMSMarker(position: position)
            endingPosition = CLLocationCoordinate2DMake(currentPosition.latitude, currentPosition.longitude)
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
        }
        else if(startCurrent == true && endCurrent == false){
            println("test")
            var camera = GMSCameraPosition.cameraWithLatitude(currentPosition.latitude, longitude: currentPosition.longitude, zoom: 15)
            mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
            mapView.myLocationEnabled = true
            mapView.delegate = self
            var position = CLLocationCoordinate2DMake(currentPosition.latitude,  currentPosition.longitude)
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
        }
        else if(startCurrent == false && endCurrent == true)
        {
            var camera = GMSCameraPosition.cameraWithLatitude(startLat, longitude: startLong, zoom: 15)
            mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
            mapView.myLocationEnabled = true
            mapView.delegate = self
            var position = CLLocationCoordinate2DMake(startLat,  startLong)
            coordsArray.append(position)
            markerStart = GMSMarker(position: position)
            endingPosition = CLLocationCoordinate2DMake(currentPosition.latitude,  currentPosition.longitude)
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

        }
        else{
            
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
            
        }
        
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
            println("here")

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
    
    func startPressed(sender:UIButton!){
        
        self.locManager.startUpdatingLocation()
        self.check = 1

    
    }
    
    func undoPressed(sender: UIButton!) {

        if(markersArray.count > 2)
        {
        println("here")
        var marker = markersArray[markersArray.count - 1]
        
        self.mapView.clear()
        marker.map = nil;
        markersArray.removeLast()
        coordsArray.removeLast()
            
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
                //check = 1


            }
            }
        }
        

    }
}


