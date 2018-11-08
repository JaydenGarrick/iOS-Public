# Alarm

### Part Two - Codable, Protocol Extensions, UserNotifications

* Create model objects that conform to the `Codable` protocol
* Create model object controllers that use `JSONEncoder` and `JSONDecoder` for data persistence
* Schedule and cancel `UserNotifications`
* Create custom protocols
* Implement protocol functions using protocol extensions to define protcol function behavior across all conforming types


## Part Two - Codable, Protocol Extensions & UserNotifications

### Conform to the Codable Protocol

Make sure your `Alarm` object conforom to the Codable protocol so that we can persist alarms across app launches using JSONEncoder and JSONDecoder.

1. Adopt the Codable protocol on your Alarm Model.  You should review Codable Protocol in the documentation before continuing.

### Persistence with FileManager

Add persistence using apple's FileManager API, Codable, and JSONEncoder and Decoder to the `AlarmController`. This will require three function `fileUrl() -> URL`, `saveToPersistentStore()`, and `loadFromPersistentStore() -> [Alarm]`.  This will follow the pattern use for persistence in Journal with a data type of Alarm instead of Entry.

1. Add a private, static, computed property called `fileUrl() -> URL` which returns the correct path to the alarms file in the app's documents directory as described above.
2. Write a private function called `saveToPersistentStorage()` that will save the current alarms array to a file using FileManager.
3. Write a function called `loadFromPersistentStorage()` that will load saved Alarm objects and set self.alarms (source of truth) to the results
4. Call the `loadFromPersistentStorage()` function when the AlarmController is initialized or in the AppDelegates `application(_:didFinishLaunchingWithOptions:)`
5. Call the `saveToPersistentStorage()` any time that the list of alarms is modified
*note: the list of alarms is modified in all of the CRUD fucntions for this app.
* note: You should now be able to see that your alarms are saved between app launches.

### Register the App for UserNotifications

Register for local notifications when the app launches.

1. In the `AppDelegate.swift` file, import `UserNotifications`. Then in the `application(_:didFinishLaunchingWithOptions:)` function, request notification authorization on an instance of `UNUserNotificationCenter`.
* note: See UserNotifications Documentation for furthur instrution: https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications

### Schedule and Cancel Local Notifications using a Custom Protocol and Extension

You will need to schedule local notifications each time you enable an alarm and cancel local notifications each time you disable an alarm. Seeing as you can enable/disable an alarm from both the list and detail view, we normally would need to write a `scheduleUserNotifications(for alarm: Alarm)` function and a `cancelUserNotifications(for alarm: Alarm)` function on both of our view controllers. However, using a custom protocol and a protocol extension, we can write those functions only once and use them in each of our view controllers as if we had written them in each view controller.
You will need to heavily reference Apples documentation on UserNotifications: https://developer.apple.com/documentation/usernotifications

1. In your `AlarmController` file, but outside of the class, create a `protocol AlarmScheduler`. This protocol will need two functions: `scheduleUserNotifications(for alarm:)` and `cancelUserNotifications(for alarm: Alarm)`.
2. Below your protocol, create a protocol extension, `extension AlarmScheduler`. In there, you can create default implementations for the two protocol functions.
3. Your `scheduleUserNotifications(for alarm: Alarm)` function should create an instance of `UNMutableNotificationContent` and then give that instance a title and body. You can also give that instance a default sound to use when the notification goes off using `UNNotificationSound.default()`.
4. After you create your `UNMutableNotificationContent`, create an instance of `UNCalendarNotificationTrigger`. In order to do this you will need to create `DateComponents` using the `fireDate` of your `alarm`.
*note: Use the `current` property of the  `Calendar` class to call a method which returns dateComponents from a date.
* note: Be sure to set `repeats` in the `UNCalendarNotificationTrigger` initializer to `true` so that the alarm will repeat daily at the specified time.
5. Now that you have `UNMutableNotificationContent` and a `UNCalendarNotificationTrigger`, you can initialize a `UNNotificationRequest` and add the request to the notification center object of your app.
* note: In order to initialize a `UNNotificationRequest` you will need a unique identifier. If you want to schedule multiple requests (which we do with this app) then you need a different identifier for each request. Thus, use the `uuid` property on your `Alarm` object as the identifier.
6. Your `cancelLocalnotification(for alarm: Alarm)` function simply needs to remove pending notification requests using the `uuid` property on the `Alarm` object you pass into the function.
* note: Look at documentation for `UNUserNotificationCenter` and see if there are any functions that will help you do this.  https://developer.apple.com/documentation/usernotifications/unusernotificationcenter/1649517-removependingnotificationrequest
7. Conform your AlarmController Class to the `AlarmScheduler` protocol. Notice how the compiler does not make you implement the schedule and cancel functions from the protocol? This is because by adding an extension to the protocol, we have created default implementation of these functions for all classes that conform to the protocol.
8. In your `toggleEnabled(for alarm: Alarm)` function, you will need to schedule a notification if the switch is being turned on, and cancel the notification if the switch is being turned off. You will also need to cancel the notification when you delete an alarm.

### UNUserNotificationCenterDelegate

The last thing you need to do is set up your app to notify the user when an alarm goes off and they still have the app open. In order to do this we are going to use the `UNUserNotificationCenterDelegate` protocol.

1. Go to your `AppDelegate.swift` file and have your `AppDelegate` class adopt the `UNUserNotificationCenterDelegate` protocol.
2. Then in your `application(_:didFinishLaunchingWithOptions:)` function, set the delegate of the notification center to equal `self`.
* note: `UNUserNotificationCenter.current().delegate = self`
3. Then call the delegate method `userNotificationCenter(_:willPresent:withCompletionHandler:)` and use the `completionHandler` to set your `UNNotificationPresentationOptions`.
* note: `completionHandler([.alert, .sound])`

The app should now be finished. Run it, look for bugs, and fix anything that seems off.

## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2015-2016. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
