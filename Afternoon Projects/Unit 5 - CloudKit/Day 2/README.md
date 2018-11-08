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
