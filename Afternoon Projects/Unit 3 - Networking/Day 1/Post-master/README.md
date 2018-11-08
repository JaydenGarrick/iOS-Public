# Post

### Level 3

Post is a simple global messaging service. Students will review MVC principles and work with URLSession, JSON parsing, and closures to build an app that lists and submits posts to a global feed.

Post is a single view application, with the main view being a list of all posts from the global feed listed in reverse-chronological order. The user can add posts via an alert controller presented after tapping an Add (+) bar button item.

Students who complete this project independently are able to:

#### Part One - Model Objects, Model Controller, URLSessionDataTask (HTTP GET method), Refresh Control

* use URLSession to make asynchronous GET HTTP requests
* implement the Codable protocol to decode JSON data and generate model objects from requests
* use closures to execute code when an asynchronous task is complete
* use UIRefreshControl to reload data for a table view

#### Part Two - Alert Controllers, URLSessionDataTask (HTTP POST method), Paging Requests

* use URLSession to make asynchronous POST HTTP requests
* build custom table views that support paging through network requests

## Part One - Model Objects, Model Controller, URLSessionDataTask (HTTP GET method), Refresh Control

* use URLSession to make asynchronous GET HTTP requests
* implement the Codable protocol to decode JSON data and generate model objects from requests
* use closures to execute code when an asynchronous task is complete
* use UIRefreshControl to reload data for a table view

Build your model object, post controller, and post list view controller. Add some polish to the view controller to allow the user to reload posts and know when network requests are happening. Focus on the network requests and decoding the data to display posts in the post list view controller.

### Implement Model

Create a `Post` model type that will hold the information of a post to display to the user.

Create a model object that will represent the `Post` objects that are listed in the feed. This model object will be generated locally, but must also be able to be initialized by decoding JSON data after "GETting" from the backend database.

1. Create a `Post.swift` file and define a new `Post` struct.
2. Go to a sample endpoint of the [Post API](https://dm-post.firebaseio.com/posts.json) and see what JSON (information) you will get back for each post.
3. Using this information, add the properties on `Post`.
* `let username: String`
* `let text: String`
* `let timestamp: TimeInterval`

3. Create a memberwise initializer that takes parameters for the `username` and `text`. Add a parameter for the `timestamp`, but set a default value for it.
* note: This memberwise initializer will only be used locally to generate new model objects. When initializing a new `Post` model object we will use the `.timeIntervalSince1970` from the current date for the `timestamp`.

* Remember, unless you customize it to do otherwise, `JSONEcoder` will use the names of each property as the keys for the JSON data it creates. (EXACT spelling matters!)

There is one more computed property you will add to the `Post` type called `queryTimestamp`, but we will discuss that in Part 2.

### Post Controller

Create a `PostController` class. This class will contain a function that will use a `URLSessionDataTask` to fetch data and will serialize the results into `Post` objects. This class will be used by the view controllers to fetch `Post` objects through completion closures.

Because you will only use one View Controller in this project, there is no reason to make this controller a singleton or shared controller. To learn more about when singletons may not be the best tool, review this article on [Singleton Abuse](https://www.objc.io/issues/13-architecture/singletons/#global-state). The key takeaway for now is that singletons aren't always the right tool for the job and you should carefully consider if it is the best pattern for accessing data in your project.

1. Add a static constant `baseURL` for the `PostController` to know the base URL for the /posts/ subdirectory. This URL will be used to build other URLs throughout the app.
2. Add a `posts` property that will hold the `Post` objects that you pull and decode from the API.
3. Add a method `fetchPosts` that provides a completion closure.

* In the next steps you will create an instance of `URLSessionDataTask` that will get the data at the endpoint URL.
    * Create an unwrapped instance of the `baseURL.
    * Create a constant `getterEndpoint` which takes the unwrapped `baseURL` and appends a path extension of `"json"`
    * Create an instance of `URLRequest` and give it the `getterEndpoint`. (It's very important that you _not_ forget to set the request's httpMethod and httpBody.)
    * Create an instance of `URLSessionDataTask` (Don't forget to call `resume()` after creating this instance.) This method will make the network call and call the completion closer with the `Data?`, `URLResponse?` and `Error?` results.
    * In the closure of the `dataTask(with: URLRequest, completionHandler: ...)`, you will need to handle the results it comes back with:
    *  You will need to give the `Data?`, `URLResponse?` and `Error?` results each a name. We suggest `(data, _, error)`. (You can use the '_' (wildcard) when naming the response because we will not be using it in this project)
    * If the dataTask was successful at retrieving data, `data` will have value, and `error` will not. The opposite is also true. If unsuccessful, `data` will be nil and `error` will have value. 
    * Check for an error. If there is an error, print that error, call `completion()`, and `return`.
    * Unwrap `data` if there is any.
    * Create an instance of `JSONDecoder`
    * Before adding the next step you will need your `Post` struct to adopt the `Codable` protocol.
    * Call `decode(from:)` on your instance of the JSONDecoder. You will need to assign the return of this function to a constant named `postsDictionary`. This function takes in two arguments: a type `[String:Post].self`, and your instance of `data` that came back from the network request. This will decode the data into a [String:Post] _(a dictionary with keys being the UUID that they are stored under on the database as you will see by inspecting the json returned from the network request, and values which should be actual instances of post)_.
        * NOTE: You will also notice that this function `throws`. That means that if you call this function and it doesn't work the way it should, it will _`throw`_ an error. Functions that throw need to be marked with `try` in front of the function call. You will also need to put this call inside of a **do-catch block** and `catch` the error that might be thrown. If there is an error caught, you will want to print the error, call `completion()` and `return`. _Review the documentation if you need to learn about do catch blocks._
    * Call flatmap on this dictionary, pulling out the post from each key-value pair. Assign the new array of posts to a constant named `posts`. 
    * Next, you'll need to sort these posts by timestamp in reverse chronological order (*the newest one is first).
    * Now assign the array of sorted posts to self.posts and call completion.

    _If you call `return` anywhere in this function, remember to call `completion()` before returning. This way you will avoid "leaving the caller hanging" if return ever gets called before adding the fetched posts to your array._

As of iOS 9, Apple is boosting security and requiring developers to use the secure HTTPS protocol and require the server to use the proper TLS Certificate version. The Post API does support HTTPS but does not use the correct TLS Certificate version. So for this app, you will need to turn off the App Transport Security feature.

1. Open your `Info.plist` file and add a key-value pair to your Info.plist. This key-value pair should be:
`App Transport Security Settings : [Allow Arbitrary Loads : YES].`

At this point you should be able to pull the `Post` data from the API and decode it into a list of `Post` objects. Test this functionality with a Playground or by calling this function in your App Delegate and trying to print the results from the API to the console.

1. Because you will always want to fetch posts whenever the tableview appears, you will want to call `fetchPosts()` in `viewDidLoad()` of your `PostListTableViewController`. This will start the call to fetch posts and assign them to the `posts` property. (_You will create this TableViewController in the next step_)

### Post List Table View Controller

Build a view that lists all posts. Implement dynamic height for the cells so that messages are not truncated. Include a Refresh Control that allows the user to 'pull to refresh' to load new, recent posts. 

#### Table View Setup

1. Add a `UITableViewController` as your root view controller in Main.storyboard and embed it in a `UINavigationController`
2. Create an `PostListTableViewController` file as a subclass of `UITableViewController` and set the class of your root view controller scene
3. Add a `postController` property to `PostListTableViewController` and set it to an instance of `PostController`
4. Implement the UITableViewDataSource functions using the included `postController.posts` array
5. Set the `cell.textLabel` to the message, and the `cell.detailTextLabel` to the author and post date.
* note: It may also help to temporarily add the `indexPath.row` to the `cell.detailTextLabel` to quickly determine if the posts are showing up where you expect them to be.

#### Reload with Posts

Create a function that we'll call in several places to reload the tableview on the main thread after `fetchPosts()` is called and the completion closure runs.

1. Create a function called `reloadTableView()`. In this function you will want to both reload the tableview and turn off the network activity spinner. Make sure you run both of these on the `main` thread.

#### Dynamic Cell Height

The length of the text on each `Post` is variable. Add support for dynamic resizing cells to your table view so messages are not truncated.

1. Set the `tableView.estimatedRowHeight` in the `viewDidLoad()` function
2. Set the `tableView.rowHeight` to `UITableViewAutomaticDimension`
3. Update the `textLabel` and `detailTextLabel` on the Post List storyboard scene to support multiple lines by setting the number of lines to 0 in the attributes inspector.

#### Refresh Control

Add a `UIRefreshControl` to the table view to support the 'pull to refresh' gesture.

1. Add a `UIRefreshControl` object to the table view on the storyboard scene. _***It's kind of hard to find**_
2. Add an IBAction from the `UIRefreshControl` to your `PostListTableViewController` class file
3. Implement the IBAction by telling the `postController` to fetch new posts. Make sure you reload the tableview after the posts come back.
4. Tell the `UIRefreshControl` to end refreshing when the `fetchPosts` is complete.

#### Network Activity Indicator

It is good practice to let the user know that a network request is processing. This is most commonly done using the Network Activity Indicator in the status bar.

1. Look up the documentation for the `isNetworkActivityIndicatorVisible` property on `UIApplication` to turn on the indicator when fetching new posts
2. Turn it off when the network call is complete. You should have added this to the `reloadTableView()` function.

Part One is now complete. You should be able to run the app, fetch all of the posts from the API, and have them display in the table view. Look for bugs and fix any that you may find.

### Black Diamonds

* Use a computed `.date` property, `DateComponent`s and `DateFormatter`s to display the `Post` date in the correct time zone
* Make your table view more efficient by inserting cells for new posts instead of reloading the entire tableview

## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2015. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
