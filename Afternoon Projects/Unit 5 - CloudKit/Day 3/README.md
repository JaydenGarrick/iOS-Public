# Continuum

#### Part Two - Apple View Controllers, Search Controller, Container Views

* implement search using the system search controller
* use the image picker controller and activity controller
* use container views to abstract shared functionality into a single view controller

## Part Two - UISearchBarDelegate, UIImagePickerController

* implement search using UISearchBarDelegate
* use the image picker controller and activity controller

Add and implement search functionality to the search view. Implement the Image Picker Controller on the Add Post scene.

### Search Controller

Build functionality that will allow the user to search for posts with comments that have specific text in them. For example, if a user creates a `Post` with a photo of a waterfall, and there are comments that mention the waterfall, the user should be able to search the Timeline view for the term 'water' and filter down to that post (and any others with water in the comments).

#### Update the Model

Add a `SearchableRecord` protocol that requires a `matchesSearchTerm` function. Update the `Post` and `Comment` objects to conform to the protocol.

1. Add a new `SearchableRecord.swift` file.
2. Define a `SearchableRecord` protocol with a required `matches(searchTerm: String)` function that takes a `searchTerm` parameter as a `String` and returns a `Bool`.

Consider how each model object will match to a specific search term. What searchable text is there on a `Comment`? What searchable text is there on a `Post`?

3. Update the `Comment` class to conform to the `SearchableRecord` protocol. Return `true` if `text` contains the search term, otherwise return `false`.
4. Update the `Post` class to conform to the `SearchableRecord` protocol. Return `true` if any of the `Post` `comments` match, otherwise return `false`.

You can use a Playground to test your `SearchableRecord` and `matches(searchTerm: String)` functionality and understand what you are implementing.

#### PostListTableViewController: UISearchBar & UISearchBarDelegate

Use a UISearchbar to allow a user to search through different posts for the given search text.  This will require the use of the of the `SearchableRecord` protocol and the each models implentation of the `matches(searchTerm: String)` function.  The `PostListTableViewController` will need to conform to the `UISearchBarDelegate` and implement the appropriate delegate method.

1. Add a `UISearchBar` to the headerView of the  `PostListTableViewController` scene in the main storyboard.  Check the `Shows Cancel Button` in the attributes inspector.  Create an IBOutlet from the search bar to the `PostListTableViewController` class.
2. Add a `resultsArray` property in the `PostListTableViewController` class that contains an array of `SearchableRecords`
3. Add an `isSearching` property at the top of the class which stores a `Bool` value set to false by default
3. Refactor the `UITableViewDataSource` methods to populate the tableView with the `resultsArray` if `isSearching` is `true` and with the `PostController.shared.posts` if `isSearching` is `false`.
    * note: You will only display `Post` objects as a result of a search. Use the `PostTableViewCell` to do so.  In `cellForRowAt` function you will need to cast the data pulled out of the results array as a `Post`
4. In `ViewWillAppear` set the results array equal to the `PostController.shared.posts`.
5. Adopt the UISearchBarDelegate protocol, and implement the `searchBar(_:textDidChange:)` function.  Within the function filter the posts using the `Post` object's  `matches(searchTerm: String)` function and setting the `resultsArray` equal to the results of the filter.  Call `tableView.reloadData()` at the end of this function.
6. Implement the `searchBarCancelButtonClicked(_ searchBar:)`  function, using it to set the results array equall to `PostController.shared.posts` then reload the table view.  You should also set the searchBar's text equal to an empty String and resign its first responder.  This will return the feed back to its normal state of displaying all posts when the user cancels a search.
7. Implement the `searchBarTextDidBeginEditing` and set `isSearching` to `true`.
8. Implement the `searchBarTextDidEndEditing` and set `isSearching` to `false`.
6. In `ViewDidLoad` set the Search Bar's delegate property equal to `self` 

### Image Picker Controller

#### Photo Select Child Scene

Implement the Image Picker Controller in place of the prototype functionality you built previously.

1. Update the 'Select Image' IBAction to present an `UIAlertController` with an `actionSheet` style which will allow the user to select from picking an image in their photo library or directly from their camera.
2.  Implement  `UIImagePickerController` to access the phones photo library or camera.  Check to make sure each `UIImagePickerController.SourceType` is available, and for each that is add the appropriate action to the `UIAlertController` above.
3. Implement the `UIImagePickerControllerDelegate` function to capture the selected image and assign it to the image view.
Please read through the documentation for [UIImagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontroller) and its [delegate](https://developer.apple.com/documentation/uikit/uiimagepickercontrollerdelegate)
* note: Be sure to add a `NSCameraUsageDescription`

### Reduce Code Repetition

Refactor the photo selection functionality from the Add Post scene into a child view controller.

Child view controllers control views that are a subview of another view controller. It is a great way to encapsulate functionality into one class that can be reused in multiple places. This is a great tool for any time you want a similar view to be present in multiple places.

In this instance, you will put 'Select Photo' button, the image view, and the code that presents and handles the `UIImagePickerController` into a `PhotoSelectorViewController` class. You will also define a protocol for the `PhotoSelectorViewController` class to communicate with it's parent view controller.

#### Container View and Embed Segues

Use a container view to embed a child view controller into the Add Post scene.

> A Container View defines a region within a view controller's view subgraph that can include a child view controller. Create an embed segue from the container view to the child view controller in the storyboard.

1. Open `Main.storyboard` to your Add Post scene.
2. Add a new section to the static table view to build the Container View to embed the child view controller.
3. Search for Container View in the Object Library and add it to the newly created table view cell.
    * note: The Container View object will come with a view controller scene. You can use the included scene, or replace it with another scene. For now, use the included scene.
4. Set up contraints so that the Container View fills the entire cell.
5. Move or copy the Image View and 'Select Photo' button to the container view controller.
6. Create a new `PhotoSelectViewController` file as a subclass of `UIViewController` and assign the class to the scene in Interface Builder.
7. Create the necessary IBOutlets and IBActions, and migrate your Photo Picker code from the Add Post view controller class. Delete the old code from the Add Post view controller class.
8. Repeat the above steps for the Add Post scene. Instead of keeping the included child view controller from the Container View object, delete it, and add an 'Embed' segue from the container view to the scene you set up for the Add Post scene.

You now have two views that reference the same scene as a child view controller. This scene and accompanying class can now be used in both places, eliminating the need for code duplication.

#### Child View Controller Delegate

Your child view controller needs a way to communicate events to it's parent view controller. This is most commonly done through delegation. Define a child view controller delegate, adopt it in the parent view controller, and set up the relationship via the embed segue.

1. Define a new `PhotoSelectViewControllerDelegate` protocol in the `PhotoSelectViewController` file with a required `photoSelectViewControllerSelected(image: UIImage)` function that takes a `UIImage` parameter to pass the image that was selected.
    * note: This function will tell the assigned delegate (the parent view controller, in this example) what image the user selected.
2. Add a weak optional delegate property.
3. Call the delegate function in the `didFinishPickingMediaWithInfo` function, passing the selected media to the delegate.
4. Adopt the `PhotoSelectViewControllerDelegate` protocol in the Add Post class file, implement the `photoSelectViewControllerSelectedImage` function to capture a reference to the selected image.
    * note: In the Add Post scene, you will use that captured reference to create a new post.

Note the use of the delegate pattern. You have encapsulated the Photo Selection workflow in one class, but by implementing the delegate pattern,  each parent view controller can implement it's own response to when a photo was selected.

You have declared a protocol, adopted the protocol, but you now must assign the delegate property on the instance of the child view controller so that the `PhotoSelectViewController` can communicate with it's parent view controller. This is done by using the embed segue, which is called when the Container View is initialized from the Storyboard, which occurs when the view loads.

1. Assign segue identifiers to the embed segues in the Storyboard file
2. Update the `prepare(forSegue: ...)` function in the Add Post scene to check for the segue identifier, capture the `destinationViewController` as a `PhotoSelectViewController`, and assign `self` as the child view controller's delegate.

### Post Detail View Controller Share Sheet

Use the `UIActivityController` class to present a share sheet from the Post Detail view. Share the image and the text of the first comment.

1. Add an IBAction from the Share button in your `PostDetailTableViewController` if you have not already.
2. Initialize a `UIActivityViewController` with the `Post`'s image and the text of the first comment as the shareable objects.
3. Present the `UIActivityViewController`.

### Black Diamonds:

* Some apps will save photos taken or processed in their app in a custom Album in the user's Camera Roll. Add this feature.
* Review the README instructions and solution code for clarity and functionality, submit a GitHub pull request with suggested changes.
* Provide feedback on the expectations for Part Two to a mentor or instructor.
