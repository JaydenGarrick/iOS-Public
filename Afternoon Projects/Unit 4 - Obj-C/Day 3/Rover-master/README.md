# Rover

Please fork and clone this repository

Students will build an app to access the photos of NASA's Mars Rovers. This app will help students practice and solify the following concepts in Objective-C:
* Table Views
* Collection Views
* REST API calls
* Caching data
* Bridging Objective-C files so they are usable in Swift code.

Please note and be aware that parts of these instructions are intentionally vague as this is Unit 5, and you have accrued a lot of experience thus far. A decent portion of this app is fairly simple, and you have done these things many times (Table Views, model objects, etc.), simply not in Objective-C. Remember the 20 minute rule, and try Googling, looking at Stack Overflow, and use the documentation before you ask a mentor. This is for your own benefit to help you aquire the skills to find solutions independently.

## Part One - Model Objects and Mars Rover Client

Take the time to look through the documentation for the API [here](https://api.nasa.gov/api.html#MarsPhotos). It will be essential that you can navigate and know how to find the information needed from the API throughout the project, again as the instructions are intentionally vague.

There is a file called APIKeys.plist that should be in your project if you cloned the repo. This contains the API key for NASA's API, and returns it to you as an instance of `NSString`. There is an APIKeys.plist file in your project. Go to NASA's API documentation [here](https://api.nasa.gov/#live_example) and go through the process to get an API key. Once you're done, add the API key to the plist file as the value, and make the key `"APIKey"`. You will use this in the client later.

Use your API Key and what you learned from exploring NASA's API documentation to make various sample requests through a web browser or HTTP Client (e.g. Postman or Paw).  The following endpoints may be helpful in searching the API.  (You will have to add your API KEY onto each of these as a query parameter in order to recieve data.)

*The Base API URL (returns no data on its own):  [https://api.nasa.gov/mars-photos/api/v1?api_key={YOUR API KEY}](https://api.nasa.gov/mars-photos/api/v1)
*The list of mars rovers: [https://api.nasa.gov/mars-photos/api/v1/rovers?api_key={YOUR API KEY}](https://api.nasa.gov/mars-photos/api/v1/rovers)]
*A list of sol objects for a given rover:  https://api.nasa.gov/mars-photos/api/v1/manifests/{ROVER NAME}?api_key={YOUR API KEY}  [Example](https://api.nasa.gov/mars-photos/api/v1/manifests/curiosity)
*A list of photo objects for a given martian sol and rover:  https://api.nasa.gov/mars-photos/api/v1/rovers/{ROVER NAME}/photos?sol={NUMBER OF The SOL}&api_key={YOUR API KEY} [Example](https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=4)]

Each of these endpoints will provide you with the basis of one of you model objects.  Each will require its own fetch functions.  You should familiarize yourself with the structure of the json of each query.

#### Models Objects:
You will need three model objects in this project. First, a model representing a Mars rover, second, a photo that a rover took, and third, a description of each [sol](https://en.wikipedia.org/wiki/Timekeeping_on_Mars#Sols).


Create a new Cocoa Touch subclass of `NSObject` for each of these three model objects.

* Add properties for the following model objects.  Use the json trees above to determine the type of each property.  Assume all properties should be nonatomic and readonly: 

* **Rover**:
* Name of the rover
* The launch date 
* Landing date
* The max sol that represents the most recent sol that photos exist for the rover
* The max date (on Earth) that the photos exist for the rover 
* The status of the rover. Make an enum ( `NS_ENUM` ) representing either active or complete. Follow standard naming convention for `NS_ENUM`s. See [this](https://nshipster.com/ns_enum-ns_options/) for a good introduction to NS_ENUM syntax.
* The number of photos taken by the rover
* An array of sol descriptions

* **Photo**:
* The photo's identifier
* The sol it was taken
* The name of the camera that took the photo
* The Earth date it was taken
* The url to the image

* **Sol Description**:
* Which sol it is
* The amount of photos taken during the sol
* An array of cameras as strings

* On the photo model, you will have to add the Objective-C equivalent of the Equatable Protocol using the method `isEqual`.  This will simply be an instance function which returns a bool by comparingthe imageURL of the photo object you pass into the function to the url of self (the instance the function is called on).

* Think about where we're getting the data from, and create an appropriate initializer for each model object.   *Hint: Everything returned in JSON is contained in an Array or a __Dictionary__. You will need to reference the JSON for each model's respective endpoint heavily to create these initializers.
___

### Mars Rover Client:

Create a new Cocoa Touch subclass of `NSObject`called `MarsRoverClient` with a three letter prefix at the start. This will be where we make the network calls to get the JSON from NASA's API.

#### MarsRoverClient.h:
In the header file, create four instance method signatures:

1. `fetchAllMarsRoversWithCompletion` has a completion block as a parameter that returns an array of rover names, and an error.
2. `fetchMissionManifestForRoverNamed` takes in a string and has a completion block that returns an instance of your rover model, and an error
3. `fetchPhotosFromRover` that takes in an instance of your rover model, which sol you want photos for, and a completion block that returns an array of photos, and an error.
4. `fetchImageDataForPhoto` that takes in an instance of your photo model, and has a completion block that returns imageData ( `NSData`, not `Data` )

Look [here](http://rypress.com/tutorials/objective-c/blocks) and [here](http://www.appcoda.com/objective-c-blocks-tutorial/) at the sections named 'Blocks As Completion Handlers' for both of them for better understanding of blocks.

### MarsRoverClient.m:

#### Private methods:

In the .m file, add the following private **class** methods:

* Copy and paste this snippet. 

``` swift
+ (NSString *)apiKey {
static NSString *apiKey = nil;
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
NSURL *apiKeysURL = [[NSBundle mainBundle] URLForResource:@"APIKeys" withExtension:@"plist"];
if (!apiKeysURL) {
NSLog(@"Error! APIKeys file not found!");
return;
}
NSDictionary *apiKeys = [[NSDictionary alloc] initWithContentsOfURL:apiKeysURL];
apiKey = apiKeys[@"APIKey"];
});
return apiKey;
}
```
_This class computed property will return the API key from the info plist you inserted at the beginning of the project._

* Create a class method called `baseURL` that returns an instance of `NSURL` created from the base url of the API.
* Create a class method called `URLForInfoForRover` that takes in a string called 'roverName' and returns an `NSURL` pointing to the mission manifest of the rover passed in. (hint: It should return an instance of `NSURL` created using the baseURL and the information passed in to create a more specific url pointing to the information for that mission).  _Hint: You will need to construct your NSURL to access the lists of sols for a given rover endpoint mentioned at the beginning of this readme._

* Create a class method called urlForPhotosFromRover that takes in a string called 'roverName' and the sol that you want photos for, then like above, return a new, more specific `NSURL` pointing to the photos for the given rover and sol.  _Hint: You will need to construct your NSURL to access the list of photo objects for a given martian sol and rover mentioned at the beginning of this readme._

Make sure that you add the API key as one of the query items in both of your urls above.

#### Instance methods:

You will now fill out the methods that you defined in the .h file. 
1. `fetchAllMarsRoversWithCompletion` 
2. `fetchMissionManifestForRoverNamed`
3. `fetchPhotosFromRover` 
4. `fetchImageDataForPhoto` 
The following four methods will all use `NSURLSession`, and follow the same steps as in Swift to take a URL, get data from it, turn it into JSON, and then turn the JSON into our model objects. Since Objective-C does not have access to Swift's `Codable` protocol, we will need to follow the failable initializer method, using `[NSJSONSerialization JSONObjectWithData:]` to initialize a dictionary.  You will then need to call an initializer (which you should have written in each of your model objects) which takes in a dictionary (from the JSON) and returns an instance of the model.  Use the class methods we made above to generate the URLs necessary. Remember to look at what each method should return through the completion block for the end goal of the method.


## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2015. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
