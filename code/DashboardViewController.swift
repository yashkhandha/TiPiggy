//
//  DashboardViewController.swift
//  sjy-restaurant
//
//  Created by Yash Khandha on 26/10/18.
//  Copyright © 2018 Jialin Yang. All rights reserved.
//

/// importing UIKit
import UIKit
/// importing Firebase
import Firebase
/// instance of DashboardViewController to be used by RestaurantTableViewController to pass the selected restaurant name
var controller: DashboardViewController?

/// This class handles the dashboard view of the application
class DashboardViewController: UIViewController {
    /// To create a reference for the firebase
    var ref: DatabaseReference!
    /// To store the restaurant name
    var restaurantName: String?
    /// Label to display the restaurant name
    @IBOutlet weak var name: UILabel!
    /// Label to display the value of restaurant tip for today
    @IBOutlet weak var tipsForToday: UILabel!
    /// Label to display the value of the restaurant tip for this month
    @IBOutlet weak var tipsForThisMonth: UILabel!
    
    /// Funciton to load values when the view loads for first time
    override func viewDidLoad() {
        super.viewDidLoad()
        /// initialising the controller to this same class
        controller = self
        /// Using UIView animations to give effects to labels
        UIView.animate(withDuration: 2.0, animations: {
            self.name.center = CGPoint(x: 200, y: 50+200)
        }, completion: nil)
        UIView.animate(withDuration: 2.0, animations: {
            self.tipsForToday.center = CGPoint(x: 200, y: 50+200)
        }, completion: nil)
        UIView.animate(withDuration: 2.0, animations: {
            self.tipsForThisMonth.center = CGPoint(x: 200, y: 50+200)
        }, completion: nil)
        
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        /// fetch todays date to be used to reach to the node in the firebase
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todaysDate = formatter.string(from: date)
        print(todaysDate)
        /// To observe for values in the firebase to load the user restaurant details
        ref.child("raspio").child(userId!).observe(.value){snapshot in
            let value = snapshot.value as? NSDictionary
            let object = (value?.allKeys)!
            /// Setting the restaurant name label to retaurant name
            self.restaurantName = object[0] as? String
            self.name.text = self.restaurantName
            /// Also set this value in Gloabal variable to be used by feedback and compare class to track the selected restaurant on the dashboard from the list of users restaurants
            GlobalVariables.GlobalVariables.restuaurantName = self.restaurantName
            /// to load the tip value for today
            self.ref.child("raspio/"+userId!+"/"+self.restaurantName!+"/"+todaysDate).observe(.value){(snapshot) in
                let value = snapshot.value as? NSDictionary
                if value?["Tips"] != nil {
                    let tips = value?["Tips"] as! Int
                    /// set the tip for today label to logged in users selected restaurants todays tip
                    self.tipsForToday.text = "$ " + String(tips)
                }
            }
            /// to load the tip value for this month
            self.ref.child("raspio/compare/"+self.restaurantName!).observe(.value){(snapshot) in
                let value = snapshot.value as? NSDictionary
                if value?["Tips"] != nil {
                    let tips = value?["Tips"] as! Int
                    /// set the tip for today label to logged in users selected restaurants this months tip
                    self.tipsForThisMonth.text = "$ " + String(tips)
                    /// Also set this value in Gloabal variable to be used by feedback and compare class to track the selected restaurant on the dashboard from the list of users restaurants
                    GlobalVariables.GlobalVariables.restaurantTips = value?["Tips"] as? Float
                }
            }
        }
    }
    
    /// This function is used to refresh the view with the selected restaurant in the restaurant list by the user
    ///
    /// - Parameter nameSelected: selected restaurant in the list
    func onRestaurantSelection(nameSelected:String){
                ref = Database.database().reference()
                /// fetch todays date to be used to reach to the node in the firebase
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let todaysDate = formatter.string(from: date)
                print(todaysDate)
                let userId = Auth.auth().currentUser?.uid
                self.name.text = nameSelected
                /// Also set this value in Gloabal variable to be used by feedback and compare class to track the selected restaurant on the dashboard from the list of users restaurants
                GlobalVariables.GlobalVariables.restuaurantName = nameSelected
                /// to load the tip value for today
                self.ref.child("raspio/"+userId!+"/"+nameSelected+"/"+todaysDate).observe(.value){(snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if value?["Tips"] != nil {
                        let tips = value?["Tips"] as! Int
                        self.tipsForToday.text = "$ " + String(tips)
                    }
                }
                /// to load the tip value for this month
                self.ref.child("raspio/compare/"+nameSelected).observe(.value){(snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if value?["Tips"] != nil {
                        let tips = value?["Tips"] as! Int
                        self.tipsForThisMonth.text = "$ " + String(tips)
                        /// Also set this value in Gloabal variable to be used by feedback and compare class to track the selected restaurant on the dashboard from the list of users restaurants
                        GlobalVariables.GlobalVariables.restaurantTips = value?["Tips"] as? Float
                    }
                }
    }
    
    /// Function to handle the new restaurant creation by the user
    ///
    /// - Parameter sender: any
    @IBAction func addRestaurant(_ sender: Any) {
        
        /// Create the alert controller.
        let alert = UIAlertController(title: "Add new restaurant", message: "Enter restaurant name", preferredStyle: .alert)
        
        /// Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        /// Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let userId = Auth.auth().currentUser?.uid
            /// fetch todays date to be used to reach to the node in the firebase
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let todaysDate = formatter.string(from: date)
            /// if the entered field is not blank
            if (textField?.text != ""){
                print("in if")
            /// to create two nodes in the firebase for the new restaurant added
            self.ref.child("raspio" + "/" + userId!).child((textField?.text)! + "/" + todaysDate).setValue(["Bad": 0,"Good":0,"Medium": 0, "Tips":0])
            self.ref.child("raspio/compare").child((textField?.text)!).setValue(["Tips":0])
            }
            else{
                let alertController = UIAlertController(title: "Oops", message: "Restaurant cannot be added without a name. Please try again !", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }))
        /// Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    /// To handle the logout and session end for the user
    ///
    /// - Parameter sender: any
    @IBAction func logOutButton(_ sender: Any) {
        /// to check if the user is logged in
        if Auth.auth().currentUser != nil {
            do {
                /// end the session for the logged in user
                try Auth.auth().signOut()
                /// navigate to the login page
                if let storyboard = self.storyboard {
                    let vc = storyboard.instantiateViewController(withIdentifier: "rootViewController")
                    self.present(vc, animated: false, completion: nil)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
