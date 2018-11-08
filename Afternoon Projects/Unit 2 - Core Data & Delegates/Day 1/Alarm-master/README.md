# Alarm

Students will build a simple alarm app to practice intermediate table view features, protocols, the delegate pattern, Codable, and UserNotifications.

Students who complete this project independently are able to:

### Part One - Intermediate TableViews, Delegate Pattern

* Implement a master-detail interface
* Implement the `UITableViewDataSource` protocol
* Implement a static `UITableView`
* Create a custom `UITableViewCell`
* Write a custom delegate protocol
* Wire up view controllers to model object controllers
* Work with the `Date` and `Calendar` of Swift
* Add staged data to a model object controller

### Part Two - Codable, Protocol Extensions, UserNotifications

* Create model objects that conform to the `Codable` protocol
* Create model object controllers that use `JSONEncoder` and `JSONDecoder` for data persistence
* Schedule and cancel `UserNotifications`
* Create custom protocols
* Implement protocol functions using protocol extensions to define protcol function behavior across all conforming types

## Part One - Intermediate TableViews, Delegate Pattern

### View Hierarchy

Set up a basic List-Detail view hierarchy using a UITableViewController for a AlarmListTableViewController and a AlarmDetailTableViewController. Use the provided screenshots as a reference.

1. Add a `UITableViewController` scene that will be used to list alarms
2. Embed the scene in a `UINavigationController`
3. Add an 'Add' system bar button item to the navigation bar
4. Add a class file `AlarmListTableViewController.swift` and assign the scene in the Storyboard
5. Add a `UITableViewController` scene that will be used to add and view alarms
* note: We will use a static table view for our Alarm Detail view, static table views should be used sparingly, but they can be useful for a table view that will never change, such as a basic form. You can make a table view static by selecting the table view, going to the Attribute Inspector, and changing the Content dropdown from Dynamic Prototypes to Static Cells.
6. Add a show segue from the Add button from the first scene to the second scene.
7. Add a show segue from the prototype cell form the first scene to the second scene.
8. Add a class file `AlarmDetailTableViewController.swift` and assign the scene in the Storyboard

### Custom Table View Cell

Build a custom table view cell to display alarms. The cell should display the alarm time, the alarm name, and have a switch that will toggle whether or not the alarm is enabled.

It is best practice to make table view cells reusable between apps. As a result, you will build a `SwitchTableViewCell` rather than an `AlarmTableViewCell` that can be reused any time you want a cell with a switch.

1. Add a new `SwitchTableViewCell.swift` as a subclass of UITableViewCell.
2. Configure the prototype cell in the Alarm List Scene in `Main.storyboard` to be an instance of `SwitchTableViewCell`
3. Design the prototype cell as shown in the screenshots: two labels, one above the other, with a switch to the right.
* note: Stack views are great. Think about using a horizontal stack view that has a vertical stack view and a switch inside of it. The vertical stack view will have two labels in it.
4. Create an IBOutlet to the custom cell file for the label named `timeLabel`.
5. Create an IBOutlet to the custom cell file for the label named `nameLabel`.
6. Create an IBOutlet to the custom cell file for the switch named `alarmSwitch`.
7. Create an IBAction for the switch named `switchValueChanged` which you will implement using a custom protocol later in these instructions.

### Static Table View

Build a static table view as the detail view for creating and editing alarms.

1. Static table views do not need to have UITableViewDataSource functions implemented. Instead, you can create outlets and actions from your prototype cells directly onto the view controller (in this case `AlarmDetailTableViewController`) as you would with other types of views.
2. If you haven't already, go to your Storyboard, select your detail table view and in the Attributes Inspector change the Style to Grouped and the Sections to 3. By default each section will have 3 cells in it. You can delete 2 of the cells in each section.
3. In section 1, drag a date picker onto the prototype cell and add proper constraints.
4. In section 2, drag a text field onto the prototype cell and add the proper constraints and placeholder text.
5. In section 3, drag a button onto the prototype cell and add the proper constraints and title. This button will be used to enable/disable existing alarms.
6. Create IBOutlets for the three items listed above and create an IBAction for the button titled `enableButtonTapped`.
7. If you haven't already, add a bar button item to the right side of the navigation bar, change the System Item to Save in the Attributes Inspector, and create an IBAction called `saveButtonTapped`.
* You will need to add a Navigation Item to the Navigation Bar before you can add the bar button item.

###  Alarm Model Object

Create an `Alarm.swift` which will contain our Alarm model object.  Alarms should be able to represent a name, whether they are enabled (on or off), a unique identifier,  a time when the alarm will go off, and a string representation of that time.

1. Add a property called `fireDate` which stores a `Date` representing the time the alarm will go off , a property called `name` of type `String`, and a property called `enabled` of type`Bool` that we will set to true if the alarm is enabled and false otherwise.
2. Add a property called uuid of type `String`.  A UUID is a Universally Unique Identifier. The `uuid` on the Alarm object will be used later to schedule and cancel local notifications
4. Add a computed property called `fireTimeAsString` which will return a `String` representation of the time you want the alarm to fire. This is simply for the UI.
*note: Use Apple's DateFormater class to return a String from your existing  `fireDate` property.
*Please Read: https://developer.apple.com/documentation/foundation/dateformatter

### AlarmController (Model Controller Object)

Create an `AlarmController` model object controller that will manage and serve `Alarm` objects to the rest of the application.

1. Create an `AlarmController.swift` file and define a new `AlarmController` class.
2. Add an `alarms` array property with an empty array as a default value.
3. Create an `addAlarm(fireDate: Date, name: String, enabled: Bool)` function that creates an alarm, adds it to the `alarms` array, and returns the alarm.
4. Create an `update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool)` function that updates an existing alarm's fire time and name.
5. Create a `delete(alarm: Alarm)` function that removes the alarm from the `alarms` array
* note: There is no 'removeObject' function on arrays. You will need to find the index of the object and then remove the object at that index. Refer to documentation if you need to know how to find the index of an object.
* note: You will need to conform your `Alarm` model to the  `Equatable` protocol and implement the proper equality check.
6. Create a static `shared` property that stores a shared instance.
* note: Review the syntax for creating shared instance properties

### Controller Staged Data Using a Mock Data Function

Add mock alarm data to the AlarmController. Using mock data can be very useful. Once there is mock data development teams can serialize work -- i.e. some can work on the views with visible data while others work on implementing the controller logic. This is a quick way to get objects visible so you can begin building the views.

There are many ways to add mock data to model object controllers. We will do so using a computed property.

1. Create a `mockAlarms:[Alarm]` computed property that holds a number of staged `Alarm` objects
* Initialize a small number of `Alarm` objects to return with varying properties
2. When you want mock data, set self.alarms to self.mockAlarms in the `AlarmController` initializer. Remove it when you no longer want mock data.

### Wire up the Alarm List Table View and implement the property observer pattern on the `SwitchTableViewCell` class.

Fill in the table view data source functions required to display the view.
*note: these implementation will be very similar to your Journal application with the exception of the `cellForRowAt`.  Insead of setting the `cell.textLabel.text` property directly from the tableViewController, you will pass an alarm object into a variable within your custom cell class i.e. `cell.alarm = alarm`

Your custom cell should follow the 'updateViews' pattern for updating the view elements with the details of a model object. To follow this pattern, the developer adds an 'updateViews' function that checks for a model object. The function updates the view with details from the model object.

1. Add a property `var alarm: Alarm?` to your `SwitchTableViewCell` class.
*note: This will act very similar to the way we have used variables as "Landing Pads" or "Mail boxes" in Detail ViewControllers
2. Add an `updateViews()` function that updates the labels to the time and name of the alarm, and updates the `alarmSwitch.isOn` property so that the switch reflects the proper alarm `enabled` state.
3. Add a `didSet` observer on the alarm property, and call the `updateViews()` function you just made in it.
4. On your `AlarmListTableViewController` fill in the two required `UITableViewDataSource` functions, using the `alarms` array from `AlarmController.shared`. In the `tableView(UITableView, cellForRowAt: IndexPath)` data source function you will need to cast your dequeued cell as a `SwitchTableViewCell` and set the cell's `alarm` property. Make sure you use the right alarm from the `alarms` array in `AlarmController`.
5. Implement the `UITableViewDataSource` `tableView(_:, commit:, forRowAt:)` method to enable swipe-to-delete. Be sure to call the appropriate `AlarmController` method before deleting the row.
* At this point you should be able to run your project and see your table view populated with your mock alarms. You should be able to delete rows and segue to a detail view (this detail view won't actually display an alarm yet since we haven't implemented the `prepare(for segue: UIStoryboardSegue, sender: Any?)` function, but the segue should still occur). Also note that you can toggle the switch, but that the `enabled` property on the model object the cell is displaying isn't actually changing.

### Custom Protocol

Write a protocol for the `SwitchTableViewCell` to delegate handling a toggle of the switch to the `AlarmListTableViewController`, adopt the protocol, and use the delegate function to mark the alarm as enabled or disabled and reload the cell.

1. Create a custom protocol named `SwitchTableViewCellDelegate` to the top of the `SwitchTableViewCell` class file
2. Define a `switchCellSwitchValueChanged(cell: SwitchTableViewCell)` function
3. Add a weak, optional delegate property on the SwitchTableViewCell
* note: `weak var delegate: SwitchTableViewCellDelegate?`
* note: If the compiler throws an error, it is likely because your protocol must be restricted to class types.
4. Update the `switchValueChanged(_:)` IBAction to check if a delegate is assigned, and if so, call the delegate protocol function
5. Adopt and conform to the protocol in the `AlarmListTableViewController` class.
6. In the `cellForRowAt` function in the `AlarmListTableViewController` set self (the AlarmListTableViewController in this instance) as the delegate of each cell.
7. Go to your `AlarmController` class and add a `toggleEnabled(for alarm: Alarm)` function that will switch the `enabled` property of the `alarm` in your function parameter to true if it is false, and false if it is true.
8. Go back to your `AlarmListTableViewController` class and implement the `switchCellSwitchValueChanged(cell:)` delegate function to capture the alarm, toggle the alarm's enabled property using the function you just made in `AlarmController`, and reload the table view.

### Wire up the Alarm Detail Table View

Create functions on the detail table view controller to display an existing alarm and setup the view properly.

1. Add an `alarm` property of type `Alarm?` to `AlarmDetailTableViewController`. This will hold an alarm if the view is displaying an existing alarm and will be nil if the view is being used to create a new alarm.
2. Add a variable named `alarmIsOn` of type Bool with an initial value of `true` to the top of your `AlarmDetailTableViewController` class.
*note: Make sure to set the `alarmIsOn` property equal to the `alarm.enabled` property in the case that the alarm object exists.
2. Create a private `updateViews()` function that will populate the date picker and alarm title text field with the current alarm's date and title. This function will set the enable button to say "On" if the alarm in `self.alarm` is enabled and "Off" if it is disabled. You may consider changing background color and font color properties as well to make the difference between the two button states clear. 
*note: As the initial `alarm` property will be nil (when we are creating a new alarm), you will need to use the isAlarmOn property you created earlier to set up the button's UI initially.
*note: You must guard against the alarm being nil, or the view controller's view not yet being loaded and properly handle these cases.
3. Create a `didSet` property observer on the `alarm` property and call `updateViews()`.
*note: It is safest to call `loadViewsIfNeeded()` in any `didSet` before `updateViews()` to avoid any race conditions.

### Prepare For Segue

Fill in the `prepare(for segue: UIStoryboardSegue, sender: Any?)` function on the `AlarmListTableViewController` to properly prepare the next view controller for the segue.

1. In the `AlarmListTableViewController`, add an if statement in the `prepare(for segue: UIStoryboardSegue, sender: Any?)` function that checks if the segue's identifier matches the identifier of the segue that goes from a cell to the detail view.
2. Get the destination view controller from the segue and cast it as an `AlarmDetailTableViewController`.
3. Get the indexPath of the selected cell from the table view.
4. Use `indexPath.row` to get the correct alarm that was tapped from the `AlarmController.shared.alarms` array.
5. Set the `alarm` property on the destination view controller equal to the alarm from the previous step.
* If the compiler presents an error when trying to do this, you either forgot to cast the destination view controller as an `AlarmDetailTableViewController` or forgot to give the `AlarmDetailTableViewController` a property title `alarm` of type `Alarm?`.
* At this point you should be able to run your project and see your table view populated with your mock alarms, displaying the proper switch state. You should also be able to delete rows, and segue to a detail view from a cell. This detail view should display the proper time of the alarm, the proper title, and the proper state of the enable/disable button.

### Final functionality on the detail view

Fill in the `saveButtonTapped` function on the detail view so that you can add new alarms and edit existing alarms.

2. Unwrap `alarm` and if there is an alarm, call the `.update(alarm: , name: , fireDate: , enabled: )` function from the `AlarmController` and pass in the tite from the text field, the fireDate from the datePicker, and the enabled from the `alarmIsOn` property.
3. If there is no alarm, call the ` addAlarm(fireDate: , name: , enabled: )` function to create and add a new alarm.
* note: You should be able to run the project and have what appears to be a fully functional app. You should be able to add, edit, delete, and enable/disable alarms. We have not yet covered how to alert the user when time is up, or persist the alarms.

## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2015-2016. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
