//
//  RestaurantTableViewController.swift
//  sjy-restaurant
//
//  Created by Yash Khandha on 2/11/18.
//  Copyright © 2018 Jialin Yang. All rights reserved.
//

/// Importing UIKit
import UIKit
/// Importing Firebase
import Firebase

/// This class is used to handle the table view controller to display the users restaurants
class RestaurantTableViewController: UITableViewController {
    /// To store the reference for the firebase
    var ref: DatabaseReference!
    /// To store all the restaurants of the logged in user
    var restaurantList = [String]()
    
    /// function to load elements whent the view gets loaded at first
    override func viewDidLoad() {
        super.viewDidLoad()
        /// create a reference with the firebase
        ref = Database.database().reference()
        ///fetch the user id of the logged in user to use it in the child node for the firebase
        let userId = Auth.auth().currentUser?.uid
        /// observing values at this node if any new user restaunrant is created
        ref.child("raspio").child(userId!).observe(.value){ snapshot in
            self.restaurantList.removeAll()
            /// looping in the list of restaurants to load in the list
            for resultChild in snapshot.children.allObjects as! [DataSnapshot] {
                let restaurantName = resultChild.key
                print(restaurantName)
                self.restaurantList.append(restaurantName)
            }
            self.tableView.reloadData()
        }
    }
    /// function to handle errors if memory usage is more
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// function to get the number of elements to show in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurantList.count
    }
    
    /// function to handle the data to be displayed on the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantList", for: indexPath)
        cell.textLabel?.text = restaurantList[indexPath.row]
        return cell
    }
    
    /// This function is use dto detect any cell selection in the table view
    ///
    /// - Parameters:
    ///   - tableView: table view
    ///   - indexPath: row number selected in section
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controller?.onRestaurantSelection(nameSelected: self.restaurantList[indexPath.row])
        self.tabBarController?.selectedIndex = 0
    }
}
