//
//  FeedBackDetailsViewController.swift
//  sjy-restaurant
//
//  Created by Shawn on 2018/11/2.
//  Copyright © 2018年 Jialin Yang. All rights reserved.
//

import UIKit

class FeedBackDetailsViewController: UIViewController {

    /// Display the amount of bad review in restaurant
    @IBOutlet weak var badTextField: UILabel!
    /// Display the amount of medium review in restaurant
    @IBOutlet weak var mediumTextField: UILabel!
    /// Display the amount of good review in restaurant
    @IBOutlet weak var goodTextField: UILabel!
    /// Store the amount of good review in restaurant
    var good: Int?
    /// Store the amount of medium review in restaurant
    var medium: Int?
    /// Store the amount of bad review in restaurant
    var bad: Int?
    
    /// This function is used to Call the controller's view that is loaded into memory and set the value of label
    override func viewDidLoad() {
        super.viewDidLoad()
        goodTextField.text = "\(good ?? 0)"
        mediumTextField.text = "\(medium ?? 0)"
        badTextField.text = "\(bad ?? 0)"
    }

    /// This function is sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
