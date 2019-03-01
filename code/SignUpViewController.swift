//
//  SignUpViewController.swift
//  sjy-restaurant
//
//  Created by Shawn on 2018/10/24.
//  Copyright © 2018年 Jialin Yang. All rights reserved.
//

/// importing UIKit
import UIKit
/// Importing firebase
import Firebase

/// Class to handle the user registration
class SignUpViewController: UIViewController {
    
    /// Display the text field of email
    @IBOutlet weak var inputEmail: UITextField!
    /// Display the text field of password
    @IBOutlet weak var inputPassword: UITextField!
    /// Display the text field of confirmPassword
    @IBOutlet weak var confirmPassword: UITextField!
    /// Display the text field of name
    @IBOutlet weak var inputName: UITextField!
    // Store firebase reference
    var ref: DatabaseReference!
    
    /// This function is used to Call the controller's view that is loaded into memory.
    override func viewDidLoad() {
        ref = Database.database().reference()
        
        /// Make password and confirm password invisible
        inputPassword.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
        super.viewDidLoad()
    }
    
    /// This function is sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// This function is used to create a new account based on the information that user has entered
    ///
    /// - Parameters:
    ///   - sender: click on button from any
    @IBAction func onClickSignUp(_ sender: Any) {
        
        /// Check whether the password that user has input is same as confirmPassword
        if confirmPassword.text != inputPassword.text{
            
            /// Set an alert information to user if he/she provides different password for confirm password
            let alertController = UIAlertController(title: "Error", message: "Password and Confirm password do not match. Please try again !", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
        /// Check the if the text fields are empty, give and alert message
        if inputEmail.text == "" || inputPassword.text == "" || confirmPassword.text == "" || inputName.text == ""{
            /// Set an alert information to user if he/she provides emply content on text field
            let alertController = UIAlertController(title: "Error", message: "Please enter all the fields", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            ///  create user with email and password provided. Error if the email already exist in the database
            Auth.auth().createUser(withEmail: inputEmail.text!, password: inputPassword.text!) { (user, error) in
                if error == nil {
                    /// Sign in to application using current email and password in order to navigate to dashboard on sign up
                    Auth.auth().signIn(withEmail: self.inputEmail.text!, password: self.inputPassword.text!) { (user, error) in
                    let userId = Auth.auth().currentUser?.uid
                        
                        /// Create the user data in database for creating the node
                        /// fetch todays date in the required format to be used to input data in firebase
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        let todaysDate = formatter.string(from: date)
                        /// create 2 nodes for the new registered user in the firebase
                        self.ref.child("raspio" + "/" + userId!).child(self.inputName.text! + "/" + todaysDate).setValue(["Bad": 0,"Good":0,"Medium": 0, "Tips":0])
                        self.ref.child("raspio/compare").child((self.inputName.text!)).setValue(["Tips":0])
                        
                        /// Go to dashboard of application
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(vc!, animated: true, completion: nil)
                    }
                } else {
                        /// Set an alert information to user if the email exist in the database
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
