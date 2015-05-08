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
    
    @IBOutlet weak var btnCreateRoute: UIButton!
    
    
    @IBOutlet weak var recordStepper: UIStepper!
    
    @IBOutlet weak var RecordLabel: UILabel!
    
    @IBOutlet weak var recordNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Home"

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "running-path_00006124.jpg")!)
        btnCreateRoute.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.3)
        btnCreateRoute.tintColor = UIColor.redColor()
        btnCreateRoute.layer.cornerRadius = 13.0
        btnPreviousRoute.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.3)
        btnPreviousRoute.tintColor = UIColor.redColor()
        btnPreviousRoute.layer.cornerRadius = 13.0
        recordStepper.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.3)
        recordStepper.tintColor = UIColor.redColor()


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
        newStatusLabel = "Route: \(whichStatus) of \(names.count) \n"
        RecordLabel.text = newStatusLabel
        recordNameLabel.text = (names[whichStatus - 1] as! String)
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