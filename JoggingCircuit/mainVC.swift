//
//  mainVC.swift
//  JoggingCircuit
//
//  Created by Eli Price on 5/6/15.
//  Copyright (c) 2015 Eli Price. All rights reserved.
//

import UIKit


class mainVC: UIViewController{
    var names: [AnyObject] = []
    
    @IBOutlet weak var btnPreviousRoute: UIButton!
    
    @IBOutlet weak var recordStepper: UIStepper!
    
    @IBOutlet weak var RecordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let NSUD = defaults.stringArrayForKey("names"){
            names = NSUD
        }
        if (names.count == 0){
            btnPreviousRoute.hidden = true
            recordStepper.hidden = true
            RecordLabel.hidden = true
        }
        else {
            btnPreviousRoute.hidden = false
            recordStepper.hidden = false
            RecordLabel.hidden = false
        }
    }
    
    @IBAction func changedRecordStepper(sender: UIStepper) {
        var newIndex = Int(sender.value)
        if newIndex >= names.count {
            newIndex = 0
        } else if newIndex < 0 {
            newIndex = names.count - 1
        }
        sender.value = Double(newIndex)
        updateStatusHistory(newIndex)
    }
    func updateStatusHistory(whichStatus: Int) {
        if whichStatus > 0 {
            var newStatusLabel = "Route: " + (names[whichStatus] as! String)
            RecordLabel.text = newStatusLabel
            var index = whichStatus - 1
            recordStepper.value = Double(index)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
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
            viewController.currentPosition = currentPosition*/
            // let defaults = NSUserDefaults.standardUserDefaults()
            // defaults.setObject(maps, forKey: "maps")
            
            
        //}
    
        
    }

}