# AutoAddress
### Ambulnz iOS Coding Challenge
### Submitted: March 13, 2019
### Author: Mike Jones

## Solution Parts
### Server
Language: PHP
Description:  A bare-bones web-service that wraps the Google Places API.  
The source code can be found under the "server" directory in this same repository and is currently 
hosted on my personal server at: www.dreamwaresys.com.

### Client
AutoAddress iOS App
Language: Swift 4 / XCode 10.1
Description:  The app uses no 3rd party libraries. While there are many 3rd-party libraries that would would have been useful, I am of the 
opinion that Senior Engineers should be able to code without them.  All bonus features are included in the app with the one exception of the 
driving route between locations.  I made the mistake of implementing Google's MapKit only to later realize that it does not 
support road directions.   If I had unlimited time, I would revert to using Apple's MapKit.
