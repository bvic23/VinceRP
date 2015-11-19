//
// Created by Viktor Belenyesi on 05/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import Alamofire
import UIKit
import VinceRP

private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

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
        
        c.onChange(false) {
            print("--->"+$0)
        }
        
        a <- 4
        
        setupLoginButtonUI()
        
        self.loginButton.reactiveEnabled = `if`(emailField.reactiveText, passwordField.reactiveText).areAll(nonEmpty).then(true).`else`(false)

        self.emailField.text = "bvic23@gmail.com"
        self.passwordField.text = "123456"

        self.activityIndicator.reactiveHidden = self.loginButton.executing.not()
        self.loginButton.reactiveHidden = self.loginButton.executing
        
        let alert = reactive("")
        alert.onChange(true) {
            let message = $0
            let alertController = UIAlertController(title: "Login Result",
                message: message,
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        self.loginButton.clickHandler = definedAs { i in
            self.emailField.resignFirstResponder()
            self.passwordField.resignFirstResponder()
            let loginService = LoginService()
            loginService.login(self.emailField.text!, password: self.passwordField.text!).onChange { _ in
                alert <- "Login was successfull!"
                i.done()
            }.onError { error in
                alert <- "Login failed with error: \(error)"
                i.done()
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
