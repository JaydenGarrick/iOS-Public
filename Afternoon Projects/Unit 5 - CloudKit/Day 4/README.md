# Continuum

#### Part Three - Basic CloudKit: CloudKitManager,

* Check CloudKit availability
* Save data to CloudKit
* Fetch data from CloudKit
* Query data from CloudKit

#### Part Four - Intermediate CloudKit: Subscriptions, Push Notifications, Automatic Sync

* use subscriptions to generate push notifications
* use push notifications to run a push based sync engine

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
