# Journal

### Level 1

Students will build a simple journal app to practice MVC separation, protocols, master-detail interfaces, table views, and persistence.

Journal is an excellent app to practice basic Cocoa Touch principles and design patterns. Students are encouraged to repeat building Journal regularly until the principles and patterns are internalized and the student can build Journal without a guide.

Students who complete this project independently are able to:

### Part One - Model Objects and Controllers

* Understand basic model-view-controller design and implementation
* Create a custom model object with a memberwise initializer
* Understand, create, and use a shared instance
* Create a model object controller with create, read, update, and delete functions
* Implement the Equatable protocol

### Part Two - User Interface

* Implement a master-detail interface
* Implement the `UITableViewDataSource` protocol
* Understand and implement the `UITextFieldDelegate` protocol to dismiss the keyboard
* Create relationship segues in Storyboards
* Understand, use, and implement the 'updateViews' pattern
* Implement 'prepare(for segue: UIStoryboardSegue, sender: Any?)' to configure destination view controllers

### Part Three - Controller Implementation

* Add data persistence using the Codable protocol and write data to a local file path (URL).
* Upon launch, decode the data returned from the local file path (URL) back into our custom model objects.

## Part One - Model Objects and Controllers

### Entry

Create an Entry model class that will hold title, text, and timestamp properties for each entry.

1. Add a new `Entry.swift` file and define a new `Entry` class
2. Add properties for timestamp, title, and body text
3. Add a memberwise initializer that takes parameters for each property
* Consider setting a default parameter value for timestamp.

### EntryController

Create a model object controller called `EntryController` that will manage adding, reading, updating, and removing entries. We will follow the shared instance design pattern because we want one consistent source of truth for our entry objects that are held on the controller.

1. Add a new `EntryController.swift` file and define a new `EntryController` class inside.
2. Add an entries array property, and set its value to an empty array
3. Create a `addEntryWith(title: ...)` function that takes in a `title`, and `text`, creates a new instance of `Entry`, and adds it to the entries array
4. Create a `remove(entry: Entry)` function that removes the entry from the entries array
* There is no 'removeObject' function on arrays. You will need to find the index of the object and then remove the object at that index.
* You will face a compiler error because we have not given the Entry class a way to find equal objects. You will resolve the error by implementing the Equatable protocol in the next step.

5. Create an `update(entry: ...)` function that should take in an existing entry as a parameter, as well as the title and text strings to update the entry with
6. Create a `shared` property as a shared instance
* Review the syntax for creating shared instance properties

### Equatable Protocol

Implement the Equatable protocol for the Entry class. The Equatable protocol allows you to check for equality between two variables of a specific class. You may use the ObjectIdentifier() function on class types, but you may decide to manually check the values of the title, text, and timestamp properties.

1. Add the Equatable protocol function to the top or bottom of your `Entry.swift` file
2. Return the result of a comparison between the `lhs` and `rhs` parameters using ObjectIdentifier() or checking the property values on each parameter

## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2015. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.

