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

 
    
    var coordsArray: Array<CLLocationCoordinate2D> = []
       var test: Int = 0
        var check: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(1)
        // Do any additional setup after loading the view, typically from a nib.
        self.locManager.delegate = self
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locManager.requestWhenInUseAuthorization()
        
        if(startCurrent == true){
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
            var marker = GMSMarker(position: position)
            endingPosition = CLLocationCoordinate2DMake(currentPosition.latitude, currentPosition.longitude)
            marker.title = "Start"
            marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
            marker.map = mapView
            var marker2 = GMSMarker(position: endingPosition)
            marker.title = "End"
            marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
            marker.map = mapView
            
            self.view = mapView
        }
        else if(startCurrent == true && endCurrent == false){
            var camera = GMSCameraPosition.cameraWithLatitude(currentPosition.latitude, longitude: currentPosition.longitude, zoom: 15)
            mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
            mapView.myLocationEnabled = true
            mapView.delegate = self
            var position = CLLocationCoordinate2DMake(currentPosition.latitude,  currentPosition.longitude)
            coordsArray.append(position)
            var marker = GMSMarker(position: position)
            endingPosition = CLLocationCoordinate2DMake(endLat, endLong)
            marker.title = "Start"
            marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
            marker.map = mapView
            var marker2 = GMSMarker(position: endingPosition)
            marker.title = "End"
            marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
            marker.map = mapView
            
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
            var marker = GMSMarker(position: position)
            endingPosition = CLLocationCoordinate2DMake(currentPosition.latitude,  currentPosition.longitude)
            marker.title = "Start"
            marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
            marker.map = mapView
            var marker2 = GMSMarker(position: endingPosition)
            marker.title = "End"
            marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
            marker.map = mapView
            
            self.view = mapView

        }
        else{
            
            var camera = GMSCameraPosition.cameraWithLatitude(startLat, longitude: startLong, zoom: 15)
            mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
            mapView.myLocationEnabled = true
            mapView.delegate = self
            var position = CLLocationCoordinate2DMake(startLat,  startLong)
            coordsArray.append(position)
            var marker = GMSMarker(position: position)
            endingPosition = CLLocationCoordinate2DMake(endLat, endLong)
            marker.title = "Start"
            marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
            marker.map = mapView
            var marker2 = GMSMarker(position: endingPosition)
            marker.title = "End"
            marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
            marker.map = mapView
            
            self.view = mapView
            
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
            }
            else if(check == 1){
                            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
            }
            //self.locManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error:" + error.localizedDescription)
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
                check = 1


            }
            }
        }
        

    }
}


