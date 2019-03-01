//
//  FeedbackTableViewController.swift
//  sjy-restaurant
//
//  Created by Shawn on 2018/10/28.
//  Copyright © 2018年 Jialin Yang. All rights reserved.
//

import UIKit
import Firebase

class FeedbackTableViewController: UITableViewController {

    // Store firebase reference
    var ref: DatabaseReference!
    /// List of restaurant from the database
    private var restaurantList = [Restaurant]()
    /// Store coverted list of restaurant from the database
    private var convertList = [Restaurant]()
    /// Check whether sort function is used or not
    private var flag = false
    
    
    /// This function is used to sort table based on tips
    ///
    /// - Parameters:
    ///   - sender: click on button from any
    @IBAction func OnClickSort(_ sender: Any) {
        
        /// Chech the status of button, false means sorting by date and true means sorting by tips
        if (flag == false) {
            
            /// Sort by lowest tips
            self.convertList = self.convertList.sorted(by: { ($0.tips?.isLess(than: $1.tips!))!})
            
            /// Reverse sorting list to highest tips
            self.convertList = self.convertList.reversed()
            
            /// Update the tableView
            tableView.reloadData();
            flag = true
            
            /// Reset the title of button
            (sender as AnyObject).setTitle("Reset", for: [])
        } else {
            
            /// Sort by latest date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            self.convertList = self.convertList.sorted(by: { (dateFormatter.date(from: ($0.date)!))?.compare(dateFormatter.date(from: ($1.date)!)!) == .orderedDescending })
            tableView.reloadData()
            flag = false
            
            /// Reset the title of button
            (sender as AnyObject).setTitle("Sort By Tips", for: [])
        }
    }
    
    /// This function is used to Call the controller's view that is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Get reference from database
        ref = Database.database().reference()
    }

    /// This function is sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// This function is initialized the data from database
    func initializeData() {
        
        /// Get user ID that currently login
        let userId = Auth.auth().currentUser?.uid
        
        /// Remove all data from restaurant list
        restaurantList.removeAll()
        
        /// Get all data of current user from database
        ref.child("raspio").child(userId!).observe(.value){ snapshot in
            
            /// Get restaurant that user currently have
            let restaurantName = GlobalVariables.GlobalVariables.restuaurantName
            
            /// Fetch all data of restaurant from database
            self.ref.child("raspio").child(userId!).child(restaurantName!).observe(.value){ data in
                for dateChild in data.children.allObjects as! [DataSnapshot] {
                    let dateObject = dateChild.value as? [String: AnyObject]
                    let date = dateChild.key
                    let good = dateObject?["Good"] as! Int
                    let bad = dateObject?["Bad"] as! Int
                    let medium = dateObject?["Medium"] as! Int
                    let tips =  (dateObject?["Tips"] as! NSNumber).floatValue
                    
                    /// Create a new object to save date
                    let restaurantService = Restaurant(name: restaurantName!, date: date, bad: bad, good: good, medium: medium, tips: tips)
                    self.restaurantList.append(restaurantService)
                    
                    /// Sort data by date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    self.convertList = self.restaurantList.sorted(by: { (dateFormatter.date(from: ($0.date)!))?.compare(dateFormatter.date(from: ($1.date)!)!) == .orderedDescending })
                    
                    /// Update the tableView
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    /// This function is used to initialize the data and update on the view
    ///
    /// - Parameters:
    ///   - animaetd: pass along to its superclass the Bool value that it received
    override func viewWillAppear(_ animated: Bool) {
        initializeData()
    }
    
    /// This function is used to return the number of rows in a given section of a table view
    ///
    /// - Parameters:
    ///   - tableView: the table view of UI
    ///   - section: the number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convertList.count
    }

   
    /// This function is used to ask the data source for a cell to insert in a particular location of the table view.
    ///
    /// - Parameters:
    ///   - tableView: the table view of UI
    ///   - indexPath: row number selected in section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Let cell resuable based on identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath)
        let restaurantArray = self.convertList[indexPath.row]
        let dateFormatter = DateFormatter()
        
        /// Convert data of date to exact date format
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        /// Change data type from String to Date
        let date = dateFormatter.date(from: restaurantArray.date!)
        
        /// Convert all date from required date format
        dateFormatter.dateFormat = "dd-MMM-YYYY"
        let goodDate = dateFormatter.string(from: date!)
        cell.textLabel?.text = "\(goodDate)    Tips: \(restaurantArray.tips ?? 0.0)"
        return cell
    }
    
    /// This function is used to do a little preparation before navigation to FeedBackDetails page
    ///
    /// - Parameters:
    ///   - segue: the storyBoard segue of UI
    ///   - sender: sender from any
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using FeedBackDetailsViewController
        if segue.identifier == "GoToDetail" {
            let controller = (segue.destination as! FeedBackDetailsViewController)
            
            // Pass the selected values to the new view controller.
            if let indexPath = tableView.indexPathForSelectedRow{
                controller.good = self.restaurantList[indexPath.row].good
                controller.medium = self.restaurantList[indexPath.row].medium
                controller.bad = self.restaurantList[indexPath.row].bad
            }
        }
    }
}
