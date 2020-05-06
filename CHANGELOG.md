## [Unreleased]

### Added
- **Breaking** Added addtional fields for `CreateAttendeeResponse` and `CreateMeetingResponse`
- Added `Versioning` class and `sdkVersion` API for retrieving current version of SDK
- Added `init(frame: CGRect)` initializer in `DefaultVideoRenderView` to properly initialize `DefaultVideoRenderView` in ObjC code.
- Added basic video features and `MetricsObserver` callback handler in the ObjC demo app.

### Changed
- Updated demo app to work with updated [amazon-chime-sdk-js serverless demo](https://github.com/aws/amazon-chime-sdk-js/tree/master/demos/serverless). Note that you need to redeploy the serverless demo to work with the updated demo app
- Changed the default observer caller implementation. Now all the observer callbacks are called on main thread. Make sure to dispatch long-running tasks to another thread to avoid blocking the main thread.

## [0.5.2] - 2020-04-28

### Changed
- Turn on library evolution and module stability

## [0.5.1] - 2020-04-23

### Added
- Added full bitcode support in `AmazonChimeSDKMedia.framework` and `AmazonChimeSDK.framework`. Also added corresponding versions without bitcode. Links can be found in the README file.

### Fixed
* Fix bug where external id for self is sometimes empty

## [0.5.0] - 2020-03-27

### Changed
- Enable BUILD_LIBRARY_FOR_DISTRIBUTION to add Xcode 11.4 (Swift 5.2) support

## [0.4.0] - 2020-03-24
