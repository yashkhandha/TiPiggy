//
//  CompareRestaurantTableViewController.swift
//  sjy-restaurant
//
//  Created by Yash Khandha on 1/11/18.
//  Copyright © 2018 Jialin Yang. All rights reserved.
//

import UIKit
import Firebase

class CompareRestaurantTableViewController: UITableViewController,UISearchResultsUpdating {
    
    /// List of restaurant from the database
    private var restaurantList: [Restaurant] = []
    /// Filtered list of restaunrants
    private var filteredRestaurantList: [Restaurant] = []
    /// intitializing the variables to be used in table view cell to assign values
    private let SECTION_RESTAURANTS = 0
    private let SECTION_COUNT = 1
    /// to store firebase reference
    var ref: DatabaseReference!
    
    
    /// method to laod the elements on UI when the view appears first
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        ref = Database.database().reference()
        /// set the restaurant list to filtered list
        self.filteredRestaurantList = self.restaurantList
        /// search related properties
        let searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Restaurant"
        searchController.searchBar.autocapitalizationType = .none
        self.navigationItem.searchController = searchController
    }
    
    /// function to load data on view whenever the view appears
    ///
    /// - Parameter animated: boolean
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        self.ref.child("raspio").child("compare").observe(.value){ snapshot in
            /// Refresh the list after adding new restaurant
            /// empty the list
            self.restaurantList.removeAll()
            /// fetch the values from the firebase
            for resultChild in snapshot.children.allObjects as! [DataSnapshot] {
                let resultObject = resultChild.key
                /// not adding the users seelcted restaunrant name in the compare list by comparing the value set in Global variable on dashboard screen
                if resultObject != GlobalVariables.GlobalVariables.restuaurantName {
                    self.ref.child("raspio/compare").child(resultObject).observe(.value){snapshot in
                        let value = snapshot.value as? NSDictionary
                        let res = Restaurant(name: resultObject, tips: value?["Tips"] as! Float)
                        self.restaurantList.append(res)
                        self.tableView.reloadData()
                    }
                }
                
            }
            
        }
    }

    //function to update the search results
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
            filteredRestaurantList = restaurantList.filter({(r:Restaurant) -> Bool in
                return (r.name?.lowercased().contains(searchText))!
            })
        }
        else {
            filteredRestaurantList = restaurantList;
        }
        tableView.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // MARK: - Table view data source
    
    /// Method gives the number of sections to be displayed on the list
    ///
    /// - Parameter tableView: table view
    /// - Returns: number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    /// Method gives the number of rows in each section defined above
    ///
    /// - Parameters:
    ///   - tableView: table view
    ///   - section: section in the view
    /// - Returns: number of rows to display in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == SECTION_COUNT){
           return 1
        }
        return filteredRestaurantList.count
    }
    
    /// Method to set the values in the cells at each row
    ///
    /// - Parameters:
    ///   - tableView: table view
    ///   - indexPath: integer value of row number
    /// - Returns: cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellResuseIdentifier = "RestaurantCell"
        if indexPath.section == SECTION_COUNT {
            cellResuseIdentifier = "TotalCell"
        }

        /// set the cell with the selected indexpath
        let cell = tableView.dequeueReusableCell(withIdentifier: cellResuseIdentifier, for: indexPath)
        
        /// Configuring the cell
        if indexPath.section == SECTION_RESTAURANTS {
            let restaurantCell = cell as! RestaurantTableViewCell
            //print(restaurantList[indexPath.row].name)
            restaurantCell.restaurantName.text = filteredRestaurantList[indexPath.row].name
        }
        else{
            cell.textLabel?.text = "\(filteredRestaurantList.count) Restaurants"
        }
        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "compareTipsSegue" {
            let controller = (segue.destination as! CompareTipsViewController)
            if let indexPath = tableView.indexPathForSelectedRow{
                controller.selectedRestaurant = self.filteredRestaurantList[indexPath.row]
            }
        }
    }
}
