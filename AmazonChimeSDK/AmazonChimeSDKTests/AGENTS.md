# AmazonChimeSDK XCTest Guidance

## Spy Verification

Tests use handwritten spies and the verification helpers in `common/CommonTestCase.swift`. Do not add Cuckoo, generated mocks, or method-specific verifier proxies without explicit approval.

- Prefer `verify`, `verifyEqual`, and `verifyIdentical` over direct assertions on spy call counts.
- Use `never()` and `times(_:)` for non-default expected call counts.
- Preserve existing matcher semantics. In particular, arguments previously matched with Cuckoo's `any()` must remain unconstrained unless the test already asserted their values.
- When wrapping these helpers, forward `file: StaticString = #filePath` and `line: UInt = #line` so failures point to the test call site.
- Keep equality and identity helpers under distinct names. Do not add `verify` overloads for values or object identity; those generic overloads caused Swift type-checking timeouts on complex predicates.

```swift
// Exactly one recorded call.
verify(audioClientControllerMock.stopCallCount)
verify(videoClientMock.setSendingCalls)

// Predicate matching, zero calls, or multiple calls.
verify(videoClientMock.sendDataMessageCalls) {
    $0.topic == topic && $0.lifetimeMs == 0
}
verify(videoClientMock.setSendingCalls, never())
verify(audioClientControllerMock.startCalls, times(2)) { $0.audioMode == .mono48K }

// Equality and reference identity.
verifyEqual(videoClientMock.setSendingCalls, to: true)
verifyIdentical(audioSessionMock.setPreferredInputCalls, to: port)

// Inspect the single matched call without filtering and counting again.
let event = verify(eventAnalyticsControllerMock.publishEventCalls) {
    $0.name == .audioInputFailed
}
XCTAssertEqual(event?.attributes?[EventAttributeName.audioInputError] as? MediaError, expectedError)
```

Avoid reintroducing equivalent boilerplate:

```swift
// Do not use when a verification helper expresses the same expectation.
XCTAssertEqual(calls.filter { $0.topic == topic }.count, 1)
```

## Validation

Run the affected test class first, then run the complete suite before submitting broad test refactors:

```bash
cd AmazonChimeSDK
xcodebuild test \
  -project AmazonChimeSDK.xcodeproj \
  -scheme AmazonChimeSDKTests \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -skip-testing:'AmazonChimeSDKTests/SchedulerTests' \
  -quiet
```
