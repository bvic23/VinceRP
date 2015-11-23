//
// Created by Viktor Belenyesi on 05/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit
import VinceRP

class FlickrViewControler: UIViewController {
    
    // Renders the thumbnail images
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Show it till the response arrives
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // If there is no result show this
    @IBOutlet weak var noResultsLabel: UILabel!
    
    // Shows how much time we have left before throttle "timeouts"
    @IBOutlet weak var progressView: UIProgressView!
    
    // Counts how much time we have left before throttle "timeouts"
    private var throttleTimeout:Source<Float> = reactive(0.0)
    
    // This reactive variable serves as a future/promise:
    // - in the one hand we will "write" image arrays into it
    // - in the other hand we observing the changes and react on them
    private let searchResults = reactive([UIImage]())

    override func viewDidLoad() {
        
        // If the results variable changes let's refresh the tableview
        // It acts like a future here
        self.searchResults.onChange { _ in
            self.collectionView.reloadData()
        }
        
        // True if there is an ongoing search
        let searchIsOngoing = reactive(false)
        
        // True if there is any search results
        let hasResult = self.searchResults.map{ $0 != [] }
        
        let searchTerm = self.searchBar.reactiveText
        
        // Hide activity indicator if we are not in a search
        self.activityIndicator.reactiveHidden = searchIsOngoing.not()
        
        // Hide the collection view during the search
        self.collectionView.reactiveHidden = searchIsOngoing
        
        // Update the label on new search
        self.noResultsLabel.reactiveText = searchTerm.map {
            "Search for '\($0)'"
        }
        
        // Update the progress on every tick of the timer
        throttleTimeout.onChange {
            self.progressView.setProgress(fminf($0, 1.0), animated: ($0 != 0.0))
        }
        
        // If we type let's reset the timeout variable and thus the progress
        searchTerm.onChange { _ in
            self.throttleTimeout <- 0.0
        }
        
        // If there is search result or search is happening let's hide the no result label
        self.noResultsLabel.reactiveHidden = definedAs {
            hasResult* || searchIsOngoing*
        }
        
        // If there is no result update the noResultLabel
        hasResult.not().onChange { _ in
            self.noResultsLabel.text = "No results for '\(self.searchBar.reactiveText*)'"
        }
        
        // If no update (new keyboard press) within a 1 second time frame 
        // and there is anything in the searchbar let's propagate the change
        searchTerm.throttle(1.0).ignore("").onChange { searchText in
            
            // Start the search -> it hides the collectionView (line 52) and shows the activity indicator (line 49)
            searchIsOngoing <- true
            
            // Let's start the search and get back the results on the main thread
            let searchResult = FlickrService().searchFlickrForTerm(searchText).dispatchOnMainQueue()
            
            searchResult.onChange { images in
                
                // Hide the activity indicator and show the collection view
                searchIsOngoing <- false
                
                // Trigger a reload on the collectionview
                // It acts like a promise here
                self.searchResults <- images
            }
            
            searchResult.onError {
                
                // Hide the activity indicator and show the collection view
                searchIsOngoing <- false

                // Show the error
                self.showError($0)
            }
        }
        
        // Set the default states
        self.activityIndicator.hidden = true
        self.noResultsLabel.hidden = true
        
        // Start the timer
        timer(0.1) {
            
            // Increment the on every tick
            // Note: this is an operator overloading (CMD + click on the "+=" to check it out)
            self.throttleTimeout += 0.1
        }
        
    }
    
    // Build and show an alert dialog
    private func showError(error: NSError) {
        
        let alertController = UIAlertController(title: "Flickr error",
            message: error.localizedDescription,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

// Make this controller as a datasource for the CollectionView
extension FlickrViewControler: UICollectionViewDataSource {
    
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
