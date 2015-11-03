//
// Created by Viktor Belenyesi on 07/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit
import VinceRP

class FlickrService {
    
    func searchFlickrForTerm(searchTerm: String) -> Hub<[UIImage]> {
        let result = reactive([UIImage]())
        
        Alamofire.request(.GET, searchTerm.flickrSearchURL(), parameters:nil, encoding: .JSON)
            .responseData { response in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                    switch response.result {
                    case .Success(let jsonData):
                        let json = JSON(data: jsonData)
                        self.processResult(json, result: result)
                    case .Failure(let error):
                        result <- JSON.error(error.localizedDescription)
                    }
                }
            }
        
        return result
    }
    
    private func processResult(json: JSON, result:Source<[UIImage]>) {
        if let error = json.isError() {
            result <- error
            return
        }
        
        let photosContainer = json["photos"]
        let photosReceived = photosContainer["photo"].array!
        let flickrPhotos = photosReceived.map(UIImage.jsonToImageMap)
        
        result <- flickrPhotos
    }

}

extension UIImage {
    static func jsonToImageMap(photoDictionary: JSON) -> UIImage {
        let photoID = photoDictionary["id"].string ?? ""
        let farm = photoDictionary["farm"].int ?? 0
        let server = photoDictionary["server"].string ?? ""
        let secret = photoDictionary["secret"].string ?? ""
        
        let flickrPhotoURL = NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_m.jpg")!
        let imageData = NSData(contentsOfURL: flickrPhotoURL)
        return UIImage(data: imageData!)!
    }
}

extension JSON {
    private func isError() -> NSError? {
        if let state = self["stat"].string {
            switch (state) {
            case "ok": return nil
            case "fail": return JSON.error(self["message"].string!)
            default: return JSON.error("Unknown API error")
            }
        }
        return nil
    }
    
    static func error(reason: String) -> NSError {
        return NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:reason])
    }
}

extension String {
    func flickrSearchURL() -> NSURL {
        let escapedTerm = self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=74c678b0fd9ff0887a104875925021bf&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        return NSURL(string: URLString)!
    }
}