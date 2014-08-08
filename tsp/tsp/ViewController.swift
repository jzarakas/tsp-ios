//
//  ViewController.swift
//  tsp
//
//  Created by James Zarakas on 8/8/14.
//  Copyright (c) 2014 Labs FunWare. All rights reserved.
//

import UIKit


//urinal pin 1
//toilet pin 2

class ViewController: UIViewController {
                            
    @IBOutlet weak var toiletView: UIView!
    @IBOutlet weak var toiletLabel: UILabel!

    @IBOutlet weak var urinalView: UIView!
    
    @IBOutlet weak var urinalLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refresh()
        var timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("refresh"), userInfo: nil, repeats: true)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {
        NSLog("refreshing/..")
        let url = "https://agent.electricimp.com/vfR-e76MntZb"
        var request = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            
            if jsonResult {
                dispatch_async(dispatch_get_main_queue(), {

                NSLog("json: %@, %@", jsonResult.objectForKey("pin1") as String, jsonResult.objectForKey("pin2") as String)
                let toilet = jsonResult.objectForKey("pin2") as String
                let urinal = jsonResult.objectForKey("pin1") as String
                
                if (toilet.toInt() > 30000) {
                    //toilet is free
                    
                    self.toiletLabel.text = "VACANT (" + toilet + ")"
                    self.toiletView.backgroundColor = UIColor.greenColor()
                } else {
                    //toilet is occupied
                    self.toiletLabel.text = "OCCUPIED (" + toilet + ")"
                    self.toiletView.backgroundColor = UIColor.redColor()
                }
                
                if (urinal.toInt() > 42000) {
                    //urinal is free
                    self.urinalLabel.text = "VACANT (" + urinal + ")"
                    self.urinalView.backgroundColor = UIColor.greenColor()
                } else {
                    //urinal is occupied
                    self.urinalLabel.text = "OCCUPIED (" + urinal + ")"
                    self.urinalView.backgroundColor = UIColor.redColor()
                }
                })
                
                
            } else {
                // couldn't load JSON, look at error
            }
            
            
            
        })
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        refresh()
    }

}

