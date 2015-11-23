//
// Created by Viktor Belenyesi on 05/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import Alamofire
import UIKit
import VinceRP

class LoginViewControler: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func nonEmpty(text: String) -> Bool {
        return text.trim().length > 0
    }
    
    func even(num: Int) -> Bool {
        return num % 2 == 0
    }
    
    func printValues<T:Equatable>(hubs: [Hub<T>]) -> String {
        return hubs.map(*).map { "\($0)" }.joinWithSeparator(", ")
    }
    
    override func viewDidAppear(animated: Bool) {
        let a = reactive(1)
        let b = reactive(2)
        
        let c = `if`(a, b).areAll(even)
            .then { "all numbers are even: \(self.printValues($0)) " }
            .`else` { "some numbers are odd: \(self.printValues($0)) " }
        
        c.onChange(skipInitial: false) {
            print("--->"+$0)
        }
        
        a <- 4
        
        setupLoginButtonUI()
        
        self.loginButton.reactiveEnabled = `if`(emailField.reactiveText, passwordField.reactiveText).areAll(nonEmpty).then(true).`else`(false)

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
        }
        
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
            loginService.login(self.emailField.text!, password: self.passwordField.text!).onChange { _ in
                
                // Send a greeting
                alert <- "Welcome!"
                
                // Mark this handler done
                handler.done()
            }.onError { error in
                
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
