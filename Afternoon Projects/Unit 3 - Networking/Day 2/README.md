# Post

#### Part Two - Alert Controllers, URLSessionDataTask (HTTP POST method), Paging Requests

* use URLSession to make asynchronous POST HTTP requests
* build custom table views that support paging through network requests

## Part Two - Alert Controllers, URLSessionDataTask (HTTP POST method), Paging Requests

* use URLSession to make asynchronous POST HTTP requests
* build custom table views that support paging through network requests

Build functionality to allow the user to submit new posts to the feed. Make the network requests more efficient by adding paging functionality to the Post Controller. Update the table view to support paging.

### Add Posting Functionality to the Post type

If we make our Post model adopt and conform to the `Codable` protocol it can do some pretty nice work for us. Without it, we'd need to write quite a bit more code in our model. `Codable` is really just a typealias for two other protocols, `Decodable` and `Encodable`. By adopting this protcol our object is now Decodable and Encodable. We'll need `Decodable` when using `GET` and `Encodable` in order to `POST`.

1. Go to your `Post` struct and adopt the `Codable` protocol. That's it! In this app we won't need any further work as long as we name our properties the exact same way the API returns them.

<!-- * note: This will be used when you set the HTTP Body on the `URLRequest`, which requires Data?, not a [String: Any] -->

### Add Posting Functionality to the PostController

Update your `PostController` to initialize a new `Post` and use an `URLSessionDataTask` to post it to the API.

1. Add an `addNewPostWith(username:text:completion:)` function.
2. Implement this function:
* Initialize a `Post` object with the memberwise initializer
* Create a variable called `postData` of type `Data` but don't give it a value.
* Inside of a do-catch block:
    * Create an instance of `JSONEncoder`
    * Create a variable called `postData` to hold the post after it has been encoded into data. Call `encode(value: Encodable) throws` on your instance of the JSONEncoder, passing in the post as an argument. You will need to assign the return of this function to a constant to the `postData` variable you created in the previous step. *Hint - This is a throwing function so make sure to catch the possible error.*
* Next, unwrap your baseURL.
* Next, create a property `postEndpoint` that will hold the unwrapped `baseURL` with a path extension appended to it. Go back and look at your sample url to see what this extension should be.
* Create an instance of URLRequest and give it the `postEndpoint`. (Once again, DO NOT forget to set the request's httpMethod -> `"POST"` and httpBody -> `postData`)
* As we did in the `fetchPosts()` function in Part 1, you need to create and run(`resume()`) a `URLSessionDataTask` and handle it's results:
* Check for errors. (_See Firebase's documentation for details on catching errors from the Post API._)
* note: You can use `String(data: data, encoding: .utf8)` to capture and print a readable representation of the returned data. Because of the quirks of this specific API, you will want to check this string to see if the returned data indicates an error.
* If there are no errors, log the success and the response to the console.
* After posting to the API, call `fetchPosts()` to load the new `Post` and any other new `Post` objects from the server.
* This is a little tricky but you'll need to call `completion()` for the `addNewPostWith(username:text:completion:)` function inside of the completion closure that gets called when the `fetchPosts()` is finished.

### Add Posting Functionality to the User Interface

1. Add a (+) `UIBarButtonItem` to the `PostListTableViewController` scene in storyboard
2. Add an IBAction to the `PostListTableViewController` class file from the bar button item
3. Write a `presentNewPostAlert()` function that initializes a `UIAlertController`.
* Add a `usernameTextField` and a `messageTextField` that the user will use to create their message.
* Add a 'Post' alert action that guards for username and message text, and uses the `PostController` to add a post with the username and text.
4. Write a `presentErrorAlert()` function that initializes a `UIAlertController` that says the user is missing information and should try again. Call the function if the user doesn't include include text in the `usernameTextField` or `messageTextField`
5. Call the `presentErrorAlert()` function in the `else` statement of the `guard` statement that checks for username and message text.
6. Create a 'Cancel' alert action, add both alert actions to the alert controller, and then present the alert controller.
7. Call the `presentNewPostAlert()` function from the IBaction of the + `UIBarButtonItem`

### Improving Efficiency of the Network Requests

You may have noticed that the network request to load the global feed can take multiple seconds to run. As more students build this project and submit more messages, the data returned from the `PostController` will get larger and larger. When you are working with hundreds of objects this is not a problem, but once you start dealing with thousands, tens of thousands, or more, things will start slowing down considerably.

Additionally, consider that the user is unlikely to scroll all the way to the first message in the global feed if there are thousands of posts. We can be more efficient by not loading it in the first place.

To avoid the inefficiency of loading data that will never be displayed, many APIs support 'querying' or 'paging'. The Post API you are using for this project supports paging. We will implement paging on the `PostController` and add support on the Post List Scene to load new posts as the user scrolls.

#### Add Paging Functionality to the Post Controller

Update the `PostController` to fetch a limited number of `Post` objects from the API by using the URL parameters detailed in the API documentation.

Consider that there are two use cases for using the `fetchPosts` function:

* To load a fresh list of `Post` objects for when the user wants to see the latest posts.
* To add the next set (or 'page') of posts to the already fetched posts for when the user wants to see older posts than the ones already loaded.

So you must update the `fetchPosts` function to support both of these cases.

1. Add a Bool `reset` parameter to the beginning of the `fetchPosts` function and assign a default value of `true`.
* This value will be used to determine whether you should replace the `posts` property or append posts to the end of it.
2. Review the API Documentation [Firebase documentation](https://firebase.google.com/docs/database/rest/retrieve-data?authuser=1#section-rest-filtering) to determine what URL parameters you need to pass to fetch a subset of posts.
* note: Experiment with the URL parameters using PostMan, Paw, or your web browser.
3. Consider the following concepts. Attempt to implement the different ways you have considered. Continue to the next step after 10 minutes.
* Consider how you can get the range of timestamps for the request
* Consider how many `Post` dictionaries you want returned in the request
* Use a whiteboard to draw out scenarios and potential sorting and filtering mechaninisms to get the data you want
4. Use the following logic to generate the URL parameters to get the desired subset of `Post` JSON. This can be complex, but think through it before using the included sample code below.
* You want to order the posts in reverse chronological order.
* Request the posts ordered by `timestamp` to put them in chronological order (`orderBy`).
* Specify that you want the list to end at the `timestamp` of the least recent `Post` you have already fetched (or at the current date if you haven't posted any). Specify that you want the posts at the end of that ordered list (`endAt`).
* Specify that you want the last 15 posts (`limitToLast`).
5. Determine the necessary `timestamp` for your query based on whether you are resetting the list (where you would want to use the current time), or appending to the list (where you would want to use the time of the earlier fetched `Post`). 
6. As this is quite a bit to modify we will walk you through this: 
* Add this code inside of the `fetchPosts()` function, being the first line of code it will run:
```
let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.timestamp ?? Date().timeIntervalSince1970
```
* Build a `[String: String]` Dictionary literal of the URL Parameters you want to use. Add this code after you unwrap the `baseURL`
```
let urlParameters = [
"orderBy": "\"timestamp\"",
"endAt": "\(queryEndInterval)",
"limitToLast": "15",
]
```
* Create a constant called `queryItems`. We need to flatmap over the urlParameters, turning them into `URLQueryItem`s.
```
let queryItems = urlParameters.flatMap( { URLQueryItem(name: $0.key, value: $0.value) } )
```
* Create a variable called `urlComponents` of type `URLComponents`. Pass in the unwrapped `baseURL` and `true` as arguments to the initializer.
* Set the `urlComonents.queryItems` to the `queryItems` we just created from the `urlParameters`.
* Then, create a `url` constant. Assign it the value returned from `urlComponents?.url`. *This will need to be placed inside a guard statement to unwrap it.
* Lastly, modify the `getterEndpoint` to append the extension to the `url` not to the `baseURL`.
* Now you'll need to make changes to the code where the data has already come back from the request. Replace the `self.posts = sortedPosts` with logic that uses the `reset` parameter to to determine whether you should replace `self.posts` or append to `self.posts`.
* note: If you want to reset the list, you want to replace, otherwise, you want to append. **Review the method on Array called `append(contentsOf:)`*

#### Add Paging Functionality to the User Inferface

Add paging functionality to the List View by adding logic that checks for when the user has scrolled to the end of the table view, and calls the updated `fetchPosts` function with the correct parameters.

1. Review the `UITableViewDelegate` [Protocol Reference](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITableViewDelegate_Protocol/index.html) to find a function that could be used to determine when the user has scrolled to the bottom of the table view.
* note: Move on to the next step after reviewing for potential solutions to implement this feature.
2. Add and implement the `tableView(_:willDisplay:forRowAt:)` function
* Check if the indexPath.row of the cell parameter is greater than or equal to the number of posts currently loaded - 1 on the `postController`
* If so, call the `fetchPosts` function with reset set to false
* In the completion closure, reload the tableview if the returned [Post] is not empty

#### Test and Refine the Paging Logic

Review the newly implemented paging feature. Scroll through the posts on the feed. Pay special attention to any abnormalities (unordered posts, repeated posts, empty posts, etc).

You will notice that there is a repeated post where every new fetch occurred. If you review the API documentation, you'll find that our `endAt` query parameter is inclusive, meaning that it will _include_ any posts that match the exact `timestamp` of the last post. So each time we run the `fetchPosts` function, the API will return a duplicate of the last post.

We can fix this bug by adjusting the `timestamp` we use for the query by a single digit.

1. Add a computed property `queryTimestamp` to the `Post` type that returns a `TimeInterval` adjusted by 0.00001 from the `self.timestamp`
2. Update the `queryEndInterval` variable in the `fetchPosts` function to use the `posts.last?.queryTimestamp` instead of the regular `timestamp`

Run the app, check for bugs, and fix any you may find.

### Black Diamonds

* Any app that displays user submitted content is required to provide a way to report and hide content, or it will be rejected during App Review. Add reporting functionality to the project.
* Update the user interface to cue to the user that a post is new.
* Make your table view more efficient by inserting cells for new posts instead of reloading the entire tableview.
* Implement streaming with web sockets.

## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2015. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
