//
// Created by Viktor Belenyesi on 13/10/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import Alamofire
import SwiftyJSON
import vincerp

// http://todolist.parseapp.com/

class LoginService {

    func login(username: String, password: String) -> Rx<Bool> {
        let returnValue = reactive(false)
        let params = [
            "_ApplicationId": "0Oq3tTp9JMvd72LOrGN25PiEq9XgVHCxo57MQbpT",
            "_ClientVersion": "js1.1.15",
            "_InstallationId": "33bf814e-f1c0-8412-ee3e-76f976898599",
            "_JavaScriptKey": "vUFy2o7nFx3eeKVlZneYMPI2MBoxT5LhWNoIWPja",
            "_method": "GET",
            "username": username,
            "password": password,
        ]
        Alamofire.request(.POST, "https://api.parse.com/1/login", parameters:params, encoding: .JSON)
            .responseData { response in
                switch response.result {
                case .Success(let jsonData):
                    let json = JSON(data: jsonData)
                    if let error = json["error"].string {
                        returnValue <- self.error(error)
                    } else {
                        returnValue <- true
                    }
                case .Failure(let error):
                    returnValue <- self.error("\(error)")
                }
            }
        return returnValue
    }
    
    private func error(errorString: String) -> NSError {
        return NSError(domain: "vincerp", code: -1, userInfo: [NSLocalizedFailureReasonErrorKey: errorString])
    }
}
