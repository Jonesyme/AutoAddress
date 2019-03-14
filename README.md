# AutoAddress

Ambulnz iOS Coding Challenge
<br />
**Submitted**: March 13, 2019
<br />
**Author**: Mike Jones

## Solution Parts

### Server
**Path:** Server/<br />
**Language**: PHP<br />
**Description**: <br />
A bare-bones web-service that wraps the Google Places API.  The source is mostly self-explainatory and for the purposes of demo'ing the client app is currently hosted on my personal LNMP server at: www.dreamwaresys.com.

### Client
**Path:** Client/<br />
**Language**: Swift 4<br />
**IDE**: XCode 10.1<br />
**Description**: <br />
The app uses no 3rd party libraries. While there are many 3rd-party libraries that would have been very useful, I am of the 
opinion that Senior Engineers should be able to write native code without them.  Most of the bonus features are included in the solution with the notable exception of placing a "drivable" route between the two locations on the map.  I made the mistake of implementing Google's MapKit only to later realize that Google's MapKit SDK does not support road routes.  If I had unlimited time, I would revert to using Apple's MapKit but alas, I had to step away from the keyboard at somepoint.

<br /><br />
Regardless of the outcome, thank you for the opportunity and I appreciate your time.  - Mike
