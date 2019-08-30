# GeoStream
GeoStream is a test of OpenTok's video streaming API. It's essentially the streaming service Twitch but instead of selecting streams based on the names of streamers, you choose streams based on their **location**.

### Full disclosure, this was a quick hack and may be buggy. Everything seems to work right now but of course more testing is needed
* Only tested to work on iPhone XR, can't guarantee other iPhones...

### GeoStream makes use of the APIs
* [Firebase](https://firebase.google.com/)
	* For realtime database
* [OpenTok](https://tokbox.com/developer/)
	* For streaming
	* Server is deployed Heroku based on this [tutorial](https://tokbox.com/developer/tutorials/ios/swift/basic-video-chat/#requirements)

## Get Started
1. Welcome Page
<img src="https://github.com/ZiningW/GeoStream/raw/master/ReadMeImages/welcome.png" width="300">

2. Signup
* Signup by providing a username
* The next page will ask you to create a password if your account is not found
* If you don't want to signup, you can just use
	* Username: test@test.com
	* Password: 123456
* Authentification is facilitated using Firebase
<img src="https://github.com/ZiningW/GeoStream/raw/master/ReadMeImages/login.png" width="300">

2. Map View
* The interface is a simple map showing your location with a button to initialize a stream
<img src="https://github.com/ZiningW/GeoStream/raw/master/ReadMeImages/mainscreen.png" width="300">

* When a stream is initialized, you will show up to other users like so
<img src="https://github.com/ZiningW/GeoStream/raw/master/ReadMeImages/otherusers.png" width="300">

* You can join an existing stream by clicking on the video camera icon

3. Stream
* On the stream view, you can see what the other user is streaming
<img src="https://github.com/ZiningW/GeoStream/raw/master/ReadMeImages/stream.png" width="300">

* Leaving the stream takes you back to the Map view
* If you're the streamer and stop streaming, you will be removed from the map
* Any users that are not streaming will not show up on the map