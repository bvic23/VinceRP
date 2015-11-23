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
        
        // Create a Future which will emit a UIImage array
        let result = reactive([UIImage]())
        
        // Send the search term using the amazing Alamofire framework
        Alamofire.request(.GET, searchTerm.flickrSearchURL(), parameters:nil, encoding: .JSON)
            .responseData { response in
                
                // Process the JSON response in a background queue
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                    
                    switch response.result {
                    case .Success(let jsonData):
                        let json = JSON(data: jsonData)
                        self.processResult(json, result: result)
                    case .Failure(let error):
                        // Send an error using the extension below
                        result <- JSON.error(error.localizedDescription)
                    }
                }
            }
        
        return result
    }
    
    private func processResult(json: JSON, result:Source<[UIImage]>) {
        if let error = json.error() {
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
        
        // Parse the metadata for an image
        let photoID = photoDictionary["id"].string ?? ""
        let farm = photoDictionary["farm"].int ?? 0
        let server = photoDictionary["server"].string ?? ""
        let secret = photoDictionary["secret"].string ?? ""
        
        // Build the url of the image
        let flickrPhotoURL = NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_m.jpg")!
        
        // In a real world application this would be an asnyc call. 
        // But for now we process the JSON response in a background queue to not block the UI
        let imageData = NSData(contentsOfURL: flickrPhotoURL)
        return UIImage(data: imageData!)!
    }
    
}

// Helper extension
extension JSON {
    
    // Is there any error in the JSON answer
    func error() -> NSError? {
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
    
    // Build the full search URL with tokens and everything
    func flickrSearchURL() -> NSURL {
        
        // URL escape the search term
        let escapedTerm = self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        // This is the full search URL with api key and paging
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=74c678b0fd9ff0887a104875925021bf&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        
        return NSURL(string: URLString)!
    }
    
}
