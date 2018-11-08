# Rover

## Part Two: Storyboard and Table View Controllers

### Storyboard:

Implement the following view hierarchy in the Storyboard. As you create each scene in the storyboard, create the appropriate Cocoa Touch files for each scene. Follow standard file naming conventions.
* The project will have a `UITableViewController` as its initial View Controller embedded in a `UINavigationController`, with a basic cell. This will show a list of the Mars Rovers.
* From the table view cell, create a show segue that will then display a list of sols that contain photos. You can use a Right Detail Cell to show which sol it is, and how many photos were taken on that sol.
* From the table view cell just created, create a show segue to a `UICollectionViewController`. The collection view's cell should have an image view that fills the whole cell. Each cell will display a preview of the sol's photos. Remember to create a Cocoa Touch file for the collection view cell as well.
* From the collection view cell, create a show segue to a new `UIViewController` that will display a larger version of the image on the cell that you segued from, along with labels to display which camera the photo was taken with, which sol it was taken on, and the Earth date it was taken on.

If you haven't already, create Cocoa Touch Files for the views and view controllers you just made in the Storyboard.  Remember to subclass each of your storyboard View Controllers and Views with the proper CocoaTouchClass.

### RoversTableViewController.m:
No other classes will reference properties or methods on the RoversTableViewController and therefore the .h file should be blank.

* In the implementation create a private array called `rovers` that will be the data source for the table view.
* In `ViewDidLoad` call the `fetchAllMarsRoversWithCompletion:` method to fetch the Mars Rovers available to display.  Within the closure use a for loop to loop through the rover names returned in the JSON.  Within this for loop, use each name to call `fetchMissionManifestForRoverNamed` and add the returned `Rover` obect to the `rovers` array to the returned rovers in the completion handler.  Placing a fetch function within a for loop will lead to as many fetches as there are items in the array you are looping through.  This means the app will be waiting on a large number of asyncronys call occuring on different threads.  You will need a way to determine when the last fetch function has returned its data before you move on to reloading the tableView and updating UI elements contingent upon this data retrieval.  In order to do this, you will need to use a Dispatch Group.  Please read Apple's Concurrency Programming Guide for further explanations. The section labeled [Waiting on Groups of Queued Tasks](https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationQueues/OperationQueues.html#//apple_ref/doc/uid/TP40008091-CH102-SW25)  will be especially helpful.
* Implement the `UITableViewDataSource` methods using the `rovers` array..
* Using the prepareForSegue method, pass the appropriate `Rover` object to the destination view controller. Make sure that the destination view controller has a **public** _(thing "landing pad")_ property that serves as a placeholder to put the information to.

### SolsTableViewController:
* Implement the `UITableViewDataSource` methods. (hint: Use the passed rover's solDescriptions)
* Create a custom setter- `setRover:` for the public rover property that checks if the rover being passed through the setter is the same as the current rover ( `_rover` ). If it isn't, then set the current rover to the one passed into the setter, and also reload the tableview. Remember that this setter is where we can do the Objective-C equivalent of a Swift `willSet` and `didSet`.
* In the prepareForSegue, you should pass two things to the destination view controller; the rover that the SolsTableViewController got from the initial view controller's prepareForSegue, and the sol from the cell that the user just tapped on. (Again, make sure to create public properties on the destination view controller to be placeholders for these two things- i.e. two separate "landing pads")

At this point, you should be able to run the app and be able to select a rover from the inital table view controller, and see a list of its sols with a photo count on the table view controller that you segue to. Make sure this works before continuing.

## Part Three: Collection View Controller, Cache, and Swift PhotoDetailViewController

### PhotosCollectionViewController:

### What you'll build. This screen will go trough 4 phases.

![screen shot 2018-09-11 at 5 10 15 pm](https://user-images.githubusercontent.com/23179585/45392642-9d89eb80-b5e5-11e8-9bd8-399427a84de7.png)
![seconde](https://user-images.githubusercontent.com/23179585/45392685-cd38f380-b5e5-11e8-8487-4ffb4164df3b.png)

You will set up the collection view controller to display thumbnail images of each photo taken on the sol passed into it. 

* Create two private properties:
  * An instance of your MarsRoverClient
  * An array of photo references.

* Create a method called `fetchPhotoReferences` that doesn't return anything, but uses the appropriate MarsRoverClient method to fetch the photo references from the API, and sets the photo references property you just made to the photo references returned from the API. Call this method in the `viewDidLoad`

If you haven't already, go to your custom collection view cell file, create the necessary outlet. In the implementation of the cell file, call the `prepareForReuse` function. This will be explained later on, we will come back to it.

The private photo references property will be your data source for the collection view. Implement the required `UICollectionViewDataSource` methods. For now, just set the cell's imageView's image to the placeholder image in the assets folder.

Implement the prepareForSegue method to pass the photo reference from the cell that the user taps on.

### Photo Cache:

Create a new Cocoa Touch file, called PhotoCache (with a prefix) as a subclass of NSObject. We will set up a cache in the device's memory for our photos so we aren't needlessly performing network calls to re-download photos that we've already downloaded from the API. We wil be using a class called `NSCache` to accomplish this. **Take the time to look at the documentation (and elsewhere if you want) to understand how `NSCache` works before moving on.**

* In the header file, create the following:
  * A singleton instance called `sharedCache`
  * A method that returns nothing called `cacheImageData...forIdentifier` that takes in data of type `NSData` and an identifier as an `NSInteger`. This will be used to store the image data returned from the api, and store it so that later on, we can access it whenever we want without having to do another network call.
  * A method called `imageDataForIdentifier` that takes in an identifier as an `NSInteger`, and returns `NSData`. This is the method used to access/fetch the image data in the cache instead of the API.
  

In the .m file:
* Create a private property called 'cache' of type `NSCache`
* Fill out the initializer:
  * Set the private cache you just created to a new instance of `NSCache`
  * Set the cache's name property to `@"com.DevMountain.MarsRover.PhotosCache"` or something similar to uniquely identify the cache.
  
* The `cacheImageData...forIdentifier` method should simply call the appropriate method on the private cache property to set the image data in the cache with the identifier as the key. (Remember that `NSCache` stores data as key-value pairs.)
* Similarly, the `imageDataForIdentifier` method should return the data in the cache, using the identifier as the key.

### Back to the PhotosCollectionViewController:

Now that we have set up the cache to store our images, let's go back to the `PhotosCollectionViewController` in the `cellForItemAtIndexPath` and refactor it so that it will fetch photos, and make use of the photo cache to efficiently store and fetch them from there.

In the `cellForItemAtIndexPath` of the PhotosCollectionViewController:

1. Grab an instance of your `MarsPhoto` model object from your array of photo references.
2. Use the photo you just got and run it through your caches `imageDataForIdentifier` method. Create a property called 'cachedData' to hold the `NSData` it returns.
3. Check if the the cachedData is nil or not. If it isn't nil (there is NSData), initialize a new `UIImage` with the cachedData and set the cell's imageView's image to the new image. If it is nil, set the cell's imageView to the placeholder image in the Assets folder.
4. We don't want to keep the placeholder image on the cell forever, so use the MarsRoverClient class we made to fetch the appropriate image, then set the cell's imageView's image to the returned image.

We need to go back to the PhotoCollectionViewCell and use the `prepareForReuse` function. Its purpose is to do any setup needed before the cell gets reused in the collection view. What you will do is set the cell's image view's image back to the placeholder image.

### Final `prepareForSegue`:

We need to implement the `prepareForSegue` method on the `PhotosCollectionViewController` to pass the instance of our photo model object that from the collection view cell the user taps on.

* Like before, create a public property in the destination view controller (`PhotoDetailViewController`) to place the photo. The destination view controller file should be a **Swift** file.
* Implement the `prepareForSegue` and pass the photo object to the destination view controller

### PhotoDetailViewController

The last thing we need to do is put the correct information in the labels, and the right image into the image view.

* Create a private function that follows the `updateViews` pattern you should be familiar with by now. This function should be called as soon as the photo property on this view controller is set.
* The photo model object doesn't contain the UIImage to be displayed. You will have to get it from the cache, or if it doesn't exist in the cache, you will have to use the `MarsRoverClient` to fetch the image. Handle both cases accordingly.
* Also in the `updateViews` function, make the date that will be put into the dateLabel look good. (hint: Use a `DateFormatter`)

Run the project and make sure everything works.

## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2015. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.

