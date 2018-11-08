# DeckOfOneCardObjectiveC

Day 2 S.D.P (Student - Daily- Project)

## Part 1
### API  and JSON
This is going to be a step by step challenge. This will be the easiest set of instructions since it's your first day networking in Objective C. Your future instructions will be more vague as you go through this unit. 
We are going to build an app where the user taps a button and that will draw a new card from a deck. This is going to be coming live from an API! Knowing how to get data from the web is a very important skill and it's not if, rather it's when you get asked in an interview on how to make async calls from an API or RESTful API. 
First head over to http://deckofcardsapi.com/ and study the documentation. The more you study the API, the more you will visualize what you can build. Every API is different, so it takes time to read the documentation. We want to draw a new card from a deck that will display the image of the card, and the suit as a label. What would be your base URL? 
We have all the tools we need in front of us just by using a new browser tap to test your url. If you plug in https://deckofcardsapi.com/api/deck/<<deck_id>>/draw/?count=1 you should get a "Not Found". That is because the <<deck_id>> needs to be swapped out with an actual deck ID or the word "new". To get a brand new deck, you could plug in https://deckofcardsapi.com/api/deck/new/
. When we do that we get back JSON, but there isn't a list or array that we can iterate through. We would only be able to display 
```
{
    "success": true,
    "deck_id": "3p40paa87x90",
    "shuffled": false,
    "remaining": 52
}
```
That's not enough information to build an app! However, we learned an important component about the url. We can use the key word "new" to get back a brand new deck and not have to worry about the deck_id. 
Now you should know what your base url is. Type what you think the url is before you see the solution. VERY IMPORTANT for you to know how to build a url and get back the correct JSON before you touch a line of code in Xcode. 
- URL 
Take this url https://deckofcardsapi.com/api/deck/<<deck_id>>/draw/?count=1 and the key word new to replace the <<deck_id>>
Let's take a moment and study this url. What does the https mean? What does the forward slash mean? What does the question mark mean? What does the equal sign mean? Take 10 minutes to look up these questions. 
The base url is a url that we start with in order to search based on the User Interaction. Take this url https://deckofcardsapi.com/api/deck/new/draw/ as your base url. The user is going to draw a card when they tap a button. We are going to add on the url using URLQueryItems which are search terms based on the user input. The question mark starts the query items which are a key-value-pair. The key is count and the vale is 1. The fully built url would like this https://deckofcardsapi.com/api/deck/new/draw/?count=1 . The key is before the question mark which is count and the value is after the equal sign which is one. 
This will summarize the 3 ways urls a built. REMEMBER THIS! You can give me a high-five later once you grasp it. 
1. The forward slash is a component. In Swift it is the appendingPathComponent(_:) method. 
2. Extensions are periods. In Swift that is the appendingPathExtension(_:) method. 
3. Search term items known as Query Items and parameters are URLQueryItem in Swift. 
Every api is built differently, using different ways to build a url.
### UI
![screenshot2](https://user-images.githubusercontent.com/23179585/46302204-b98a0880-c565-11e8-8d25-8b62c8cf5f48.jpg)

Now that we studied the API and url lets build our UI! Drag out a UIViewController with UIImageView, UIButton, and a UILabel. Press the shift key and embed the imageView and label in a UIStackView by clicking on downward arrow button in the bottom right of Xcode. Once it's in a stack view, click on the stack view from the view hierarchy and increase the spacing of the 3 objects up to 10 in the Attributes Inspector. Control drag from the stack view to the superview. You should see a window pop up. Holding the shift key select the Center Horizontal in Safe Area, Center Vertically in Safe Area, Equal Widths, and Equal Heights. Click on the update constrains button down at the bottom right of Xcode. You stack view should be the same size as the view for ever screen size. Make sure your stack view is selected and click on the Size Inspector (the ruler) and edit the Equal Width to: Superview to be 0.8 and the Equal Height to: Superview to be 0.7. Now our screen will be 10 points on the leading and trailing of every screen size device, wooo! 

### Model 
*vMake a new cocoa touch class named DVMCard. Paste the correct JSON into a JSON viewer. You should see 4 elements that are dictionaries. One of the elements is a key of cards and a value of an array of dictionaries. This is a beautiful JSON tree. We have a list of 52 cards (even though one is getting displayed). More importantly we have an array of dictionaries which is really easy to parse, serialize (look up JSONSerialization), and initialize the jsonData into our object. Which is AWESOME because once we turn the JSON into our object, we can do anything! 
Add 2 string properties of the suit and image in the .h file (the .h is the public file). Then add your initializer signature for your two properties, this will be the designated initializer which should have two parameters. The designated initializer plays an important role for a class. It ensures that inherited instance variables are initialized by invoking the designated initializer of the superclass (in this case NSObject). It is typically the init... method that has the most parameters and that does most of the initialization work .You need a second initializer that will have only one parameter of a dictionary which will be used from the JSON. This is known as a secondary initializer. Both these initializers are technically instance methods that begin with "init" and return an object of the dynamic type id (or properties). Every object that declares instance variables should implement an initializing method. This is a pattern that you should follow with  iOS O.O programing. Our .h file is complete! 
Note:
* Think of the .h like a protocol where you only define function parameters and initializers but don't actually implement the logic. The .m file is where we handle the actual implementation of the method signatures. 

* In the DVMCard.m file you should see a yellow warning. The warning is giving us a helpful hint to implement our 2 initializers. First, implement the designated initializer which is used to initialize our object with its 2 properties. All Objective C initializers are fallible, so you need to check ```if (self = [super init]) {```, then use the _underling values to equal the properties that come form the parameters, lastly return self. Now you have your designated initializer. 
Implement the secondary initializer. We know that we need to create 2 properties that are going to come back from the JSON dictionary.  Inside the initializer, first declare the type, add the pointer to the name, set it equal to the dictionary, and then using sub-script-notation plug in the key. Your first property. It should look like this NSString *suit = dictionary[@"suit"]; . Now do the same for your second property. Then return self with the initWithSuit (you designated initializer). 
To make our code a little safer you can add 2 class methods the return the string value key like 
```
+ (NSString *)suitKey
{
    return @"suit";
}

+ (NSString *)imageKey
{
    return @"image";
}
```
. Now your property should look like this  NSString *suit = dictionary[[DVMCard suitKey]];
Look at the Multiple Initializers and the Designated Initializer with this link if you get stuck.
https://developer.apple.com/library/archive/documentation/General/Conceptual/CocoaEncyclopedia/Initialization/Initialization.html
Our model object is complete. Nice work! 

## Part 2
### Controller 

* In the .h add the class initializer using the + rather than the - for the sharedController. This will set up our singleton. Now add the method signature to drawANewCard that will fetch out object. It will take in an NSInteger as a parameter, after the one an only parameter we need to have a completion closure block to fetch the array of our object and or an error. We will use light weight generics to specify that our array should be an array of DVMCard objects. The syntax looks like this completion: ```(void(^) (NSArray<DVMCard *> *cards, NSError *error))completion; ```
We can't forget about our image! We have the drawNewCard method signature to get back our object but we need to have another function to fetch the image data that comes after we got back out object. Once we have our object, we can use the imageString property to convert that into a url and make a request to get back data, turn that data into an actual image that will be displayed to the user. This is my favorite method to reverse-engineer because you can solve the puzzle backwards which connects the dots a little better and gives YOU the programmer a good strategy when you get stuck. The fetchCardImage method should take a parameter of DVMCard which will be the card object coming back from the JSON. Then write the completion closure to get back either a UIImage or and NSError. If you are getting a error, you need to import <UIKit/UIKit.h> and @class DVMCard; at the top. The difference between the @class and import is that Import gives you everything, its more like a copy and paste. The @class specifies that you are only going to use that class. The @class is a less expensive operation for the compiler because it doesn't have to import everything from the class. It has NO EFFECT on the user, we just want to help our compiler load time when we can. 
Now pop on over to our DVMCardController.h . First #import "DVMCard.h". We want to import because we need the initializers. Second add this snippet for the shared instance. Inside the implementation add a class method that takes in a (NSURL *) and returns the URLWithString

*Call the drawNewCard method. Inside this method we need to convert the NSInteger parameter into a NSString. It should look like this something like this  NSString *cardCount = [@(numberOfCards) stringValue];
Depending on what you named your parameter, I named the NSInteger parameter numberOfCards. Now we need to create NSURLComponents so we can build our url based on the users input from the UI. The componentsWithURL should take in the baseURl and resolvingAgainstBaseURL is set to true. We need to have a queryable url, because that is how this specific API constructed their url. Add NSURLQueryItem that will take the queryItemWIthName:@"count" (which is the key) and the value should be the cardCount. From the urlComponents instance property get the .queryItems and set it equal to an array of our queryItem.  Here is a good example to follow if you get stuck. http://arsenkin.com/URL-with-NSURLComponents-and-NSURLQueryItem-in-example.html
Now make the final NSURL that will be the searchURL, set it equal to urlComponents.URL; Which changes back the URLCompoents back into a NSURL.  Call NSURLSession saharedSession to get the dataTaksWIthURL method. This has the HTTP protocol "GET" built within it so we don't have to define our request. However, we would need to if we were using "POST".  Now we need to handle 3 objects that can come back from this async call. The data, the response, and the error. Lets focus on the data and error. If there is an error we want to see whats going on in the console so NSLog the error. Now check if there is not data, like so - if (!data) {
            /// handle the error 
}
* Now comes the good stuff, we need to create a NSDictionary which is going to be the jsonDictionaries that are coming back from the API. We will need to set it equal to NSJSONSerialization with JSONObjectWithData from the data coming back from URLSession. This will turn the data into a dictionary. Because the cards array is on the top level, use subscript-notation to get the key cards for the array of dictionaries. Like so: NSArray *cardsArray = jsonDictionaries[@"cards"];  Then we need to loop through cardsArray, which holds the list of dictionaries. For the cardDictionaries in the cardsArray create a DVMcard and set it equal to our model initWIthDictionary to convert the cardDictionaries into and instance of a card! Next, right above the for loop create a NSMutableArray *cardsPlaceholder and set it equal to [NSutableArray array]; Now we have something to fill each object with. Back inside the for loop, call the cardsPlaceholder and addObject: card];. Lastly outside of the for loop but above the resume];  call completion(cardsPlaceholder, nil); If it works we will complete with an array of cards and the error will be nil. Woah that's a lot to take in. But once you grasp it you'll repeat similar processes as an iOS developer. In English with what NSJSONSerilization does is that it takes info from the web and makes it presentable to a user on a mobile device. But we have to make a formula to grab that selected info and compact it into small bits, so we can later expand in-order for it to be displayed in the correct format for the user. Tech talk: info meaning data which are small binary bits. The result is that it will initialize JSON into our Object! Woo! 

* You know what time it is? It's time to get our image! This is my favorite part of the app. Once we got back our object we will have access to the image property which will hold the string value of the imageURL. All right, let's reverse-engineer this. We are ready to make our async call. Use [[NSURLSession sharedSession sharedSession] dataTaskWithURL:  completionHandler:^(NSData * data, NSURLResponse *  response, NSError * error) {. We know that we need to create a url and plug it in. Create a NSURL *imageURL setting it equal to [NSURL URLWithString: card.image]. Then add that value into the dataTaskWithURL. We are plugging the imageURL to make another async call to get back the image. Why though? Didn't we already make an async call? You bet! We had to fetch our object first in-order to get the image string property to make a network request that gets data, turns that data in to a iOS image which is UIImage initWithData. It's asking for data, so that's what we're gonna give it! Another reason is that images are larger bites of information so we need a separate task to go fetch it.
Handle the errors, also check if there is not data coming back. Then create a UIIMage *cardImage = [UIImage imageWithData: (plug in our data!)]; Lastly call our completion. Don't forget the resume! 

## Part 3
### DVMCardViewController 

* Hook up the two outlets for the UIImageImageView and the UILabel. Add an action for the button to draw a card. For the views to display we need to call our 2 methods in the DVMCardController. Make a new method -(void)updateViews {. Call the  [[DVMCardController sharedController] drawNewCard method. Plug in the amount of cards you want the user to see in the drawNewCard parameter. We have an array coming back so we need to get one card out of the array of cards. Try this on your own for 5 minutes. You should come up with something like this DVMCard *card = [cards objectAtIndex:0]; . Now we want UI elements to be on the main thread. First, the string of the card suit will comeback. It should look like this     
dispatch_async(dispatch_get_main_queue(), ^{
            self.suitLabel.text = card.suit;
        });
After that, but still within the drawNewCard scope, add 
 [[DVMCardController sharedController] fetchCardImage:card completion:^(UIImage *image, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.cardImageView.image = image;
            });
* This will take in the same card object that we fetched first, that way we have the single card to plug in to fetch the image. Lastly we dispatch the cardIMageView on to the main thread, where we are completing with an image and setting it equal to the UIIMageView outlet. You may need to check your p-list. And just like that we got a simple card app! Nice work. 
