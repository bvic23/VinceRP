//
// Created by Viktor Belenyesi on 13/10/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import Alamofire
import SwiftyJSON
import VinceRP

// This example service uses a simple login/password service:
// http://todolist.parseapp.com/

class LoginService {

    func login(username: String, password: String) -> Hub<Bool> {
        
        // Let's define a stream of bool values which represents the result of the login
        // We'll return this variable as a promise at the end of this method
        let returnValue = reactive(false)
        
        // The necessary parameters for the login, username / password are the dynamic ones
        let params = [
            "_ApplicationId": "0Oq3tTp9JMvd72LOrGN25PiEq9XgVHCxo57MQbpT",
            "_ClientVersion": "js1.1.15",
            "_InstallationId": "33bf814e-f1c0-8412-ee3e-76f976898599",
            "_JavaScriptKey": "vUFy2o7nFx3eeKVlZneYMPI2MBoxT5LhWNoIWPja",
            "_method": "GET",
            "username": username,
            "password": password,
        ]
        
        // Send the request
        Alamofire.request(.POST, "https://api.parse.com/1/login", parameters:params, encoding: .JSON)
            .responseData { response in
                
                // Parse the response
                switch response.result {
                case .Success(let jsonData):
                    let json = JSON(data: jsonData)
                    
                    // If there is an error field...
                    if let _ = json["error"].string {
                        
                        // ... we send a false here
                        returnValue <- false
                    } else {
                        
                        // ... we send a true
                        returnValue <- true
                    }
                
                // If it fails...
                case .Failure(let error):
                    // ... we send an error
                    returnValue <- self.error("\(error)")
                }
            }
        
        // We return with our "future like" reactive variable
        return returnValue
    }
    
    private func error(errorString: String) -> NSError {
        
        return NSError(domain: "VinceRP", code: -1, userInfo: [NSLocalizedFailureReasonErrorKey: errorString])
        
    }
    
}
