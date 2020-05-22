## [0.6.1] - 2020-05-22

### Added
- Added `attendeesDidDrop` API in `RealtimeObserver` for attendee who got dropped

## [0.6.0] - 2020-05-14

### Added
- **Breaking** Added additional fields for `CreateAttendeeResponse` and `CreateMeetingResponse`
- Added `Versioning` class and `sdkVersion` API for retrieving current version of SDK
- Added `init(frame: CGRect)` initializer in `DefaultVideoRenderView` to properly initialize `DefaultVideoRenderView` in ObjC code.
- Added basic video features and `MetricsObserver` callback handler in the ObjC demo app.
- Added `audioSessionDidDrop` API in `AudioVideoObserver` for temporary disconnects
- Added multiple video tiles support in Swift demo app.
- Added attendee name label in Swift demo app.
- Added new parameter `urlRewriter` in `MeetingSessionConfiguration` for customizing url

### Changed
- Updated demo app to work with updated [amazon-chime-sdk-js serverless demo](https://github.com/aws/amazon-chime-sdk-js/tree/master/demos/serverless). Note that you will need to redeploy the serverless demo to work with the updated demo app
- Updated methods for `AudioVideoObserver`, `RealtimeObserver`, `DeviceChangeObserver`, `VideoTileObserver`, and `MetricsObserver` to be called on main thread. Make sure to dispatch long-running tasks to another thread to avoid blocking the main thread.

### Fixed
- Fixed main thread freezing issue caused by calling `stop()` when in reconnecting state
- Fixed a bug where `audioSessionDidStopWithStatus()` was not getting called after calling `stop()`
- Fixed an issue in `bindVideoView()`, unbind first to prevent unexpected side effect.
- Fixed an issue that blocked user from removing paused video tiles.

## [0.5.2] - 2020-04-28

### Changed
- Turn on library evolution and module stability

## [0.5.1] - 2020-04-23

### Added
- Added full bitcode support in `AmazonChimeSDKMedia.framework` and `AmazonChimeSDK.framework`. Also added corresponding versions without bitcode. Links can be found in the README file.

### Fixed
- Fix bug where external id for self is sometimes empty

## [0.5.0] - 2020-03-27

### Changed
- Enable BUILD_LIBRARY_FOR_DISTRIBUTION to add Xcode 11.4 (Swift 5.2) support

## [0.4.0] - 2020-03-24
