//
//  CompareTipsViewController.swift
//  sjy-restaurant
//
//  Created by Yash Khandha on 2/11/18.
//  Copyright © 2018 Jialin Yang. All rights reserved.
//

/// importing UIKit
import UIKit
/// Importing firebase
import Firebase

/// Class to handle the selected cell in the list of restaurants in CompareRestaurantViewController
class CompareTipsViewController: UIViewController {

    
    /// to load the image on the screen
    @IBOutlet weak var imageView: UIImageView!
    /// to laod the message text view on screen
    @IBOutlet weak var messageText: UILabel!
    /// to store the details of the restaurant selected to compare with
    var selectedRestaurant : Restaurant?
    /// to store the details of users restaurant selected on the dashboard
    var myRestaurant: Restaurant?
    
    /// Function to load the elements when the view is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        /// fetch the users restaurant details from the global variable which is set on the dashboard
        myRestaurant = Restaurant(name: (GlobalVariables.GlobalVariables.restuaurantName)!,tips: (GlobalVariables.GlobalVariables.restaurantTips)!)
        /// to unwrap the optional value into string
        var unwrappedRestaurantName: String = ""
        if let unwrapped = selectedRestaurant?.name {
            unwrappedRestaurantName = unwrapped
        }
        /// if the users restaurant tip is less than the selected restaurant then display appropriate message
        if (myRestaurant?.tips?.isLess(than: (selectedRestaurant?.tips)!))!{
            messageText.text = "Cmon, buck up. You are behind \(unwrappedRestaurantName) by $\((selectedRestaurant?.tips)! - (myRestaurant?.tips)!)"
            imageView.image = #imageLiteral(resourceName: "down")
        }
        /// else show motivating message
        else{
            messageText.text = "Great. You are ahead of \(unwrappedRestaurantName) by $\((myRestaurant?.tips)! - (selectedRestaurant?.tips)!)"
            imageView.image = #imageLiteral(resourceName: "up ")
        }
    }
    
    /// function to detect over usage of memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
