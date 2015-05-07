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
    var index: Int!
    @IBOutlet weak var btnPreviousRoute: UIButton!
    
    @IBOutlet weak var recordStepper: UIStepper!
    
    @IBOutlet weak var RecordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let NSUD = defaults.stringArrayForKey("names"){
            names = NSUD
            updateStatusHistory(names.count)
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
        if newIndex > names.count {
            newIndex = 1
        } else if newIndex < 1 {
            newIndex = names.count
        }
        sender.value = Double(newIndex)
        updateStatusHistory(newIndex)
    }
    func updateStatusHistory(whichStatus: Int) {
        var newStatusLabel : String!
        newStatusLabel = "Route: " + (names[whichStatus - 1] as! String)
        RecordLabel.text = newStatusLabel
        index = whichStatus - 1
        recordStepper.value = Double(whichStatus)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "previousRoute"){
            var viewController:PreviousRouteViewController = segue.destinationViewController as! PreviousRouteViewController
            viewController.index = index
        }
    
        
    }

}