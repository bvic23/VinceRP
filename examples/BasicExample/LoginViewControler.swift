//
// Created by Viktor Belenyesi on 05/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import Alamofire
import UIKit
import VinceRP

private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

// Let's add a handy extension helps us to validate the email and password field
extension UITextField {
   
    var isValidEmail: Bool {
        return definedAs {
            // Remember * is just a shortcut for getting the current value
            let range = self.reactiveText*.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
            return range != nil
        }*
    }

    var isValidPassword: Bool {
        return definedAs {
            self.reactiveText*.trim().length > 0
        }*
    }
    
}

class LoginViewControler: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(animated: Bool) {
        
        // Make this button blue when enabled and gray when disabled
        setupLoginButtonUI()
        
        // Let's defined reactive version of the enabled property
        self.loginButton.reactiveEnabled = definedAs {
            
            // Whenever email or password field receive's a new value (via typing or copy/paste)
            // this 'reactiveEnabled' will receive a new boolean value
            // which is true if both 'isValidEmail' and 'isValidPassword' emit a true, false otherwise
            self.emailField.isValidEmail &&
            self.passwordField.isValidPassword
        }

        // Default values for username and password
        self.emailField.text = "bvic23@gmail.com"
        self.passwordField.text = "123456"

        // Hide the spinner login command is not executing
        self.activityIndicator.reactiveHidden = self.loginButton.executing.not()
        
        // Hide the button if login is in progress
        self.loginButton.reactiveHidden = self.loginButton.executing
        
        // Create a stream of string value start with an empty string
        let alert = reactive("")
        
        // Watch the changes of alert variable and skip the first value
        alert.onChange(skipInitial: true) {
            
            // Get the current value from the stream which is the message we should show in the alert dialog
            let message = $0
            
            // Create an alert controller
            let alertController = UIAlertController(title: "Login Result",
                message: message,
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Add a close button
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            
            // Show it
            self.presentViewController(alertController, animated: true, completion: nil)
        }.dispatchOnMainQueue()
        
        // Add a clickhandler
        self.loginButton.clickHandler = definedAs { handler in // Because this block can contain any kind of threading
            // this handler is for marking this clickhandler "done".
            // Why this is necessary? Because I like the "executing" property of RACCommand and 
            // the calling of "done" sets "executing" to false.
            // If you have any better idea how to do this please send a PR or create an issue
            
            
            // Close the keyboard
            self.emailField.resignFirstResponder()
            self.passwordField.resignFirstResponder()
            
            // Create a loginservice
            let loginService = LoginService()
            
            // Initiate the login process
            let login = loginService.login(self.emailField.text!, password: self.passwordField.text!)
            login.onChange {
                
                if $0 {
                    // Send a greeting
                    alert <- "Welcome!"
                } else {
                    // Send a greeting
                    alert <- "Login failed, username or password is invalid!"
                }
                
                // Mark this handler done
                handler.done()
            }
            login.onError { error in
                
                // Send an error
                alert <- "Login failed with error: \(error)"
                handler.done()
            }
        }
        
    }
    
    func setupLoginButtonUI() {
        self.loginButton.setBackgroundImage(UIImage.imageWithColor(UIColor.blueColor()), forState: .Normal)
        self.loginButton.setBackgroundImage(UIImage.imageWithColor(UIColor.grayColor()), forState: .Disabled)
        self.loginButton.layer.cornerRadius = 3.0
        self.loginButton.layer.masksToBounds = true
    }
    
}
