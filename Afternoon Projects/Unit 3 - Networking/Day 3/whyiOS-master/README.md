# whyiOS

<a name= 'top'></a>

* [Description](#description)
* [Implement Model](#model)
* [Controllers](#controllers)
* [PostReason](#post)
* [View Hierarchy](#view)
* [Black Diamonds](#diamond)


## <a name='description'></a> Description
Students will build an app to showcase why they choose to learn iOS and what cohort they’re in. The database is shared across all DevMountain iOS developers. This app showcases how to post data to a central database. Students will practice asynchronous network calls, working with JSON data, closures, and intermediate tableviews.

Students who complete this project independently are able to:

* Use URLSession to make asynchronous network calls.
* Parse JSON data and generate model objects from the data.
* Use closures to execute code when an asynchronous task is complete.
* Build custom table views.
* Showcase the HTTPMethod POST.

## <a name='model'></a> Implement Model

Create a Post model struct that will hold the information of a post to display to the user.
1. Create a Post.swift file and define a new post struct.
2. Go to a sample endpoint of whyiOS firebase API and see what JSON (information) you will get back.
3. Using this information, add properties on Post.
* let name: String
* let reason: String
* let cohort: String
4. Make Post conform to the Codable protocol.

## <a name='controllers'></a> PostController

Create a PostController class.
This class will use the URLSession to fetch data and deserialize the results into Post objects. This class will be used by the view controllers to fetch Post objects through completion closures.
1. The PostController should have a static constant that represents the baseURL of the API.
2.  // static let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
3. Add a function fetchPosts(completion:….) that allows the developer to create a dataTask to fetch the Posts data, and through a completion closure provide an array of Post objects.
4. Create a new variable named url and guard that it is assigned to the base url. Handle the closure appropriately .
5. Append your url with the path extension “.json”
6. Build your request with the proper httpMethod
7. Create a dataTask(with: request… ) from the URLSession singleton
8. Check for an error - handle the error and completion accordingly
9. Check for data -  handle the error and completion accordingly
10. If data is there write a do, try, catch
11. Create an instance of JSONDecoder
12. do { 
13.  try - Create a dictionary with a key of String and a value of Post from the decoded data 
14. Map through the dictionary to create an array of posts
15. Ask your self what you are completing with .("What would you like this function to come back with"). Then call completion.
16. Catch the error

## <a name='post'></a> PostReason
Create a postReason method that takes in a name, reason, and cohort Strings.

1. Create your method with its properties and closure
2. Check your URL. If it fails, complete false.
3. Create your Object
4. do {
5. Encode it with an instance of JSONEncoder()
6. Create your request. Use the proper HTTPMethod, and set your encoded data to the HTTPBody
7. Create your datatask with your request
8. Handle your error, and complete accordingly
9. Handle the data, compelte acordingly // Don't forget to resume the datatask
10 Catch and handle your error


## <a name='view'></a> View Hierarchy

We will only need one view for this application:
ReasonTableViewController

Build a view that will display the data we return from our endpoint. You will need a UITableViewController with a NavigationController, a custom UITableViewCell, three labels, and two bar button item.

## PostTableviewController
PostsTableviewController
Build a view that will list all the students with their name, cohort, and a why they choose to build iOS apps.
1. Delete the basic ViewController and corresponding file.
2. Add a UITableViewController as your root view controller in Main.storyboard and embed it in a UINavigationController
3. Create an PostsTableViewController file as a subclass of UITableViewController and set the class of your root view controller scene.
4. Set up your cell with three labels.
5. Embed your labels in a stack view and pin it `8` from all sides.
6. Create a PostTableViewCell file as a subclass of UITableViewCell and set the class of your cell.
7. Add your cells reuse Identifier.
8. Add a left bar button item and name it Refresh.
9. Add a right bar button item, set it to Add.
10. Create all the outlets and actions you will need in their corresponding files.

## Datasource
DataSource and refresh
1. Create your fetchedPosts source of truth
2. Create your refresh method - This should use the post controllers fetched posts method to set the value of your source of truth and reload the tableView.
3. Make sure all UI changes are performed on the main Queue
4. Set up your tableView datasource methods, and set the text of the cells labels to the corresponding data

## Alert
Create your addReason alert
1. Create your textfields 
* var nameTextFieldForReason: UITextField?
* var reasonTextFieldForReason: UITextField?
* var cohortTextFieldForReason: UITextField?

2. Create your reasonAlert and set the title
3. Use the addTextField method to add your textfields to the alert
4. Create your cancel action
5. Create your add reason action
* Use the postControllers.postReason method to send your data to the endpoint.
* If successful, refresh. Make sure all UI changes are performed on the mainQueue — Talk to your mentor and make sure you are at least a 4 out of 5 before continuing. This is a very important concept to understand.
6. Present the alert
7. Run your app. Add your name, what cohort you’re in, and the reason you choose to learn iOS
8. Party.


## <a name='diamond'></a> Black Diamonds
* Allow editing of the cells
* Add mock students to test deleting the cells. DO NOT DELETE OTHER STUDENTS POSTS
* Have the reasons resize with the content


Contributions
Please refer to CONTRIBUTING.md.

Copyright
© DevMountain LLC, 2018. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
