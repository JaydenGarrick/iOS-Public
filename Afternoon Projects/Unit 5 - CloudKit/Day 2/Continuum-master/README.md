# Continuum

Continuum is a simple photo sharing service. Students will bring in many concepts that they have learned, and add more complex data modeling, Image Picker, CloudKit, and protocol-oriented programming to make a Capstone Level project spanning multiple days and concepts.

Most concepts will be covered during class, others are introduced during the project. Not every instruction will outline each line of code to write, but lead the student to the solution.

Students who complete this project independently are able to:

#### Part One - Project Planning, Model Objects, and Controllers

* follow a project planning framework to build a development plan
* follow a project planning framework to prioritize and manage project progress
* implement basic data model
* use staged data to prototype features

#### Part Two - Apple View Controllers, Search Controller, Container Views

* implement search using the system search controller
* use the image picker controller and activity controller
* use container views to abstract shared functionality into a single view controller

#### Part Three - Basic CloudKit: CloudKitManager,

* Check CloudKit availability
* Save data to CloudKit
* Fetch data from CloudKit
* Query data from CloudKit

#### Part Four - Intermediate CloudKit: Subscriptions, Push Notifications, Automatic Sync

* use subscriptions to generate push notifications
* use push notifications to run a push based sync engine

## Why CloudKit? 

If you where in an interview and a developer asked you why you chose to use CloudKit, what woud your answer be? "Because my mentors taught me", would be a lazy answer. Be confident with your descison to show you know what you're talking about. My reasons below would be as follows. 

* CloudKit is organic. You don't have to download anything. It forces you to become a better Apple programmer by following their convetions and design principles. 
* Its free! 
* Free authentication.
* Great privacy protection. 
* Really good resources, from Apple Programming Guides, WWDC videos on cloudKit best practices, easy to handel new updates. 


All of these apps use cloudKit. Millions of users make use of these app every day. If you work hard this week to learn these covered concepts, you'll see it pay off in your capstones. If you work hard in your capstones, you'll literally see you're hard work get paid off.


![cloudkitapps](https://user-images.githubusercontent.com/23179585/46048479-cbdbf080-c0e6-11e8-819a-e3004c648a9f.png)


## Part One - Project Planning, Model Objects, and Controllers

* follow a project planning framework to build a development plan
* follow a project planning framework to prioritize and manage project progress
* implement basic data model
* use staged data to prototype features

Follow the development plan included with the project to build out the basic view hierarchy, basic implementation of local model objects, model object controllers, and helper classes. Build staged data to lay a strong foundation for the rest of the app.

### View Hierarchy

Implement the view hierarchy in Storyboards. The app will have a tab bar controller as the initial controller. The tab bar controller will have two tabs.

The first is a navigation controller that has a PostListTableViewController that will display the list of posts, and will also use a UISearchBar to display search results. The PostListTableViewController will display a list of `Post` objects and segue to a `Post` detail view.

The second tab is a separate navigation controller that will hold a view controller to add new posts.

1. Add a `UITableViewController` Timeline scene, embed it in a `UINavigationController`, Make the navigation controller your first tab in the tab bar controller. (hint: control + drag from the tab bar controller to the navigation controller and select "view controllers" under the "Relationship Segue" section in the contextual menu)
2. Make the `UITableViewController` from step 1 a `PostListTableViewController` Cocoa Touch file subclass of `UITableViewController` and assign it to the Timeline scene
3. Add a `UITableViewController` Post Detail scene, add a segue to it from the `PostListTableViewController` scene
4. Add a `PostDetailTableViewController` subclass of `UITableViewController` and assign it to the Post Detail scene from step 3.
5. Add a `UITableViewController` Add Post scene, embed it into a `UINavigationController`. Make this navigation controller your second tab in the tab bar controller.
6. Add a `AddPostTableViewController` subclass of `UITableViewController` and assign it to the Add Post scene from step 5.

Your Storyboard should be simple skeleton resembeling the set up below:
![Alt text](/Photos/storyboard1.png?raw=true "Storyboard 1")


### Implement Model

Timeline will use a simple, non-persistent data model to locally represent data stored on CloudKit.

Start by creating model objects. You will want to save `Post` objects that hold the image data, and `Comment` objects that hold text. A `Post` should own an array of `Comment` objects.

#### Post

Create a `Post` model object that will hold image data and comments.

1. Add a new `Post` class to your project.
2. Add a `photoData` property of type `Data?`, a `timestamp` `Date` property, a `caption` of type `String`, and a `comments` property of type `[Comment]`.
3. Add a computed property, `photo` with a getter which returns a `UIImage` initialized using the data in `photoData` and a setter which adjusts the value of the `photoData` property to match that of the `newValue` for UIImage.  _Notice, the initalizer for `UIImage(data: )` is failable and will return an optional UIImage and that `newValue.jpegData(compressionQuality: )` optional data.  You will need to handle these optionals by making `photoData` and `photo` optional properties._

```
var photo: UIImage?{
    get{
        guard let photoData = photoData else {return nil}
        return UIImage(data: photoData)
    }
    set{
        photoData = newValue?.jpegData(compressionQuality: 0.6)
    }
}
```

4. Add an initializer that accepts a photo, timestamp, captions, and comments array. Provide a default values for the `timestamp` argument equal to the current date i.e. `Date()`.

#### Comment

Create a `Comment` model object that will hold user-submitted text comments for a specific `Post`.

1. Add a new `Comment` class to your project.
2. Add a `text` property of type `String`, a `timestamp` `Date` property, and a weak `post` property of type `Post?`.
* The comment objects reference to the post object should be weak in order to avoid retain cycles later on.  
`weak var post: Post?`
3. Add an initializer that accepts text, timestamp, and a post. Provide a default values for the `timestamp` argument equal to the current date, so it can be ommitted if desired.

### Model Object Controller

Add and implement the `PostController` class that will be used for CRUD operations.

1. Add a new `PostController` class file.
2. Add a `shared` singleton property.
3. Add a `posts` property initialized as an empty array.
4. Add an `addComment` function that takes a `text` parameter as a `String`, and a `Post` parameter. This should return a Comment object in a completion closure.
* _For now this function will only initialize a new comment and append it to the given post's comments array._
5. Add a `createPostWith` function that takes an image parameter as a `UIImage` and a caption as a `String`. This should return a Post object in a completion closure.  
6. The function will need to initalize a post from the image and new comment and append the post to the `PostController`s  `posts` property (think source of truth)

_Note: These CRUD functions will only work locally right now.  We will integrate Cloudkit further along in the project_

### Wire Up Views

#### Timeline Scene - Post List Table View Controller

Implement the Post List Table View Controller. You will use a similar cell to display posts in multiple scenes in your application. Create a custom `PostTableViewCell` that can be reused in different scenes.

1. Implement the scene in Interface Builder by creating a custom cell with an image view that fills most of the cell, a label for the posts caption (the first comment in its array), and another label for diplaying the number of comments a post has.  With the caption label selected, turn the number of lines down to 0 to enable this label to spread to the necessary number of text lines.  Constrain the UI elements appropriately.  Your `PostTableViewCell` should look similar to the one below.

![Alt text](/Photos/storyboard2.png?raw=true "Storyboard 2")

2. Create a `PostTableViewCell` class, subclass the tableView cell in your storyboard and add the appropriate IBOutlets.
3. In your `PostTableViewCell` add a `post` variable, and implement an `updateViews` function to the `PostTableViewCell` to update the image view with the `Post`'s photo. Call the function in the didSet of the `post` variable
3. Keeping with the asthetic of our favorite original photo sharing application, give the imageView an aspect ratio of 1:1.  You will want to do this for all Post Image Views within the app to maintain consistency.  Place a sample photo in your storyboard and explore the options of `Aspect Fill`, `Aspect Fit` and `Scale to Fill`.  The master project will be using `Aspect Fill` with `Clips to Bounds` On.
4. Implement the `UITableViewDataSource` functions
5. Implement the `prepare(for segue: ...)` function to check the segue identifier, capture the detail view controller, index path, selected post, and assign the selected post to the detail view controller.
    * note: You may need to quickly add a `post` property to the `PostDetailTableViewController`.

#### Post Detail Scene

Implement the Post Detail View Controller. This scene will be used for viewing post images and comments. Users will also have the option to add a comment, share the image, or follow the user that created the post.

Use the table view's header view to display the photo and a toolbar that allows the user to comment, share, or follow. Use the table view cells to display comments.

1. Add a vertical `UIStackView` to the Header of the table view. Add a `UIImageView` and a horizontal `UIStackView` to the stack view. Add 'Comment', 'Share', and 'Follow Post' `UIButtons`s to the horizontal stack view. Set the horizontal stack view to have a center alignment and Fill Equally distribution.  Set the Vertical Stack View to have a center alignment and Fill distribution.
2. Set up your constraints so that the image view has an apect ratio of 1:1 and a width equal to its the vertical Stack View.  Give the horizontal Stack View an equal width to the vertical Stack View.
3. Constrain the vertical Stack View to be centered horizontally and vertically in the header view and equal to 80% of the width of the header view (i.e. the users screen width).
4. In  `PostDetailTableViewController.swift` create an IBOutlet from the Image View named `photoImageView` and an appropriate IBAction from each button.
3. Update the cell to support comments that span multiple lines without truncating them. Set the `UITableViewCell` to the subtitle style. Set the number of lines for the cells title label to zero. Implement dynamic heights by setting the `tableView.rowHeight` and `tableView.estimatedRowHeight` in the `viewDidLoad`.  See documentation on [UITableView](https://developer.apple.com/documentation/uikit/uitableview) for more details.
4. Add an `updateViews` function that will update the scene with the details of the post. Implement the function by setting the `photoImageView.image` and reloading the table view if needed.  Use a `didSet` on the `post` variable to call `updateViews`.
5. Implement the `UITableViewDataSource` functions.
    * note: The final app does not need to support any editing styles, but you may want to include support for editing while developing early stages of the app.
6. In the IBAction for the 'Comment' button. Implement the IBAction by presenting a `UIAlertController` with a text field, a Cancel action, and an 'OK' action. Implement the 'OK' action to initialize a new `Comment` via the `PostController` and reload the table view to display it.  Leave the completion closure in the `addComment` function blank for now.
    * note: Do not create a new `Comment` if the user has not added text.
    _Leave the Share and Follow button IBActions empty for now.  You will fill in implementations later in the project._

#### Add Post Scenes

Implement the Add Post Table View Controller. You will use a static table view to create a simple form for adding a new post. Use three sections for the form:

Section 1: Large button to select an image, and a `UIImageView` to display the selected image
Section 2: Caption text field
Section 3: Add Post button

Until you implement the `UIImagePickerController`, you will use a staged static image to add new posts.

1. In the the attributes inspector of the `AddPostTableViewController`, assign the table view to use static cells. Adopt the 'Grouped' cell style. Add three sections.
2. Build the first section by creating a tall image selection/preview cell. Add a 'Select Image' `UIButton` that fills the cell. Add an empty `UIImageView` that also fills the cell. Make sure that the button is on top of the image view so it can properly recognize tap events.
3. Build the second section by adding a `UITextField` that fills the cell. Assign placeholder text so the user recognizes what the text field is for.
4. Build the third section by adding a 'Add Post' `UIButton` that fills the cell.
5. Add an IBAction and IBOutlet to the 'Select Image' `UIButton` that assigns a static image to the image view (add a sample image to the Assets.xcassets that you can use for prototyping this feature), and removes the title text from the button.
    * note: It is important to remove the title text so that the user no longer sees that a button is there, but do not remove the entire button, that way the user can tap again to select a different image (i.e. do not hide the button).
6. Add an IBAction to the 'Add Post' `UIButton` that checks for an `image` and `caption`. If there is an `image` and a `caption`, use the `PostController` to create a new `Post`. Guard against either the image or a caption is missing.  Leave the completion closure in the `createPostWith` function empty for now.
7. After creating the post, you will want to navigate the user back to `PostListTableViewController` of the application.  You will need to edit the Selected View Controller for your apps tab bar controller.  You can achieve this by setting the `selectedIndex` property on the tab bar controller.

`self.tabBarController?.selectedIndex = 0`

7. Add a 'Cancel' `UIBarButtonItem` as the left bar button item. Implement the IBAction to bring the user back to the `PostListTableViewController` using the same line of code from step 6.
8. Override `ViewDidDisappear` to reset the Select Image Button's title back to "Select Image" and reset the imageView's image to nil.

#### A Note on Reusable Code

Consider that this Photo Selection functionality could be useful in different views and in different applications. New developers will be tempted to copy and paste the functionality wherever it is needed. That amount of repetition should give you pause. _Don't repeat yourself_ (DRY) is a shared value among skilled software developers.

Avoiding repetition is an important way to become a better developer and maintain sanity when building larger applications.

Imagine a scenario where you have three classes with similar functionality. Each time you fix a bug or add a feature to any of those classes, you must go and repeat that in all three places. This commonly leads to differences, which leads to bugs.

You will refactor the Photo Selection functionality (selecting and assigning an image) into a reusable child view controller in Part 2.

### Polish Rough Edges

At this point you should be able view added post images in the Timeline Post List scene, add new `Post` objects from the Add Post Scene, add new `Comment` objects from the Post Detail Scene.  Your app will not persist or share data yet.
Use the app and polish any rough edges. Check table view cell selection. Check text fields. Check proper view hierarchy and navigation models.

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


## Part Three - Basic CloudKit: CloudKitManager, CloudKitSyncable, Manual Sync

* Check CloudKit availability
* Save data to CloudKit
* Fetch data from CloudKit

Following some of the best practices in the CloudKit documentation, add CloudKit to your project as a backend syncing engine for posts and comments. Check for CloudKit availability, save new posts and comments to CloudKit, and fetch posts and comments from CloudKit.

When you finish this part, the app will support syncing photos, posts, and comments from the device to CloudKit, and pulling new photos, posts, and comments from CloudKit. When new posts or comments are fetched from CloudKit, they will be turned into model objects, and the Fetched Results Controllers will automatically update the user interface with the new data.

You will implement push notifications, subscriptions, and basic automatic sync functionality in Part Four.

### CloudKit Manager

Ask your instructor about what the CloudKit Manager was used for and why we took it out. It's a good code achitecture, however difficult to grasp in one week. Abstraction is an important concept to grasp. The CloudKit Manager abstracts CloudKit code into a single helper class that implements basic CloudKit functionality. You are welcome to make a CloudKit Manager if you’ve used abstraction in other programming languages. 

### Update Post for CloudKit functionality

1. Add a computed property `recordType` and return the type you would like used to identify 'Post' objects in CloudKit. (Note: this is simply so that you don't have to write `Post.typeKey` a bunch of times within the scope of this class, and instead simply write `recordType`.)
2. Add a recordID property that is equal to a 'CKRecord.ID' with a default value of a uuidString. 

3. To save your photo to CloudKit, it must be stored as a `CKAsset`. `CKAsset`s must be initialized with a file path URL. In order to accomplish this, you need to create a temporaryDirecory that copies the contents of the `photoData: Data?` property to a file in a temporary directory and returns the URL to the file. This is going to be a 3 step process.

  - 2.1. Save the image temporarily to disk
  - 2.2. Create the CKAsset
  - 2.3. Remove the temporary file

It looks like this:

```swift
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            self.tempURL = fileURL
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
```
The whole point of the above computed property is to read and write for our photo property. Look up `CKAsset`, it can only take a fileURL. We want to create a temorary file url so we can write to it. Once we are done using the temp url, we have to remove it otherwise it can drain our memory. The TemoraryDirecorty comes from FileMnager and there is already a shared method that can remove the temp url. 
   - 2.3. Remove the temporary file
```
deinit {
        if let url = tempURL {
            do {
                try FileManager.default.removeItem(at: url)
            } catch let error {
                print("Error deleting temp file, or may cause memory leak: \(error)")
            }
        }
    }
 ```
      * note: `CKAsset` is initialized with a URL. When creating a `CKAsset` on the local device, you initialize it with a URL to a local file path where the photo is located on disk. When you save a `CKAsset`, the data at that file path is uploaded to CloudKit. When you pull a `CKAsset` from CloudKit, the URL will point to the remotely stored data.

4. Add a computed property `recordType` and return the type you would like used to identify 'Post' objects in CloudKit. (Note: this is simply so that you don't have to write `Comment.typeKey` a bunch of times within the scope of this class, and instead simply write `recordType`.)
5.Add an extention on CKRecord that will set create the CKRecord.ID of a 'Post' object and set each value. It will need the required convenience initializer `init?(record: CKRecord)`.


### Update Comment for CloudKit Functionality

1. Add a computed property `recordType` and return the type you would like used to identify 'Comment' objects in CloudKit. (Note: this is simply so that you don't have to write `Comment.typeKey` a bunch of times within the scope of this class, and instead simply write `recordType`.)
2.Add an extention on CKRecord that will set create the CKRecord.ID of a 'Comment' object and set each value. It will need the required convenience initializer `init?(record: CKRecord)`. and set each property. Add fileprivate strings for your keys to keep your code safe. 

Remember that a `Comment` should not exist without a `Post`. When a `Comment` is created from a `CKRecord`, you will also need to set the new comment's `Post` property. Consider how you would approach this. We will address it in the next section.

### Update the Post Controller for CloudKit functionality

## Checking to see if the user is sigined into iCloud

If the user isn't singed into their iCloud account, they are going to have a bad time using our app. BIG TIME BOARING, because most of the features wouldn't fully work. If they arn't sigined in, we want to let the user know immediately. How could we let the user know that they are not signed into iCloud? If they are signed into iCloud, we want the app to continue as usual. Take a moment and think about this, if it the user is signed in 'do something' if the user isn't signed in 'do something else'. What would our function signature look like? 

This is going to be an asyc call to check the accountStatus of a iPhone user. `CKContainer` has an accountStatus fuction that can check the users status. There are 4 options, for `CKAccountStatus`. This is a great time to use a switch statment based on the users status inside the closure. Handel each case statment and completions. If you didn't see this coming already we need a `@escaping` completion closure to handel the events if the user is signed in or not. If the competion is false we can call another function within this fuction to present an alert and notify the user that they are not signed in. You'll want to Dispatch the alert on the main thread. Make a function calld presentErrorAlert(errorTitle: String, errorMsessage: String). You'll call this fuction within your accountStatus fuction. Based on the users status you'll provide the proper errorMessage to inform the user. 

If you attempt to present an alert in this class, you'll notice an error. That's because PostController isn't a subclass of `UIViewController` nor should it be. We don't have access to any `UIViewController` yet. We need to talk to the system that is the centrailized point of contol and coordination that runs our app. `UIApplication`! Specifically we need the `UIApplicationDelegate`. Every app must have an app delegate object to respond to app-related messages. For example, the app notifies its delegate when the app finishes launching and when its foreground or background execution status changes. Similarly, app-related messages coming from the system are often routed to the app delegate for handling. Access the rootViewController, once you have the rootViewController you can present an alert.

Take a moment and try this on your own if you get stuck here is the code. 
<details><summary> Account Status Code Snipit </summary><br>
    
    ```func checkAccountStatus(completion: @escaping (_ isLoggedIn: Bool) -> Void) {
        CKContainer.default().accountStatus { [weak self] (status, error) in
            if let error = error {
                print("Error checking accountStatus \(error) \(error.localizedDescription)")
                completion(false); return
            } else {
                let errrorText = "Sing in to iCloud in Settings"
                switch status {
                case .available:
                   completion(true)
                case .noAccount:
                    let noAccount = "No account found"
                    self?.presentErrorAlert(errorTitle: errrorText, errorMessage: noAccount)
                    completion(false)
                case .couldNotDetermine:
                    self?.presentErrorAlert(errorTitle: errrorText, errorMessage: "Error with iCloud account status")
                    completion(false)
                case .restricted:
                    self?.presentErrorAlert(errorTitle: errrorText, errorMessage: "Restricted iCloud account")
                    completion(false)
                }
            }
        }
    }
    ```
    
    func presentErrorAlert(errorTitle: String, errorMessage: String) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.showAlertMessage(titleStr: errorTitle, messageStr: errorMessage)
            }
        }
    }
</details>

You should be getting an error if you copied this code. Good, because you chose to copy and paste, reasearch for 10 minutes on how to add your own alert mesage to any `UIViewController`. 

The `accountStatus` method is an async call thats why we want to Dispatch the alert on the main thread once we call the `presentErrorAlert` function insde the `checkAccountStatus` function. Call this in your app delegate and it should check if you're sigined in to iCloud, if not there sould be an alert controller. 

#### Saving Records

Update the `PostController` to support pushing and pulling data from CloudKit.

This is where we are going to be saving and fetching our data. 
``` let publicDB = CKContainer.default().publicCloudDatabase ```

1. Update the `createPost` function to create a `CKRecord` using your create function that you made eariler. Documentation on this is REALLY GOOD and its easy! Do you remember what is at the highest level of CloudKit? It's highest level starts with `CKContainer`, a container has 3 databases. All 3 databases have methods. Lets walk through this sep by step.

    - 1.1 - Plug in `CKContainer` in documentation. Re-read the intro if you don't know what it is. 
    - 1.2 - Scroll through and click on `CKDatabase`
    - 1.3 - Search for a save method. You should see 3 options. Which one do we want? What are we saving? What is the heart of CloudKit?
    #### CKRecords! Are the heart of cloudKit. If you save an object, it must be a CKRecord. If you fetch an object, it must be a CKRecord. Drill that in your head, or you'll NSCashe me outside. 
    
The function signature looks like so. It's asking for a `CKRecord`, so lets give it a `CKRecord`. 
    ```func save(CKRecord, completionHandler: (CKRecord?, Error?) -> Void)```
That was the point of making an extention on CKRecord. It makes it realy easy to creat an instance of post and turn a post into a CKReocrd. Look how cool this is! 
    
![Alt text](/Photos/CKRecordExtention.png?raw=true "CkRecord")

In Borat's voice "Very nice".  

At this point you should be able to save a post record and see it in your CloudKit dashboard. You dashboard should look similar to this. Make sure you click on it :).  
![Alt text](/Photos/dashboard.png?raw=true "Photos")


2. Update the `addCommentToPost` function to to create a `CKRecord` using the extention of `CKRecord` you created for your `Comment` object, and call the `cloudKitManager.saveRecord` function. The user will be adding comments to an existing post. We need to set up our one to many realtionship for our `Comment` model. 

- 2.1 Update your extention on `CKRecord` for your `Comment` object. You want to create a post constant to from the convenience init parameter of comment, else do a `fatalError("Comment does not have a Post relationship")`. 
- 2.2 Set each value for comment 
- 2.3 Set a `CKRecord.Referenc` value. The key will be the postReferenceKey. This is what makes our relation ship stronger (not strong), so we can query the comments that belong to a post easier. the postReference value is going to be the UUID of that post that owns the comment.

This proccess is called "Backreferencing". Where the lower object (Comment) points pack to its parent (Post). 

Here is the code for the extention of `CKRecord` for `Comment` if you get stuck. 

<details><summary> CKRecord for Comment </summary><br>

```extension CKRecord {
    convenience init(_ comment: Comment) {
        guard let post = comment.post else {
            fatalError("Comment does not have a Post relationship")
        }
        self.init(recordType: comment.typeKey, recordID: comment.recordID)
        self.setValue(comment.text, forKey: comment.typeKey)
        self.setValue(comment.timestamp, forKey: comment.timestampKey)
        self.setValue(CKRecord.Reference(recordID: post.recordID, action: .deleteSelf), forKey: comment.postReferenceKey)
    }
}
```
</details>

At this point, each new `Post` or `Comment` should be pushed to CloudKit when new instances are created from the Add Post or Post Detail scenes.


#### Fetching Records

There are a number of approaches you could take to fetching new records. For Timeline, we will simply be fetching (or re-fetching, after the initial fetch) all the posts at once. Note that while we are doing it in this project, it is not an optimal solution. We are doing it here so you can master the basics of CloudKit first.

Note: If you want the challenge, you could modify the following functions so that you only fetch the records you don't already have on the device. **This is not required, and is a Black Diamond**



##### Fetching Posts

1. Add a `fetchPosts` function that has a completion closure. Give the completion an array of optional `[Post]?` 's.
2. Call the `publicDB` property to perform a query. Now we know we need tom make a `CKQuery` and a `NSPredicate`. The preicate value will be set to true which means it will fetch every post.
3. Handel the error 
4. Unwrape the records, and `compactMap` through your failable initializer of `Post` and pass in $0 as your argument. This will return a new array of posts fetched from our publicDB. 
5. Don't for get to set your local array to the new array of posts. This is how the TVC will populate all our posts. And call completion. 

Note! Option click on `perfomr(query)`. It says "Do not use this method when the number of returned records is potentially more than a few hundred records; when more records are needed, create an execute a CKQueryOperation". Instagram doesn't fetch everysigle post for the useers that you follow. At the bottom of this ReadMe, there is an advanced fetching video to cover how to fetch paginated posts. The above steps work, but if we get a lot of users, this could break our app. 


##### Fetching Comments

 We're going to create a function that will allow us to fetch all the comments for a specific post we give it.

1. Add a fetchCommentsFor(post: Post, ...) function that has a completion closure. Give the completion a Bool.
2. Call your `publicDB` to perfomr a query. 
3. Because we don't want to fetch every comment ever created, we must use a different `NSPredicate` than the default one. Create a predicate that checks the value of the correct field that corresponds to the post `CKReference` on the Comment record against the `CKReference` you created in the last step.
4. Add a second predicate to includes all of the commentID's that have NOT been fetched. (If stuck hit the down arrow)

<details><summary> Filter comments </summary><br>
    
        let postRefence = post.recordID
        let predicate = NSPredicate(format: "postReference == %@", postRefence)
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2]
        let query = CKQuery(recordType: "Comment", predicate: compoundPredicate) 
</details>


5. In the completion closure of the perform(query) , follow the common pattern of checking for errors, making sure the records exist, then create an array of Comment objects however you prefer.
6. Set the value of the array of comments in the post passed into this function to the comments you just initialized in the previous step.


#### NotificationCenter

1. Add static `PostsChangedNotification` and `PostCommentsChangedNotification` string properties.
2. Add a `didSet` property observer to the `posts` property.
3. In the `didSet`, post a `PostController.PostsChangedNotification` `NSNotification.Name` to notify any interested listeners that the array of posts has changed. Post the notification on the main queue since observers will be updating UI in response, and that can only be done on the main queue.
4. In Post.swift, create a `didSet` property observer to the `comments` property.
5. Post a `PostController.PostCommentsChangedNotification`. in the `didSet` created in the previous step. Again this must be done on the main queue. Use the `Post` whose comments changed as the object of the notification. (Since you are in the Post class, you would do that by saying `self`)

1. Add a new function to request a full sync operation that takes an optional completion closure. Implement the function by turning on the network activity indicator, calling the `performFullSync` function on the `PostController`, and turning off the network activity indicator in the completion.
2. Call the function in the `viewDidLoad` lifecycle function to initiate a full sync when the user first opens the application.

4. In `viewDidLoad()`, start observing the `PostController.PostsChangedNotification`. In your observation method, reload the table view.

#### Update the Post Detail Table View Controller

1. In `viewDidLoad()`, start observing the `PostController.PostCommentsChangedNotification`.
2. In your observation method, check that the notification's object is the post whose detail is being displayed, and if so, reload the table view.

#### Check Functionality

At this point the app should support basic push and fetch syncing from CloudKit. Use your Simulator and your Device to create new `Post` and `Comment` objects. Check for and fix any bugs.

![screen shot 2018-09-26 at 12 13 12 pm](https://user-images.githubusercontent.com/23179585/46100095-d8635600-c185-11e8-9715-9f8a64d5536e.png)

When you tap on a post cell it should bring you to the detailVC. The comments that belong to that post should be fetched. 

### Black Diamonds:

* Update the Post List view to support Pull to Refresh to initiate a sync operation by implementing a `UIRefreshControl` IBAction that uses the sync function.
* Provide feedback on the Readme and expectations for Part Three to a mentor or instructor.


## Part Four - Intermediate CloudKit: Subscriptions, Push Notifications

* Use subscriptions to generate push notifications
* Use push notifications to run a push based sync engine

Implement Subscriptions and push notifications to create a simple automatic sync engine. Add support for subscribing to new `Post` records and for subscribing to new `Comment` records on followed `Posts`s. Request permission for remote notifications. Respond to remote notifications by initializing the new `Post` or `Comment` with the new data.

When you finish this part, the app will support syncing photos, posts, and comments from remote notifications generated when new records are created in CloudKit. This will allow all devices that have given permission for remote notifications the ability to sync new posts and comments automatically. When new posts or comments are created in CloudKit, they will be serialized into model objects, and the UI will update with the new data.

### PostController Subscription Based Sync

Update the `PostController` class to manage subscriptions for new posts and new comments on followed posts. Add functions for following and unfollowing individual posts.

When a user follows a `Post`, he or she will receive a push notification and automatic sync for new `Comment` records added to the followed `Post`.

#### Subscribe to New Posts

Create and save a subscription for all new `Post` records.

1. Add a function `subscribeToNewPosts` that takes an optional completion closure with  `Bool` and `Error?` parameters.
    * note: Use an identifier that describes that this subscription is for all posts.
2. Initialize a new CKQuerySubscription for the `recordType` of 'Post'.  Pass in a predicate object with it value set to `true`.
3. Save the subscription to the public database.  Handle any error which may be passed out of the completion handler and complete with true of false based on whether or not an error occured while saving.
3. Call the `subscribeToNewPosts` in the initializer for the `PostController` so that each user is subscribed to new `Post` records saved to CloudKit.

#### Subscribe to New Comments

Create and save a subscription for all new `Comment` records that point to a given `Post`

1. Add a function `addSubscriptionTo(commentsForPost post: ...)` that takes a `Post` parameter and an optional completion closure wich takes in a `Bool` and `Error` parameters.
2. Initialize a new NSPredicate formated to search for all post references equal to the `recordID` property on the `Post` parameter from the function.
3. Initalize a new `CKQuerySubscription` with a record type of `Comment`, the predicate from above, a `subscriptionID` equal to the posts record name which can be accessed using `post.recordID.recordName`, with the `options` set to `CKQuerySubscription.Options.firesOnRecordCreation` 
4. Initalize a new `CKSubscription.NotificationInfo` with an empty inializer.  You can then set the properties of `alertBody`, `shouldSendContentAvailable`, and `desiredKeys`.  Once you have adjusted these settings, the `notificationInfo` property on the instance of `CKQuerySubscription` you initialized above.
5. Save the subscription you initalized and modified in the public database.  Check for an error in the ensuing completion handler.
* Please see the [CloudKit Programming Guide](https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/CloudKitQuickStart/SubscribingtoRecordChanges/SubscribingtoRecordChanges.html#//apple_ref/doc/uid/TP40014987-CH8-SW1) and [CKQuerySubscription Documentation](https://developer.apple.com/documentation/cloudkit/ckquerysubscription) for more detail.

#### Manage Post Comment Subscriptions

The Post Detail scene allows users to follow and unfollow new `Comment`s on a given `Post`. Add a function for removing a subscription, and another function that will toggle a subscription for a given `Post`.

1. Add a function `removeSubscriptionTo(commentsForPost post: ...)` that takes a `Post` parameter and an optional completion closure with `success` and `error` parameters.
2. Implement the function by calling `delete(withSubscriptionID: ...)` on the public data base. Handle the error which may be returned by the completion handler.  If there is no error complete with `true`.
    * note: Use the unique identifier you used to save the subscription above. Most likely this will be your unique `recordName` for the `Post`.
3. Add a function `checkSubscription(to post: ...)` that takes a `Post` parameter and an optional completion closure with a  `Bool` parameter.
4. Implement the function by fetching the subscription by calling `fetch(withSubscriptionID: ...)` passing in the unique `recordName` for the `Post`.  Handle any errors which may be generated in the completion handler.  If the `CKSubscription` is not equal to nil complete with `true`, else complete with `false`.
    
5. Add a function `toggleSubscriptionTo(commentsForPost post: ...)` that takes a `Post` parameter and an optional completion closure with `Bool`, and `Error` parameters.
6. Implement the function by calling the `checkForSubscription(to post:...)` function above.  If a subscription does not exist, subscribe the user to comments for a given post by calling the `addSubscriptionTo(commentsForPost post: ...)` ; if one does, cancel the subscription by calling  `removeSubscriptionTo(commentsForPost post: ...)`.

### Update User Interface

Update the Post Detail scene's `Follow Post` button to display the correct text based on the current user's subscription. Update the IBAction to toggle subscriptions for new comments on a `Post`.

1. Update the `updateViews` function to call the `checkSubscriptionTo(commentsForPost: ...)` on the `PostController` and set appropriate text for the button based on the response.  You will need to add an IBOutlet for the button if you have not already.
2. Implement the `Follow Post` button's IBAction to call the `toggleSubscriptionTo(commentsForPost: ...)` function on the `PostController` and update the `Follow Post` button's text based on the new subscription state.

### Add Permissions

Update the Info.plist to declare backgrounding support for responding to remote notifications. Request the user's permission to display remote notifications.

1. Go to the Project File. In the "capabilities" tab, turn on Push Notifications and Background Modes. Under Background Modes, check Remote Notifications.

2. Request the user's permission to display notifications in the `AppDelegate` `didFinishLaunchingWithOptions` function.
    * note: Use the `requestAuthorization` function that is a part of `UNUserNotificationCenter`.
3. Reigster the App to recieve push notifications `application.registerForRemoteNotifications()`

### Handle Received Push Notifications

At this point the application will save subscriptions to the CloudKit database, and when new `Post` or `Comment` records are created that match those subscriptions, the CloudKit database will deliver a push notification to the application with the record data.

Handle the push notification by serializing the data into a `Post` or `Comment` object. If the user is actively using the application, the user interface will be updated in response to notifications posted by the `PostController`.

1. Add the `didReceiveRemoteNotification` delegate function to the `AppDelegate`.
2. Implement the function by telling the `PostController` to call the `fetchPosts` function.
