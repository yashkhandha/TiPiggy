//
//  Restaurant.swift
//  sjy-restaurant
//
//  Created by Shawn on 2018/10/28.
//  Copyright © 2018年 Jialin Yang. All rights reserved.
//

/// Importing UIKit to handle event driven user interface
import UIKit

/// Restaurant class to handle and capture restaurant details to be accessed and sued by all classes
class Restaurant: NSObject {
    
    /// to store the name of restaurant
    var name: String?
    /// to store the date of restaurant that opens
    var date: String?
    /// to store how many comments of bad service that are provided by customers
    var bad: Int?
    /// to store how many comments of good service that are provided by customers
    var good: Int?
    /// to store how many comments of medium service that are provided by customers
    var medium: Int?
    /// to store how much tips are paid by customers
    var tips: Float?
    
    /// initializer to capture restaurant details
    ///
    /// - Parameters:
    ///   - name: name of restaurant
    ///   - date: date of restaurant that opens
    ///   - bad: how many comments of bad service that are provided by customers
    ///   - medium: how many comments of medium service that are provided by customers
    ///   - good: how many comments of good service that are provided by customers
    ///   - tips: how much tips are paid by customers
    init(name:String, date:String, bad:Int, good:Int, medium:Int, tips:Float){
        self.name = name
        self.date = date
        self.bad = bad
        self.good = good
        self.medium = medium
        self.tips = tips
    }
    
    /// initializer to capture the name and tips of restaurant
    ///
    /// - Parameters:
    ///   - name: name of restaurant
    ///   - date: date of restaurant that opens
    ///   - bad: how many comments of bad service that are provided by customers
    ///   - medium: how many comments of medium service that are provided by customers
    ///   - good: how many comments of good service that are provided by customers
    ///   - tips: how much tips are paid by customers
    init(name:String, tips:Float){
        self.name = name
        self.tips = tips
    }
    
}
