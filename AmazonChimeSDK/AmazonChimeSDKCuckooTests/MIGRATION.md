# Mockingbird → Cuckoo Test Migration

This folder contains the `AmazonChimeSDKTests` unit test suite migrated from
[Mockingbird](https://github.com/typealiased/mockingbird) to
[Cuckoo](https://github.com/Brightify/Cuckoo).

Status: **complete and verified** — `Executed 566 tests, with 0 failures`
on Xcode 26.6 / Swift 6.3 / macOS 26 (2026-07-22), with no per-machine setup
beyond opening the project. The Mockingbird suite *can* still be built and run
on the same toolchain, but only through a stack of unsupported workarounds that
every machine has to reproduce — see
[Building the Mockingbird suite on current Xcode](#building-the-mockingbird-suite-on-current-xcode).

## Why we migrated

- **Mockingbird is dead upstream.** Last release is 0.20.0 (Jan 2022) — the
  exact version pinned by the dev-env setup doc. The repo moved from
  `birdrides` to `typealiased/mockingbird` and has been dormant for years.
  It predates Swift 5.9+, and neither its generator nor the tests it produces
  work against current Xcode without local patching.
- **No living fork.** `fabianmuecke/mockingbird` has no binary releases, and
  none of the ~90 forks are actively maintained.
- **Keeping it working is a per-machine chore.** Xcode versions old enough to
  work with Mockingbird 0.20 out of the box do not run on current macOS, so
  every new laptop / new hire has to rebuild the workaround stack described
  below (a hand-built sourcekitd shim, an out-of-band generator binary, and
  source patches). None of it is committed or reproducible from a clean
  checkout today.

## Alternatives considered

| Framework | Status | Production code impact | Notes |
|---|---|---|---|
| **Cuckoo** (chosen) | Maintained (2.3.0, June 2026) | **None** — generator reads source files, tests-only change | Closest API shape to Mockingbird; most mechanical migration |
| Mockolo (Uber) | Maintained | `/// @mockable` comment annotations on prod source | Mocks are plain classes; tests need deeper rewrites |
| Mockable | Maintained, macro-based | `@Mockable` macro + `import Mockable` on ~47 shipping protocols | No external CLI to rot, but adds a third-party dependency surface to the public source of an OSS SDK |

## Building the Mockingbird suite on current Xcode

The old suite is not permanently broken — it was made to build and pass on
Xcode 26.6 / Swift 6.3 during this work. This section records what that took,
because the cost of reproducing it is the argument for migrating, and because
`AmazonChimeSDKTests/` stays in the project for now.

Three things are required. None survive a fresh clone.

**1. Provision the generator out of band.** The SPM reference
(`birdrides/mockingbird`, up-to-next-minor from 0.20.0) supplies only the
*runtime*; the `mockingbird` CLI that the `Generate Mockingbird Mocks` build
phase invokes is a separate install. `mockingbird`, `mockingbird-bin`,
`MockingbirdMocks/`, `MockingbirdSupport/`, and `AmazonChimeSDKDemo/Mockingbird.pkg`
are all untracked/ignored — they exist only on a machine that has run the
install, and the generated mocks are not committed.

**2. Shim sourcekitd for Apple Silicon.** Mockingbird 0.20.0 ships x86_64-only
and `dlopen`s sourcekitd, but Xcode 26's sourcekitd is arm64-only, so the
`dlopen` hits `SIGILL`; its XPC service is also unusable from a translated
(Rosetta) client, which reports `Service is invalid`. The workaround in this
clone is a `mockingbird` shell wrapper that runs the real binary with
`XCODE_DEFAULT_TOOLCHAIN_OVERRIDE` pointed at `Libraries/sk-shim`, whose
`sourcekitd.framework/Versions/A/sourcekitd` symlinks to the universal
in-process `sourcekitdInProc` from Command Line Tools. A universal
`Libraries/lib_InternalSwiftSyntaxParser.dylib` is staged alongside it.

**3. Patch two test files for Swift 6.3.** On branch
`fix/xcode-26-swift-63-test-compile` (commit `2abbbaa`, type information only —
no assertion or behavior changes):

- `DefaultDeviceControllerTests`: `AudioSession.setPreferredInput` is `throws`,
  so Mockingbird generates a throwing mockable and `verify()` is `rethrows`.
  Swift 6.3 requires `try` at the call site and `throws` on the test method.
- `DefaultAudioClientControllerTests`: both `given(audioClientMock.startSession(…))`
  stubs fail with *"the compiler is unable to type-check this expression in
  reasonable time"*. `startSession` has two 15-parameter overloads (the
  implementation taking `String!`, the mockable taking `@autoclosure () -> String`)
  and `any()` is itself overloaded, so 15 unconstrained matchers give the
  constraint solver a large search space. Passing each matcher an explicit type
  removes the inference. Raising `-solver-expression-time-threshold` does not
  help — the cost is overload resolution, not per-expression time.

Also required for the lint gate to run at all on arm64: the SwiftLint build
phase `PATH` fix described under
[Related changes outside this folder](#related-changes-outside-this-folder).

## How to run the tests

**Xcode:** open `AmazonChimeSDK.xcodeproj`, select the shared
**AmazonChimeSDKCuckooTests** scheme and a simulator, `Cmd+U`.

**Terminal:**

```bash
cd AmazonChimeSDK
xcodebuild test \
  -project AmazonChimeSDK.xcodeproj \
  -scheme AmazonChimeSDKCuckooTests \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -skip-testing:"AmazonChimeSDKCuckooTests/SchedulerTests"
```

`SchedulerTests` is timing-sensitive and skipped to match upstream CI
(`codecov.yml` does the same). Expected: 566 tests, 0 failures, ~2.5 min.

## Layout

```
AmazonChimeSDK/
├── Cuckoo/
│   └── cuckoonator                  # Cuckoo generator binary (2.3.0), universal macOS
├── Cuckoofile.toml                  # Generation config (module, imports, 46 source files)
└── AmazonChimeSDKCuckooTests/
    ├── Generated/
    │   └── GeneratedMocks.swift     # All 49 mocks + companion Stub classes — generated, do not hand-edit
    ├── common/
    │   └── CommonTestCase.swift     # Shared test base (see “Conversion conventions”)
    ├── mocks/
    │   ├── VideoClientMock.swift    # Hand-written subclass for binary-framework VideoClient
    │   └── StaticConformanceShims.swift  # static protocol members Cuckoo can’t generate
    └── ... (converted *Tests.swift files, mirroring AmazonChimeSDKTests structure)
```

### The Xcode target

`AmazonChimeSDKCuckooTests` is a unit-test target in `AmazonChimeSDK.xcodeproj`:

- **Sources:** everything in this folder **plus** the ~67 test files from
  `AmazonChimeSDKTests/` that never used Mockingbird, added **by reference**
  (single source of truth, no copies). Two Mockingbird-free-looking files
  that used `mock()` without an import (`SQLiteClientTests`,
  `SQLiteClientFileTests`) were converted and live here instead.
- **Dependencies:** the `AmazonChimeSDK` framework target, the Media/ML
  binary frameworks (same refs as the old target), and the **Cuckoo runtime**
  via SPM (`https://github.com/Brightify/Cuckoo`, up-to-next-major from 2.3.0).
- **Resources:** the four bundle files `BackgroundFilterTests` needs (test
  images + `selfie_segmentation_landscape.tflite`), same refs as the old target.
- **Deployment target: iOS 13.0** (the framework itself stays 12.0) —
  the Cuckoo runtime requires iOS 13+. Test-target-only change.
- A shared `AmazonChimeSDKCuckooTests` scheme exists so `xcodebuild` and CI
  can run it directly.

The original Mockingbird suite stays in place at `AmazonChimeSDKTests/` until
this migration is reviewed (apart from the shared SwiftLint `as!` → `as?` fixes
noted below); deleting it is a follow-up. To build and run it on current Xcode,
see [Building the Mockingbird suite on current Xcode](#building-the-mockingbird-suite-on-current-xcode).

## Regenerating mocks

From `AmazonChimeSDK/`:

```bash
./Cuckoo/cuckoonator --configuration "$(pwd)/Cuckoofile.toml"
```

`Cuckoofile.toml` lists every SDK source file defining a mocked
protocol/class. Two gotchas learned the hard way:

- **Include parent protocols.** If protocol `B: A` is mocked, the file
  defining `A` must also be listed or `MockB` is generated without `A`'s
  requirements and fails to compile (bit us with `VideoTileControllerFacade`
  and `VideoCaptureSource`).
- **`static` protocol members are not generated.** Add a manual conformance
  in `mocks/StaticConformanceShims.swift` (e.g.
  `VideoClientProtocol.globalInitialize()`).

`GeneratedMocks.swift` is committed generated output — never hand-edit it.

## Conversion conventions

| Mockingbird | Cuckoo |
|---|---|
| `mock(EventDao.self)` | `MockEventDao().withEnabledDefaultImplementation(EventDaoStub())` |
| `mock(X.self).initialize(args)` (data-holder class) | real `X(args)` instance (see below) |
| `given(mock.f(x: any())).willReturn(v)` | `stub(mock) { when($0.f(x: any())).thenReturn(v) }` |
| `given(mock.f()).willReturn()` (void) | `stub(mock) { when($0.f()).thenDoNothing() }` |
| `given(mock.f()).will { … }` / `~> { … }` | `when($0.f()).then { … }` |
| `given(mock.getProp())` (property getter) | `when($0.prop.get)` — stub side |
| `verify(mock.getProp()).wasCalled()` | `verify(mock).prop.get()` — verify side `get` is a **function** |
| `verify(mock.f()).wasCalled(n)` | `verify(mock, times(n)).f()` |
| `verify(mock.f()).wasNeverCalled()` | `verify(mock, never()).f()` |
| `any()` | `any()` (same name, Cuckoo's matcher) |
| `any(where: { … })` | `ParameterMatcher { … }` |
| `eventually { … }` | `XCTestExpectation` + `asyncAfter` (29 sites in the observer test alone) |
| `ArgumentCaptor` `captor.any()` / `.value` | `captor.capture()` / `.value` |
| `ValueProvider` | explicit property-getter stubs |

### Semantics: strict vs lenient mocks

Mockingbird mocks silently no-op unstubbed calls. **Cuckoo protocol mocks
fail the test on any unstubbed call** ("No stub for method"). To preserve
the original tests' semantics, every protocol mock is created with
`.withEnabledDefaultImplementation(<Protocol>Stub())`, which no-ops
unstubbed members. Explicit `stub { }` setups and all `verify` assertions
behave exactly as before. If you *want* strictness for a new test, omit the
default implementation.

### Matcher positions need `Matchable` types

Bare non-primitive literals in `stub`/`verify` argument positions don't
compile — wrap them:

- enum cases: `equal(to: EventName.meetingEnded)` (fully qualified — bare
  `.meetingEnded` can't infer its base in a generic matcher position)
- object instances (mocks, configs): `equal(to: instance)` (identity for
  `AnyObject`)
- `[AnyHashable: Any]` (not `Equatable`):
  `equal(to: [:], equalWhen: { NSDictionary(dictionary: $0).isEqual(to: $1) })`
- "dict containing key" (Mockingbird `[key: any()]`):
  `ParameterMatcher { $0[key] != nil }`
- ObjC-bridged integer params: qualify the width (`Int32(0)`, `UInt32(300)`) —
  bare literals infer `Int` and fail.

`String`/`Bool`/`Int` literals stay bare.

### Data-holder classes use real instances

Mockingbird wrapped config objects (`MeetingSessionConfiguration`,
`Meeting`, `Attendee`, `MediaPlacement`, …) in class mocks initialized with
real values. No test ever stubs or verifies them, so the Cuckoo suite uses
**real instances** (see `common/CommonTestCase.swift`). `MockVideoClient`
cannot be generated at all (ObjC class from the binary
`AmazonChimeSDKMedia` framework) — `mocks/VideoClientMock.swift` is a
hand-written subclass; tests only pass it around, so it has no overrides.

See `ingestion/DefaultEventBufferTests.swift` for the reference conversion.

## Related changes outside this folder

- **SwiftLint clean-up** (36 pre-existing error-level violations under
  SwiftLint 0.65, which is stricter than what the repo was written against):
  - test asserts: `as!` → `as?` (a failed cast now fails the test instead of
    crashing it) — fixed in both the original and converted copies
  - production: 2 over-long lines wrapped
    (`AudioVideoConfiguration.swift`, `MeetingSessionStatusCode.swift`);
    2 giant-switch mappers got `// swiftlint:disable:next
    cyclomatic_complexity` (`EventName.swift`, `Converters.swift`)
  - length rules on big test files: targeted `// swiftlint:disable` comments
  - `.swiftlint.yml`: `AmazonChimeSDKCuckooTests/Generated` excluded
    (mirrors the existing `MockingbirdMocks` exclusion)
- **SwiftLint build phase fixed for Apple Silicon**: the run-script phase
  now prepends `/opt/homebrew/bin` to `PATH` (SwiftLint's documented
  snippet). Without it, Xcode UI builds never found `swiftlint` on
  arm64 Macs and the lint gate silently never ran.
- **Dead file removed from consideration**:
  `AmazonChimeSDKTests/ingestion/DefaultAppStateMonitorNetworkTests.swift`
  is committed to git but was never a member of the old test target and
  subclasses `NWPath` (a struct) — it has never compiled anywhere. Not
  carried over. Two orphans with no project file reference
  (`TranscriptEntityTests`, `TranscriptLanguageWithScoreTests`,
  `NetworkConnectionTypeTests`) are likewise not in either target.

## Follow-ups

- Delete the Mockingbird pieces: `AmazonChimeSDKTests`' 24
  Mockingbird-based files, the `Generate Mockingbird Mocks` build phase,
  the `birdrides/mockingbird` SPM reference, `MockingbirdMocks/` +
  `MockingbirdSupport/`, and the stale `AmazonChimeSDKMockableTests/` plan
  folder.
- Fix `codecov.yml`: drop the Mockingbird download/configure steps (mocks
  are committed generated output), point at the
  `AmazonChimeSDKCuckooTests` scheme, and bump the deprecated
  `actions/checkout@v2` / `upload-artifact@v3` actions.
- This clone is on `master` (v0.27.3); rebase/retarget onto `development`
  before proposing upstream.
- Decide whether to keep the vendored `Cuckoo/cuckoonator` binary in-repo
  or download it in CI (it is only needed to *regenerate* mocks, not to
  build or run tests).
