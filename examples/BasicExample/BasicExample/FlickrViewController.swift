//
// Created by Viktor Belenyesi on 05/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit
import vincerp

class FlickrViewControler: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    private var throttleTimeout:Source<Float> = reactive(0.0)
    private let searchResults = reactive([UIImage]())

    override func viewDidLoad() {
        self.searchResults.onChange { _ in
            self.collectionView.reloadData()
        }
        
        let searchIsOngoing = reactive(false)
        let hasResult = self.searchResults.map{ $0 != [] }
        let searchTerm = self.searchBar.reactiveText
        
        self.activityIndicator.reactiveHidden = searchIsOngoing.not()
        self.collectionView.reactiveHidden = searchIsOngoing
        self.noResultsLabel.reactiveText = searchTerm.map {
            "Search for '\($0)'"
        }
        
        throttleTimeout.onChange {
            self.progressView.setProgress(fminf($0, 1.0), animated: ($0 != 0.0))
        }
        
        searchTerm.onChange { _ in
            self.throttleTimeout <- 0.0
        }
        
        self.noResultsLabel.reactiveHidden = definedAs {
            hasResult* || searchIsOngoing*
        }
        
        hasResult.not().onChange { _ in
            self.noResultsLabel.text = "No results for '\(self.searchBar.reactiveText*)'"
        }
        
        searchTerm.throttle(1.0).ignore("").onChange { searchText in
            searchIsOngoing <- true
            let searchResult = FlickrService().searchFlickrForTerm(searchText).dispatchOnMainThread()
            
            searchResult.onChange {
                searchIsOngoing <- false
                self.searchResults <- $0
            }
            
            searchResult.onError {
                searchIsOngoing <- false
                self.showError($0)
            }
        }
        
        self.activityIndicator.hidden = true
        self.noResultsLabel.hidden = true
        
        timer(0.1) {
            self.throttleTimeout += 0.1
        }
    }
    
    private func showError(error: NSError) {
        let alertController = UIAlertController(title: "Flickr error",
            message: error.localizedDescription,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension FlickrViewControler : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults*.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrCell", forIndexPath: indexPath) as! FlickrPhotoCell
        let flickrPhoto = searchResults.value()[indexPath.row]
        cell.imageView.image = flickrPhoto
        return cell
    }
}
