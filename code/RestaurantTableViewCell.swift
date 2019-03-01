//
//  RestaurantTableViewCell.swift
//  sjy-restaurant
//
//  Created by Shawn on 2018/10/29.
//  Copyright © 2018年 Jialin Yang. All rights reserved.
//

import UIKit


/// class to handle the table view cell for restaurant name in the table view controller
class RestaurantTableViewCell: UITableViewCell {

    /// restaurant name to display in the list
    @IBOutlet weak var restaurantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
