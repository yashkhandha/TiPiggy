//
//  LoginViewController.swift
//  sjy-restaurant
//
//  Created by Shawn on 2018/10/26.
//  Copyright © 2018年 Jialin Yang. All rights reserved.
//

/// importing UIKit
import UIKit
/// Importing firebase
import Firebase

/// Class to handle the user login
class LoginViewController: UIViewController {

      /// Display the text field of email
    @IBOutlet weak var inputEmailTextField: UITextField!
      /// Display the text field of password
    @IBOutlet weak var inputPasswordTextField: UITextField!
    
    /// This function is used to Call the controller's view that is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Make password invisible
        inputPasswordTextField.isSecureTextEntry = true
    }
    
    /// This function is sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// This function is used to login to application for cuurent user
    ///
    /// - Parameters:
    ///   - sender: click on button from any
    @IBAction func onClickSignIn(_ sender: Any) {
        
        /// Check the text field of email and password is empty
        if self.inputEmailTextField.text == "" || self.inputPasswordTextField.text == "" {
            
            /// Alert to tell the user that there was an error because they didn't fill anything in the textfields
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            ///  Check user email and password in database
            Auth.auth().signIn(withEmail: self.inputEmailTextField.text!, password: self.inputPasswordTextField.text!) { (user, error) in
                if error == nil {
                    
                    /// Go to dashboard of application
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextviewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as UIViewController
                    self.present(nextviewController,animated: true, completion: nil)
                } else {
                    
                    /// Tell the user that there is an error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    /// This function is used to reset the password if user forget their password
    ///
    /// - Parameters:
    ///   - sender: click on button from any
    @IBAction func onClickResetPassword(_ sender: Any) {
        
        /// Check the text field of email is empty
        if self.inputEmailTextField.text == "" {
            
            /// Set an alert information to user if he/she provides emply content on text field
            let alertController = UIAlertController(title: "Error!", message: "Please enter your email.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            
            /// Send the link of resetting password to user's email address
            Auth.auth().sendPasswordReset(withEmail: self.inputEmailTextField.text!, completion: { (error) in
                var title = ""
                var message = ""
                
                /// Check whether the email address is existing on database and generate messages
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.inputEmailTextField.text = ""
                }
                /// Set an alert information to user based on the email address they provided
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}
