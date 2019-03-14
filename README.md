# AutoAddress

Ambulnz iOS Coding Challenge
<br />
**Submitted**: March 13, 2019
<br />
**Author**: Mike Jones

## Solution Parts

### Server
**Path:** Server/<br />
**Language**: PHP<br /><br />
**Description**: <br />
A bare-bones web-service that basically wraps the Google Places API and consolidates some of the response data in order to reduce the parsing required by the client. For the purposes of demo'ing the app, the server code is currently hosted on my personal LNMP server at: www.dreamwaresys.com.
The following three endpoints are implemented:
1. Google Places Auto-completion`
2. Google GeoLocation Fetch (in order to fetch a selected Place's Latitude/Longitude)
3. Google Places Search (not currently used)

### Client
**Path:** Client/<br />
**Language**: Swift 4<br />
**IDE**: XCode 10.1<br />
**Target**: Universal (iPhone + iPad)<br /><br />
**Description**: <br />
Aside from Google's MapKit SDK (for showing the map) the solution uses no 3rd-party libraries. While 3rd-party libraries may have made my life much easier, I am of the stubborn opinion that Senior Engineers should be able to code without them.  Most of the bonus features are included in the solution with the notable exception of placing a "drivable" route between the two locations on the map.  I made the mistake of implementing Google's MapKit only to later realize that Google's MapKit SDK does not support road routes.  If I had unlimited time, I would revert to using Apple's MapKit but alas, I had to step away from the keyboard at some point.

<br /><br />
Regardless of the outcome, thank you for the opportunity and I appreciate your time.  - Mike
