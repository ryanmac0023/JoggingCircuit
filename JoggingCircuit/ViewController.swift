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
    var endingPosition = CLLocationCoordinate2D()
    var endLat: CLLocationDegrees!
    var endLong: CLLocationDegrees!
    var startLat: CLLocationDegrees!
    var startLong: CLLocationDegrees!
    var taps: Int!
 
    
    var coordsArray: Array<CLLocationCoordinate2D> = []
       var test: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(1)
        // Do any additional setup after loading the view, typically from a nib.
        self.locManager.delegate = self
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locManager.requestWhenInUseAuthorization()
        self.locManager.startUpdatingLocation()
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
        println(self.taps)

        if let mylocation = mapView.myLocation {
        } else {
        }
        self.view = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        

        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
            
            if(error != nil){
                println("Error:" + error.localizedDescription)
            }
            
            if(placemarks.count > 0){
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            }
            else{
                println("error with data")
            }
            
        })
            

    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error:" + error.localizedDescription)
    }
    
    func displayLocationInfo(placemark: CLPlacemark){
        self.locManager.stopUpdatingLocation()

        
        
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
            //println(i)
            //println(coordsArray.count)
            if(coordsArray.count - 1 == taps)
            {
                println("here")
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


