# Task

### Part Two - NSFetchedResultsController

* use an NSFetchedResultsController to populate a UITableView with information from Core Data
* implement the NSFetchedResultsControllerDelegate to observe changes in Core Data information and update the display accordingly

## Part Two - NSFetchedResultsController

### Prepare Project to use NSFetchedResultsController

An NSFetchedResultsController has properties that allow you to access fetched objects, thereby replacing the `tasks` array that is currently on the TaskController. It also takes the place of the `fetchTasks()` function. Consequently, you will delete those items from the TaskController and remove the TaskListTableViewController entirely and start from scratch.

1. Delete your `tasks` array.
2. Delete your `fetchTasks()` function and all references to it.
3. Delete your entire file `TaskListsTableViewController.swift`.
    * note: When prompted and asked whether to remove reference or move to trash, choose move to trash.


### Add an NSFetchedResultsController to TaskController

NSFetchedResultsController is an API that allows you to easily sync a table view with information stored in Core Data. In order to use it, you must initialize it with an NSFetchRequest, a managed object context, the name of the variable you want your sections divided by, and an optional cache name. In our case, we do not need a cache, so we will leave it as nil.

1. Add a constant to your `TaskController` called `fetchedResultsController` that is of type `NSFetchedResultsController<Task>`. 
2. You should get a compiler error saying you need to initialize this property. In your initializer, create a fetch request similar to the one you had before, but with a sort descriptor for `isComplete` and a sort descriptor for `due`, in that order. This ensures that the tasks will be sorted by whether or not they are complete first and then by their due date.
3. Initialize your fetchedResultsController using your fetch request, `CoreDataStack.context`, and the key by which you want to divide sections (we want a section for incomplete tasks and a section for complete tasks).


### Perform Fetch Using NSFetchedResultsController

An NSFetchedResultsController will keep you updated of any changes to the data in your Core Data model once a fetch has been performed, but you still must perform the initial fetch.

1. Inside your initializer, after having initialized your fetchedResultsController, you will need to call `performFetch()` on it.
    * note: You will need to use the do, try, catch syntax since `performFetch()` is a throwing function. The catch should print out an error if there is one.


### Basic Task List View

Rebuild a view that lists all tasks. You will use a UITableViewController and implement the UITableViewDataSource functions. Apple's documentation for an NSFetchedResultsController describes exactly how to implement the UITableViewDataSource functions. There are examples in Swift beneath each Objective C example. However, note that the style differs slightly from the style you have been taught here at DevMountain. You should do your best to keep your code style consistent to what we have been learning the last weeks (i.e. safely unwrapping optionals, etc.). You can find the example needed in the section titled "Integrating the Fetched Results Controller with the Table View Data Source" in the [Core Data Programming Guide](https://developer.apple.com/library/mac/documentation/Cocoa/ConceptualCoreDataStacknsfetchedresultscontroller.html).

You will want this view to reload the table view each time it appears in order to display newly created tasks.

1. Implement the `numberOfSections(in:)` function. Remember to use documentation for help on this.
2. Implement the `numberOfRows(inSection:)` function.
3. Implement the `cellForRow(at indexPath: IndexPath)` function by dequeuing your cell and casting it as your custom cell, getting the right task object, calling your custom cell's `update(withTask:)` function, and setting the cell's delegate. Don't forget to adopt and conform to the `ButtonTableViewDelegate` protocol. We will implement the delegate method later. 
4. Implement the `tableView(_:titleForHeaderInSection:)` function to return the proper section title. There is no example of this in the Core Data Programming Guide. However, each object in the array of `NSFetchedResultsSectionInfo` objects that you get from the Fetched Results Controller contains a name property that is a string representing the index of the section. You can convert this to an `Int` and use it to determine whether your header should say "Incomplete" or "Complete". Use the `sections` property on your `fetchedResultsController` to get your array of `NSFetchedResultsSectionInfo` objects.
4. Implement your `prepare(for segue: NSStoryboardSegue, sender: Any?)` function to pass the selected task and the selected task's `due` value to the next screen if a cell was tapped.


### List View Editing

Add swipe-to-delete support for deleting tasks from the List View and implement the `ButtonTableViewCellDelegate` function.

1. Go to your UITableViewDataSource `tableView(_:commit:forRowAt:)` function to enable swipe to delete functionality. When committing the editing style, delete the model object from the controller, but do not delete the cell from the table view. We will implement an `NSFetchedResultsControllerDelegate` method to do this once the object is deleted.
    * note: Use `TaskController.shared.fetchedResultsController.object(at: indexPath)` to get the correct `Task` object to delete.
2. Go to your `ButtonTableViewCellDelegate` function and call `TaskController.shared.toggleIsCompleteFor(task: task)` to toggle the `isComplete` property on the passed in `Task` object.
    * note: Again, use `TaskController.shared.fetchedResultsController.object(at: indexPath)` to get the correct `Task` object. You'll also have to use `sender` to get the correct index path.


### Using the NSFetchedResultsControllerDelegate

Use `NSFetchedResultsControllerDelegate` functions to be notified of and respond to changes in the underlying Core Data information. The Core Data Programming Guide has examples of this as well in the section "Communication Data Changes to the Table View".

1. Import `CoreData` into the TaskListTableViewController and then adopt the `NSFetchedResultsControllerDelegate` protocol in the class signature.
2. In `viewDidLoad()` set `self` as the delegate for the `fetchedResultsController` on the `TaskController`.
3. Look up `NSFetchedResultsControllerDelegate` in documentation. There are four functions that are called when the controller's fetch results have changed that will update the table view to correctly display the right data. You will need to implement all of them, so write the function signatures for all of them.
4. The delegate function `controllerWillChangeContent(_:)` will be called before any change occurs and the delegate function `controllerDidChangeContent(_:)` will be called after changes occur. Sometimes there will be multiple changes that need to occur to a table view, some of which need to happen simultaneous to other changes. For this to work, the table view needs to know to execute all changes at the same time. This is done by calling `tableView.beginUpdates()` and then after all of the changes have been made, calling `tableView.endUpdates()`. You should begin updates in the function that will be called before changes happen and you should end updates in the function that will be called after those changes happen.  
5. The delegate method `controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)` tells you what type of change has happened, whether an object was added, deleted, moved, or updated. To be safe, we should check for the type of change and respond accordingly. This is a great situation to use a switch statement. Go ahead and switch on `type` with the four different cases: `.delete`, `.insert`, `.move`, and `.update`. 
6. For the `.delete` case, you simply need use the line of code you included in your `tableView(_:commit:forRowAt:)` function before you deleted the `TaskListTableViewController.swift` file: `tableView.deleteRows(at: [indexPath], with: .fade)`. This is because when you delete an object, this delegate function will be called and you want the table view to reflect the changes made in your fetch results.
    * note: Be sure to safely unwrap `indexPath`
7. For the `.insert` case, you can use a similar line of code to insert a row at a given indexPath: `tableView.insertRows(at: [newIndexPath], with: .automatic)`.
8. Using the two table view functions used in the previous two steps, attempt to fill out the `.move` case.
9. Search documentation to find a table view function that you can use to reload a row at a given index path in order to implement the `.update` case.
10. The delegate method `controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)` will be called if a section needs to be added or deleted. Again, the `type` variable passed into the function will tell you if a section needs to be added or deleted. Use documentation and the Core Data Programming Guide to implement this function.

The app is now finished. Run it, check for bugs, and fix any that you find.


## Contributions

Please refer to CONTRIBUTING.md.


## Copyright

© DevMountain LLC, 2015. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
