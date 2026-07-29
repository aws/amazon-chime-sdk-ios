// MARK: - Mocks generated from file: 'AmazonChimeSDK/analytics/EventAnalyticsController.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockEventAnalyticsController: EventAnalyticsController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any EventAnalyticsController
    public typealias Stubbing = __StubbingProxy_EventAnalyticsController
    public typealias Verification = __VerificationProxy_EventAnalyticsController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any EventAnalyticsController)?

    public func enableDefaultImplementation(_ stub: any EventAnalyticsController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func publishEvent(name p0: EventName) {
        return cuckoo_manager.call(
            "publishEvent(name p0: EventName)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.publishEvent(name: p0)
        )
    }

    public func publishEvent(name p0: EventName, attributes p1: [AnyHashable: Any]) {
        return cuckoo_manager.call(
            "publishEvent(name p0: EventName, attributes p1: [AnyHashable: Any])",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.publishEvent(name: p0, attributes: p1)
        )
    }

    public func publishEvent(name p0: EventName, attributes p1: [AnyHashable: Any], notifyObservers p2: Bool) {
        return cuckoo_manager.call(
            "publishEvent(name p0: EventName, attributes p1: [AnyHashable: Any], notifyObservers p2: Bool)",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.publishEvent(name: p0, attributes: p1, notifyObservers: p2)
        )
    }

    public func pushHistory(historyEventName p0: MeetingHistoryEventName) {
        return cuckoo_manager.call(
            "pushHistory(historyEventName p0: MeetingHistoryEventName)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.pushHistory(historyEventName: p0)
        )
    }

    public func addEventAnalyticsObserver(observer p0: EventAnalyticsObserver) {
        return cuckoo_manager.call(
            "addEventAnalyticsObserver(observer p0: EventAnalyticsObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addEventAnalyticsObserver(observer: p0)
        )
    }

    public func removeEventAnalyticsObserver(observer p0: EventAnalyticsObserver) {
        return cuckoo_manager.call(
            "removeEventAnalyticsObserver(observer p0: EventAnalyticsObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeEventAnalyticsObserver(observer: p0)
        )
    }

    public func getMeetingHistory() -> [MeetingHistoryEvent] {
        return cuckoo_manager.call(
            "getMeetingHistory() -> [MeetingHistoryEvent]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getMeetingHistory()
        )
    }

    public func getCommonEventAttributes() -> [AnyHashable: Any] {
        return cuckoo_manager.call(
            "getCommonEventAttributes() -> [AnyHashable: Any]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getCommonEventAttributes()
        )
    }

    public struct __StubbingProxy_EventAnalyticsController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func publishEvent<M1: Cuckoo.Matchable>(name p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(EventName)> where M1.MatchedType == EventName {
            let matchers: [Cuckoo.ParameterMatcher<(EventName)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventAnalyticsController.self,
                method: "publishEvent(name p0: EventName)",
                parameterMatchers: matchers
            ))
        }
        
        func publishEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(name p0: M1, attributes p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(EventName, [AnyHashable: Any])> where M1.MatchedType == EventName, M2.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<(EventName, [AnyHashable: Any])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventAnalyticsController.self,
                method: "publishEvent(name p0: EventName, attributes p1: [AnyHashable: Any])",
                parameterMatchers: matchers
            ))
        }
        
        func publishEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(name p0: M1, attributes p1: M2, notifyObservers p2: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(EventName, [AnyHashable: Any], Bool)> where M1.MatchedType == EventName, M2.MatchedType == [AnyHashable: Any], M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(EventName, [AnyHashable: Any], Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventAnalyticsController.self,
                method: "publishEvent(name p0: EventName, attributes p1: [AnyHashable: Any], notifyObservers p2: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func pushHistory<M1: Cuckoo.Matchable>(historyEventName p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MeetingHistoryEventName)> where M1.MatchedType == MeetingHistoryEventName {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingHistoryEventName)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventAnalyticsController.self,
                method: "pushHistory(historyEventName p0: MeetingHistoryEventName)",
                parameterMatchers: matchers
            ))
        }
        
        func addEventAnalyticsObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(EventAnalyticsObserver)> where M1.MatchedType == EventAnalyticsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(EventAnalyticsObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventAnalyticsController.self,
                method: "addEventAnalyticsObserver(observer p0: EventAnalyticsObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeEventAnalyticsObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(EventAnalyticsObserver)> where M1.MatchedType == EventAnalyticsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(EventAnalyticsObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventAnalyticsController.self,
                method: "removeEventAnalyticsObserver(observer p0: EventAnalyticsObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func getMeetingHistory() -> Cuckoo.ProtocolStubFunction<(), [MeetingHistoryEvent]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEventAnalyticsController.self,
                method: "getMeetingHistory() -> [MeetingHistoryEvent]",
                parameterMatchers: matchers
            ))
        }
        
        func getCommonEventAttributes() -> Cuckoo.ProtocolStubFunction<(), [AnyHashable: Any]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEventAnalyticsController.self,
                method: "getCommonEventAttributes() -> [AnyHashable: Any]",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_EventAnalyticsController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func publishEvent<M1: Cuckoo.Matchable>(name p0: M1) -> Cuckoo.__DoNotUse<(EventName), Void> where M1.MatchedType == EventName {
            let matchers: [Cuckoo.ParameterMatcher<(EventName)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "publishEvent(name p0: EventName)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func publishEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(name p0: M1, attributes p1: M2) -> Cuckoo.__DoNotUse<(EventName, [AnyHashable: Any]), Void> where M1.MatchedType == EventName, M2.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<(EventName, [AnyHashable: Any])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "publishEvent(name p0: EventName, attributes p1: [AnyHashable: Any])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func publishEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(name p0: M1, attributes p1: M2, notifyObservers p2: M3) -> Cuckoo.__DoNotUse<(EventName, [AnyHashable: Any], Bool), Void> where M1.MatchedType == EventName, M2.MatchedType == [AnyHashable: Any], M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(EventName, [AnyHashable: Any], Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "publishEvent(name p0: EventName, attributes p1: [AnyHashable: Any], notifyObservers p2: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func pushHistory<M1: Cuckoo.Matchable>(historyEventName p0: M1) -> Cuckoo.__DoNotUse<(MeetingHistoryEventName), Void> where M1.MatchedType == MeetingHistoryEventName {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingHistoryEventName)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "pushHistory(historyEventName p0: MeetingHistoryEventName)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addEventAnalyticsObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(EventAnalyticsObserver), Void> where M1.MatchedType == EventAnalyticsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(EventAnalyticsObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addEventAnalyticsObserver(observer p0: EventAnalyticsObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeEventAnalyticsObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(EventAnalyticsObserver), Void> where M1.MatchedType == EventAnalyticsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(EventAnalyticsObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeEventAnalyticsObserver(observer p0: EventAnalyticsObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getMeetingHistory() -> Cuckoo.__DoNotUse<(), [MeetingHistoryEvent]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getMeetingHistory() -> [MeetingHistoryEvent]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getCommonEventAttributes() -> Cuckoo.__DoNotUse<(), [AnyHashable: Any]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getCommonEventAttributes() -> [AnyHashable: Any]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class EventAnalyticsControllerStub:EventAnalyticsController, @unchecked Sendable {


    
    public func publishEvent(name p0: EventName) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func publishEvent(name p0: EventName, attributes p1: [AnyHashable: Any]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func publishEvent(name p0: EventName, attributes p1: [AnyHashable: Any], notifyObservers p2: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func pushHistory(historyEventName p0: MeetingHistoryEventName) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addEventAnalyticsObserver(observer p0: EventAnalyticsObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeEventAnalyticsObserver(observer p0: EventAnalyticsObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getMeetingHistory() -> [MeetingHistoryEvent] {
        return DefaultValueRegistry.defaultValue(for: ([MeetingHistoryEvent]).self)
    }
    
    public func getCommonEventAttributes() -> [AnyHashable: Any] {
        return DefaultValueRegistry.defaultValue(for: ([AnyHashable: Any]).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/analytics/EventAnalyticsObserver.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockEventAnalyticsObserver: EventAnalyticsObserver, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any EventAnalyticsObserver
    public typealias Stubbing = __StubbingProxy_EventAnalyticsObserver
    public typealias Verification = __VerificationProxy_EventAnalyticsObserver

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any EventAnalyticsObserver)?

    public func enableDefaultImplementation(_ stub: any EventAnalyticsObserver) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func eventDidReceive(name p0: EventName, attributes p1: [AnyHashable: Any]) {
        return cuckoo_manager.call(
            "eventDidReceive(name p0: EventName, attributes p1: [AnyHashable: Any])",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.eventDidReceive(name: p0, attributes: p1)
        )
    }

    public struct __StubbingProxy_EventAnalyticsObserver: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func eventDidReceive<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(name p0: M1, attributes p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(EventName, [AnyHashable: Any])> where M1.MatchedType == EventName, M2.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<(EventName, [AnyHashable: Any])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventAnalyticsObserver.self,
                method: "eventDidReceive(name p0: EventName, attributes p1: [AnyHashable: Any])",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_EventAnalyticsObserver: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func eventDidReceive<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(name p0: M1, attributes p1: M2) -> Cuckoo.__DoNotUse<(EventName, [AnyHashable: Any]), Void> where M1.MatchedType == EventName, M2.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<(EventName, [AnyHashable: Any])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "eventDidReceive(name p0: EventName, attributes p1: [AnyHashable: Any])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class EventAnalyticsObserverStub:EventAnalyticsObserver, @unchecked Sendable {


    
    public func eventDidReceive(name p0: EventName, attributes p1: [AnyHashable: Any]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/AudioVideoControllerFacade.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockAudioVideoControllerFacade: AudioVideoControllerFacade, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AudioVideoControllerFacade
    public typealias Stubbing = __StubbingProxy_AudioVideoControllerFacade
    public typealias Verification = __VerificationProxy_AudioVideoControllerFacade

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AudioVideoControllerFacade)?

    public func enableDefaultImplementation(_ stub: any AudioVideoControllerFacade) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var configuration: MeetingSessionConfiguration {
        get {
            return cuckoo_manager.getter(
                "configuration",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.configuration
            )
        }
    }

    public var logger: Logger {
        get {
            return cuckoo_manager.getter(
                "logger",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.logger
            )
        }
    }


    public func start(audioVideoConfiguration p0: AudioVideoConfiguration) throws {
        return try cuckoo_manager.callThrows(
            "start(audioVideoConfiguration p0: AudioVideoConfiguration) throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start(audioVideoConfiguration: p0)
        )
    }

    public func start(callKitEnabled p0: Bool) throws {
        return try cuckoo_manager.callThrows(
            "start(callKitEnabled p0: Bool) throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start(callKitEnabled: p0)
        )
    }

    public func start() throws {
        return try cuckoo_manager.callThrows(
            "start() throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start()
        )
    }

    public func stop() {
        return cuckoo_manager.call(
            "stop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stop()
        )
    }

    public func startLocalVideo() throws {
        return try cuckoo_manager.callThrows(
            "startLocalVideo() throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startLocalVideo()
        )
    }

    public func startLocalVideo(config p0: LocalVideoConfiguration) throws {
        return try cuckoo_manager.callThrows(
            "startLocalVideo(config p0: LocalVideoConfiguration) throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startLocalVideo(config: p0)
        )
    }

    public func startLocalVideo(source p0: VideoSource) {
        return cuckoo_manager.call(
            "startLocalVideo(source p0: VideoSource)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startLocalVideo(source: p0)
        )
    }

    public func startLocalVideo(source p0: VideoSource, config p1: LocalVideoConfiguration) {
        return cuckoo_manager.call(
            "startLocalVideo(source p0: VideoSource, config p1: LocalVideoConfiguration)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startLocalVideo(source: p0, config: p1)
        )
    }

    public func stopLocalVideo() {
        return cuckoo_manager.call(
            "stopLocalVideo()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopLocalVideo()
        )
    }

    public func startRemoteVideo() {
        return cuckoo_manager.call(
            "startRemoteVideo()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startRemoteVideo()
        )
    }

    public func stopRemoteVideo() {
        return cuckoo_manager.call(
            "stopRemoteVideo()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopRemoteVideo()
        )
    }

    public func addAudioVideoObserver(observer p0: AudioVideoObserver) {
        return cuckoo_manager.call(
            "addAudioVideoObserver(observer p0: AudioVideoObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addAudioVideoObserver(observer: p0)
        )
    }

    public func removeAudioVideoObserver(observer p0: AudioVideoObserver) {
        return cuckoo_manager.call(
            "removeAudioVideoObserver(observer p0: AudioVideoObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeAudioVideoObserver(observer: p0)
        )
    }

    public func addMetricsObserver(observer p0: MetricsObserver) {
        return cuckoo_manager.call(
            "addMetricsObserver(observer p0: MetricsObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addMetricsObserver(observer: p0)
        )
    }

    public func removeMetricsObserver(observer p0: MetricsObserver) {
        return cuckoo_manager.call(
            "removeMetricsObserver(observer p0: MetricsObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeMetricsObserver(observer: p0)
        )
    }

    public func updateVideoSourceSubscriptions(addedOrUpdated p0: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed p1: Array<RemoteVideoSource>) {
        return cuckoo_manager.call(
            "updateVideoSourceSubscriptions(addedOrUpdated p0: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed p1: Array<RemoteVideoSource>)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.updateVideoSourceSubscriptions(addedOrUpdated: p0, removed: p1)
        )
    }

    public func promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver) {
        return cuckoo_manager.call(
            "promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.promoteToPrimaryMeeting(credentials: p0, observer: p1)
        )
    }

    public func demoteFromPrimaryMeeting() {
        return cuckoo_manager.call(
            "demoteFromPrimaryMeeting()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.demoteFromPrimaryMeeting()
        )
    }

    public struct __StubbingProxy_AudioVideoControllerFacade: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var configuration: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAudioVideoControllerFacade,MeetingSessionConfiguration> {
            return .init(manager: cuckoo_manager, name: "configuration")
        }
        
        var logger: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAudioVideoControllerFacade,Logger> {
            return .init(manager: cuckoo_manager, name: "logger")
        }
        
        func start<M1: Cuckoo.Matchable>(audioVideoConfiguration p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(AudioVideoConfiguration),Swift.Error> where M1.MatchedType == AudioVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoConfiguration)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "start(audioVideoConfiguration p0: AudioVideoConfiguration) throws",
                parameterMatchers: matchers
            ))
        }
        
        func start<M1: Cuckoo.Matchable>(callKitEnabled p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(Bool),Swift.Error> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "start(callKitEnabled p0: Bool) throws",
                parameterMatchers: matchers
            ))
        }
        
        func start() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "start() throws",
                parameterMatchers: matchers
            ))
        }
        
        func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "stop()",
                parameterMatchers: matchers
            ))
        }
        
        func startLocalVideo() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "startLocalVideo() throws",
                parameterMatchers: matchers
            ))
        }
        
        func startLocalVideo<M1: Cuckoo.Matchable>(config p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(LocalVideoConfiguration),Swift.Error> where M1.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "startLocalVideo(config p0: LocalVideoConfiguration) throws",
                parameterMatchers: matchers
            ))
        }
        
        func startLocalVideo<M1: Cuckoo.Matchable>(source p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSource)> where M1.MatchedType == VideoSource {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "startLocalVideo(source p0: VideoSource)",
                parameterMatchers: matchers
            ))
        }
        
        func startLocalVideo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(source p0: M1, config p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSource, LocalVideoConfiguration)> where M1.MatchedType == VideoSource, M2.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource, LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "startLocalVideo(source p0: VideoSource, config p1: LocalVideoConfiguration)",
                parameterMatchers: matchers
            ))
        }
        
        func stopLocalVideo() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "stopLocalVideo()",
                parameterMatchers: matchers
            ))
        }
        
        func startRemoteVideo() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "startRemoteVideo()",
                parameterMatchers: matchers
            ))
        }
        
        func stopRemoteVideo() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "stopRemoteVideo()",
                parameterMatchers: matchers
            ))
        }
        
        func addAudioVideoObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AudioVideoObserver)> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "addAudioVideoObserver(observer p0: AudioVideoObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeAudioVideoObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AudioVideoObserver)> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "removeAudioVideoObserver(observer p0: AudioVideoObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func addMetricsObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MetricsObserver)> where M1.MatchedType == MetricsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MetricsObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "addMetricsObserver(observer p0: MetricsObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeMetricsObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MetricsObserver)> where M1.MatchedType == MetricsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MetricsObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "removeMetricsObserver(observer p0: MetricsObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func updateVideoSourceSubscriptions<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(addedOrUpdated p0: M1, removed p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, Array<RemoteVideoSource>)> where M1.MatchedType == Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, M2.MatchedType == Array<RemoteVideoSource> {
            let matchers: [Cuckoo.ParameterMatcher<(Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, Array<RemoteVideoSource>)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "updateVideoSourceSubscriptions(addedOrUpdated p0: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed p1: Array<RemoteVideoSource>)",
                parameterMatchers: matchers
            ))
        }
        
        func promoteToPrimaryMeeting<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(credentials p0: M1, observer p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver)> where M1.MatchedType == MeetingSessionCredentials, M2.MatchedType == PrimaryMeetingPromotionObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func demoteFromPrimaryMeeting() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoControllerFacade.self,
                method: "demoteFromPrimaryMeeting()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_AudioVideoControllerFacade: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var configuration: Cuckoo.VerifyReadOnlyProperty<MeetingSessionConfiguration> {
            return .init(manager: cuckoo_manager, name: "configuration", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var logger: Cuckoo.VerifyReadOnlyProperty<Logger> {
            return .init(manager: cuckoo_manager, name: "logger", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func start<M1: Cuckoo.Matchable>(audioVideoConfiguration p0: M1) -> Cuckoo.__DoNotUse<(AudioVideoConfiguration), Void> where M1.MatchedType == AudioVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoConfiguration)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "start(audioVideoConfiguration p0: AudioVideoConfiguration) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func start<M1: Cuckoo.Matchable>(callKitEnabled p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "start(callKitEnabled p0: Bool) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func start() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "start() throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startLocalVideo() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "startLocalVideo() throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startLocalVideo<M1: Cuckoo.Matchable>(config p0: M1) -> Cuckoo.__DoNotUse<(LocalVideoConfiguration), Void> where M1.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startLocalVideo(config p0: LocalVideoConfiguration) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startLocalVideo<M1: Cuckoo.Matchable>(source p0: M1) -> Cuckoo.__DoNotUse<(VideoSource), Void> where M1.MatchedType == VideoSource {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startLocalVideo(source p0: VideoSource)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startLocalVideo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(source p0: M1, config p1: M2) -> Cuckoo.__DoNotUse<(VideoSource, LocalVideoConfiguration), Void> where M1.MatchedType == VideoSource, M2.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource, LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "startLocalVideo(source p0: VideoSource, config p1: LocalVideoConfiguration)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopLocalVideo() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopLocalVideo()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startRemoteVideo() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "startRemoteVideo()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopRemoteVideo() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopRemoteVideo()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addAudioVideoObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(AudioVideoObserver), Void> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addAudioVideoObserver(observer p0: AudioVideoObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeAudioVideoObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(AudioVideoObserver), Void> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeAudioVideoObserver(observer p0: AudioVideoObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addMetricsObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(MetricsObserver), Void> where M1.MatchedType == MetricsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MetricsObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addMetricsObserver(observer p0: MetricsObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeMetricsObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(MetricsObserver), Void> where M1.MatchedType == MetricsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MetricsObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeMetricsObserver(observer p0: MetricsObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateVideoSourceSubscriptions<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(addedOrUpdated p0: M1, removed p1: M2) -> Cuckoo.__DoNotUse<(Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, Array<RemoteVideoSource>), Void> where M1.MatchedType == Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, M2.MatchedType == Array<RemoteVideoSource> {
            let matchers: [Cuckoo.ParameterMatcher<(Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, Array<RemoteVideoSource>)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "updateVideoSourceSubscriptions(addedOrUpdated p0: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed p1: Array<RemoteVideoSource>)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func promoteToPrimaryMeeting<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(credentials p0: M1, observer p1: M2) -> Cuckoo.__DoNotUse<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver), Void> where M1.MatchedType == MeetingSessionCredentials, M2.MatchedType == PrimaryMeetingPromotionObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func demoteFromPrimaryMeeting() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "demoteFromPrimaryMeeting()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class AudioVideoControllerFacadeStub:AudioVideoControllerFacade, @unchecked Sendable {
    
    public var configuration: MeetingSessionConfiguration {
        get {
            return DefaultValueRegistry.defaultValue(for: (MeetingSessionConfiguration).self)
        }
    }
    
    public var logger: Logger {
        get {
            return DefaultValueRegistry.defaultValue(for: (Logger).self)
        }
    }


    
    public func start(audioVideoConfiguration p0: AudioVideoConfiguration) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func start(callKitEnabled p0: Bool) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func start() throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startLocalVideo() throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startLocalVideo(config p0: LocalVideoConfiguration) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startLocalVideo(source p0: VideoSource) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startLocalVideo(source p0: VideoSource, config p1: LocalVideoConfiguration) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopLocalVideo() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startRemoteVideo() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopRemoteVideo() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addAudioVideoObserver(observer p0: AudioVideoObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeAudioVideoObserver(observer p0: AudioVideoObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addMetricsObserver(observer p0: MetricsObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeMetricsObserver(observer p0: MetricsObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateVideoSourceSubscriptions(addedOrUpdated p0: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed p1: Array<RemoteVideoSource>) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func demoteFromPrimaryMeeting() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/AudioVideoObserver.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockAudioVideoObserver: AudioVideoObserver, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AudioVideoObserver
    public typealias Stubbing = __StubbingProxy_AudioVideoObserver
    public typealias Verification = __VerificationProxy_AudioVideoObserver

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AudioVideoObserver)?

    public func enableDefaultImplementation(_ stub: any AudioVideoObserver) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func audioSessionDidStartConnecting(reconnecting p0: Bool) {
        return cuckoo_manager.call(
            "audioSessionDidStartConnecting(reconnecting p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.audioSessionDidStartConnecting(reconnecting: p0)
        )
    }

    public func audioSessionDidStart(reconnecting p0: Bool) {
        return cuckoo_manager.call(
            "audioSessionDidStart(reconnecting p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.audioSessionDidStart(reconnecting: p0)
        )
    }

    public func audioSessionDidDrop() {
        return cuckoo_manager.call(
            "audioSessionDidDrop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.audioSessionDidDrop()
        )
    }

    public func audioSessionDidStopWithStatus(sessionStatus p0: MeetingSessionStatus) {
        return cuckoo_manager.call(
            "audioSessionDidStopWithStatus(sessionStatus p0: MeetingSessionStatus)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.audioSessionDidStopWithStatus(sessionStatus: p0)
        )
    }

    public func audioSessionDidCancelReconnect() {
        return cuckoo_manager.call(
            "audioSessionDidCancelReconnect()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.audioSessionDidCancelReconnect()
        )
    }

    public func connectionDidRecover() {
        return cuckoo_manager.call(
            "connectionDidRecover()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.connectionDidRecover()
        )
    }

    public func connectionDidBecomePoor() {
        return cuckoo_manager.call(
            "connectionDidBecomePoor()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.connectionDidBecomePoor()
        )
    }

    public func videoSessionDidStartConnecting() {
        return cuckoo_manager.call(
            "videoSessionDidStartConnecting()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.videoSessionDidStartConnecting()
        )
    }

    public func videoSessionDidStartWithStatus(sessionStatus p0: MeetingSessionStatus) {
        return cuckoo_manager.call(
            "videoSessionDidStartWithStatus(sessionStatus p0: MeetingSessionStatus)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.videoSessionDidStartWithStatus(sessionStatus: p0)
        )
    }

    public func videoSessionDidStopWithStatus(sessionStatus p0: MeetingSessionStatus) {
        return cuckoo_manager.call(
            "videoSessionDidStopWithStatus(sessionStatus p0: MeetingSessionStatus)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.videoSessionDidStopWithStatus(sessionStatus: p0)
        )
    }

    public func remoteVideoSourcesDidBecomeAvailable(sources p0: [RemoteVideoSource]) {
        return cuckoo_manager.call(
            "remoteVideoSourcesDidBecomeAvailable(sources p0: [RemoteVideoSource])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.remoteVideoSourcesDidBecomeAvailable(sources: p0)
        )
    }

    public func remoteVideoSourcesDidBecomeUnavailable(sources p0: [RemoteVideoSource]) {
        return cuckoo_manager.call(
            "remoteVideoSourcesDidBecomeUnavailable(sources p0: [RemoteVideoSource])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.remoteVideoSourcesDidBecomeUnavailable(sources: p0)
        )
    }

    public func cameraSendAvailabilityDidChange(available p0: Bool) {
        return cuckoo_manager.call(
            "cameraSendAvailabilityDidChange(available p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.cameraSendAvailabilityDidChange(available: p0)
        )
    }

    public struct __StubbingProxy_AudioVideoObserver: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func audioSessionDidStartConnecting<M1: Cuckoo.Matchable>(reconnecting p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "audioSessionDidStartConnecting(reconnecting p0: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func audioSessionDidStart<M1: Cuckoo.Matchable>(reconnecting p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "audioSessionDidStart(reconnecting p0: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func audioSessionDidDrop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "audioSessionDidDrop()",
                parameterMatchers: matchers
            ))
        }
        
        func audioSessionDidStopWithStatus<M1: Cuckoo.Matchable>(sessionStatus p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MeetingSessionStatus)> where M1.MatchedType == MeetingSessionStatus {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionStatus)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "audioSessionDidStopWithStatus(sessionStatus p0: MeetingSessionStatus)",
                parameterMatchers: matchers
            ))
        }
        
        func audioSessionDidCancelReconnect() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "audioSessionDidCancelReconnect()",
                parameterMatchers: matchers
            ))
        }
        
        func connectionDidRecover() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "connectionDidRecover()",
                parameterMatchers: matchers
            ))
        }
        
        func connectionDidBecomePoor() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "connectionDidBecomePoor()",
                parameterMatchers: matchers
            ))
        }
        
        func videoSessionDidStartConnecting() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "videoSessionDidStartConnecting()",
                parameterMatchers: matchers
            ))
        }
        
        func videoSessionDidStartWithStatus<M1: Cuckoo.Matchable>(sessionStatus p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MeetingSessionStatus)> where M1.MatchedType == MeetingSessionStatus {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionStatus)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "videoSessionDidStartWithStatus(sessionStatus p0: MeetingSessionStatus)",
                parameterMatchers: matchers
            ))
        }
        
        func videoSessionDidStopWithStatus<M1: Cuckoo.Matchable>(sessionStatus p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MeetingSessionStatus)> where M1.MatchedType == MeetingSessionStatus {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionStatus)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "videoSessionDidStopWithStatus(sessionStatus p0: MeetingSessionStatus)",
                parameterMatchers: matchers
            ))
        }
        
        func remoteVideoSourcesDidBecomeAvailable<M1: Cuckoo.Matchable>(sources p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([RemoteVideoSource])> where M1.MatchedType == [RemoteVideoSource] {
            let matchers: [Cuckoo.ParameterMatcher<([RemoteVideoSource])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "remoteVideoSourcesDidBecomeAvailable(sources p0: [RemoteVideoSource])",
                parameterMatchers: matchers
            ))
        }
        
        func remoteVideoSourcesDidBecomeUnavailable<M1: Cuckoo.Matchable>(sources p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([RemoteVideoSource])> where M1.MatchedType == [RemoteVideoSource] {
            let matchers: [Cuckoo.ParameterMatcher<([RemoteVideoSource])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "remoteVideoSourcesDidBecomeUnavailable(sources p0: [RemoteVideoSource])",
                parameterMatchers: matchers
            ))
        }
        
        func cameraSendAvailabilityDidChange<M1: Cuckoo.Matchable>(available p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioVideoObserver.self,
                method: "cameraSendAvailabilityDidChange(available p0: Bool)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_AudioVideoObserver: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func audioSessionDidStartConnecting<M1: Cuckoo.Matchable>(reconnecting p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "audioSessionDidStartConnecting(reconnecting p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func audioSessionDidStart<M1: Cuckoo.Matchable>(reconnecting p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "audioSessionDidStart(reconnecting p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func audioSessionDidDrop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "audioSessionDidDrop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func audioSessionDidStopWithStatus<M1: Cuckoo.Matchable>(sessionStatus p0: M1) -> Cuckoo.__DoNotUse<(MeetingSessionStatus), Void> where M1.MatchedType == MeetingSessionStatus {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionStatus)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "audioSessionDidStopWithStatus(sessionStatus p0: MeetingSessionStatus)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func audioSessionDidCancelReconnect() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "audioSessionDidCancelReconnect()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func connectionDidRecover() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "connectionDidRecover()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func connectionDidBecomePoor() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "connectionDidBecomePoor()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func videoSessionDidStartConnecting() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "videoSessionDidStartConnecting()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func videoSessionDidStartWithStatus<M1: Cuckoo.Matchable>(sessionStatus p0: M1) -> Cuckoo.__DoNotUse<(MeetingSessionStatus), Void> where M1.MatchedType == MeetingSessionStatus {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionStatus)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "videoSessionDidStartWithStatus(sessionStatus p0: MeetingSessionStatus)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func videoSessionDidStopWithStatus<M1: Cuckoo.Matchable>(sessionStatus p0: M1) -> Cuckoo.__DoNotUse<(MeetingSessionStatus), Void> where M1.MatchedType == MeetingSessionStatus {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionStatus)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "videoSessionDidStopWithStatus(sessionStatus p0: MeetingSessionStatus)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func remoteVideoSourcesDidBecomeAvailable<M1: Cuckoo.Matchable>(sources p0: M1) -> Cuckoo.__DoNotUse<([RemoteVideoSource]), Void> where M1.MatchedType == [RemoteVideoSource] {
            let matchers: [Cuckoo.ParameterMatcher<([RemoteVideoSource])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "remoteVideoSourcesDidBecomeAvailable(sources p0: [RemoteVideoSource])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func remoteVideoSourcesDidBecomeUnavailable<M1: Cuckoo.Matchable>(sources p0: M1) -> Cuckoo.__DoNotUse<([RemoteVideoSource]), Void> where M1.MatchedType == [RemoteVideoSource] {
            let matchers: [Cuckoo.ParameterMatcher<([RemoteVideoSource])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "remoteVideoSourcesDidBecomeUnavailable(sources p0: [RemoteVideoSource])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func cameraSendAvailabilityDidChange<M1: Cuckoo.Matchable>(available p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "cameraSendAvailabilityDidChange(available p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class AudioVideoObserverStub:AudioVideoObserver, @unchecked Sendable {


    
    public func audioSessionDidStartConnecting(reconnecting p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func audioSessionDidStart(reconnecting p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func audioSessionDidDrop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func audioSessionDidStopWithStatus(sessionStatus p0: MeetingSessionStatus) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func audioSessionDidCancelReconnect() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func connectionDidRecover() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func connectionDidBecomePoor() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func videoSessionDidStartConnecting() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func videoSessionDidStartWithStatus(sessionStatus p0: MeetingSessionStatus) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func videoSessionDidStopWithStatus(sessionStatus p0: MeetingSessionStatus) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func remoteVideoSourcesDidBecomeAvailable(sources p0: [RemoteVideoSource]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func remoteVideoSourcesDidBecomeUnavailable(sources p0: [RemoteVideoSource]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func cameraSendAvailabilityDidChange(available p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/audio/activespeakerdetector/ActiveSpeakerDetectorFacade.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockActiveSpeakerDetectorFacade: ActiveSpeakerDetectorFacade, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ActiveSpeakerDetectorFacade
    public typealias Stubbing = __StubbingProxy_ActiveSpeakerDetectorFacade
    public typealias Verification = __VerificationProxy_ActiveSpeakerDetectorFacade

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ActiveSpeakerDetectorFacade)?

    public func enableDefaultImplementation(_ stub: any ActiveSpeakerDetectorFacade) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func addActiveSpeakerObserver(policy p0: ActiveSpeakerPolicy, observer p1: ActiveSpeakerObserver) {
        return cuckoo_manager.call(
            "addActiveSpeakerObserver(policy p0: ActiveSpeakerPolicy, observer p1: ActiveSpeakerObserver)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addActiveSpeakerObserver(policy: p0, observer: p1)
        )
    }

    public func removeActiveSpeakerObserver(observer p0: ActiveSpeakerObserver) {
        return cuckoo_manager.call(
            "removeActiveSpeakerObserver(observer p0: ActiveSpeakerObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeActiveSpeakerObserver(observer: p0)
        )
    }

    public func hasBandwidthPriorityCallback(hasBandwidthPriority p0: Bool) {
        return cuckoo_manager.call(
            "hasBandwidthPriorityCallback(hasBandwidthPriority p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.hasBandwidthPriorityCallback(hasBandwidthPriority: p0)
        )
    }

    public struct __StubbingProxy_ActiveSpeakerDetectorFacade: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func addActiveSpeakerObserver<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(policy p0: M1, observer p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(ActiveSpeakerPolicy, ActiveSpeakerObserver)> where M1.MatchedType == ActiveSpeakerPolicy, M2.MatchedType == ActiveSpeakerObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ActiveSpeakerPolicy, ActiveSpeakerObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockActiveSpeakerDetectorFacade.self,
                method: "addActiveSpeakerObserver(policy p0: ActiveSpeakerPolicy, observer p1: ActiveSpeakerObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeActiveSpeakerObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(ActiveSpeakerObserver)> where M1.MatchedType == ActiveSpeakerObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ActiveSpeakerObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockActiveSpeakerDetectorFacade.self,
                method: "removeActiveSpeakerObserver(observer p0: ActiveSpeakerObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func hasBandwidthPriorityCallback<M1: Cuckoo.Matchable>(hasBandwidthPriority p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockActiveSpeakerDetectorFacade.self,
                method: "hasBandwidthPriorityCallback(hasBandwidthPriority p0: Bool)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_ActiveSpeakerDetectorFacade: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func addActiveSpeakerObserver<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(policy p0: M1, observer p1: M2) -> Cuckoo.__DoNotUse<(ActiveSpeakerPolicy, ActiveSpeakerObserver), Void> where M1.MatchedType == ActiveSpeakerPolicy, M2.MatchedType == ActiveSpeakerObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ActiveSpeakerPolicy, ActiveSpeakerObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "addActiveSpeakerObserver(policy p0: ActiveSpeakerPolicy, observer p1: ActiveSpeakerObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeActiveSpeakerObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(ActiveSpeakerObserver), Void> where M1.MatchedType == ActiveSpeakerObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ActiveSpeakerObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeActiveSpeakerObserver(observer p0: ActiveSpeakerObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func hasBandwidthPriorityCallback<M1: Cuckoo.Matchable>(hasBandwidthPriority p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "hasBandwidthPriorityCallback(hasBandwidthPriority p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class ActiveSpeakerDetectorFacadeStub:ActiveSpeakerDetectorFacade, @unchecked Sendable {


    
    public func addActiveSpeakerObserver(policy p0: ActiveSpeakerPolicy, observer p1: ActiveSpeakerObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeActiveSpeakerObserver(observer p0: ActiveSpeakerObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func hasBandwidthPriorityCallback(hasBandwidthPriority p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/audio/scheduler/Scheduler.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockScheduler: Scheduler, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any Scheduler
    public typealias Stubbing = __StubbingProxy_Scheduler
    public typealias Verification = __VerificationProxy_Scheduler

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any Scheduler)?

    public func enableDefaultImplementation(_ stub: any Scheduler) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func start() {
        return cuckoo_manager.call(
            "start()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start()
        )
    }

    public func stop() {
        return cuckoo_manager.call(
            "stop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stop()
        )
    }

    public struct __StubbingProxy_Scheduler: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func start() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockScheduler.self,
                method: "start()",
                parameterMatchers: matchers
            ))
        }
        
        func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockScheduler.self,
                method: "stop()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_Scheduler: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func start() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "start()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class SchedulerStub:Scheduler, @unchecked Sendable {


    
    public func start() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/contentshare/ContentShareController.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockContentShareController: ContentShareController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ContentShareController
    public typealias Stubbing = __StubbingProxy_ContentShareController
    public typealias Verification = __VerificationProxy_ContentShareController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ContentShareController)?

    public func enableDefaultImplementation(_ stub: any ContentShareController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func startContentShare(source p0: ContentShareSource) {
        return cuckoo_manager.call(
            "startContentShare(source p0: ContentShareSource)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startContentShare(source: p0)
        )
    }

    public func startContentShare(source p0: ContentShareSource, config p1: LocalVideoConfiguration) {
        return cuckoo_manager.call(
            "startContentShare(source p0: ContentShareSource, config p1: LocalVideoConfiguration)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startContentShare(source: p0, config: p1)
        )
    }

    public func stopContentShare() {
        return cuckoo_manager.call(
            "stopContentShare()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopContentShare()
        )
    }

    public func addContentShareObserver(observer p0: ContentShareObserver) {
        return cuckoo_manager.call(
            "addContentShareObserver(observer p0: ContentShareObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addContentShareObserver(observer: p0)
        )
    }

    public func removeContentShareObserver(observer p0: ContentShareObserver) {
        return cuckoo_manager.call(
            "removeContentShareObserver(observer p0: ContentShareObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeContentShareObserver(observer: p0)
        )
    }

    public struct __StubbingProxy_ContentShareController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func startContentShare<M1: Cuckoo.Matchable>(source p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(ContentShareSource)> where M1.MatchedType == ContentShareSource {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareSource)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareController.self,
                method: "startContentShare(source p0: ContentShareSource)",
                parameterMatchers: matchers
            ))
        }
        
        func startContentShare<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(source p0: M1, config p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(ContentShareSource, LocalVideoConfiguration)> where M1.MatchedType == ContentShareSource, M2.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareSource, LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareController.self,
                method: "startContentShare(source p0: ContentShareSource, config p1: LocalVideoConfiguration)",
                parameterMatchers: matchers
            ))
        }
        
        func stopContentShare() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareController.self,
                method: "stopContentShare()",
                parameterMatchers: matchers
            ))
        }
        
        func addContentShareObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(ContentShareObserver)> where M1.MatchedType == ContentShareObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareController.self,
                method: "addContentShareObserver(observer p0: ContentShareObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeContentShareObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(ContentShareObserver)> where M1.MatchedType == ContentShareObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareController.self,
                method: "removeContentShareObserver(observer p0: ContentShareObserver)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_ContentShareController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func startContentShare<M1: Cuckoo.Matchable>(source p0: M1) -> Cuckoo.__DoNotUse<(ContentShareSource), Void> where M1.MatchedType == ContentShareSource {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareSource)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startContentShare(source p0: ContentShareSource)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startContentShare<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(source p0: M1, config p1: M2) -> Cuckoo.__DoNotUse<(ContentShareSource, LocalVideoConfiguration), Void> where M1.MatchedType == ContentShareSource, M2.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareSource, LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "startContentShare(source p0: ContentShareSource, config p1: LocalVideoConfiguration)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopContentShare() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopContentShare()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addContentShareObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(ContentShareObserver), Void> where M1.MatchedType == ContentShareObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addContentShareObserver(observer p0: ContentShareObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeContentShareObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(ContentShareObserver), Void> where M1.MatchedType == ContentShareObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeContentShareObserver(observer p0: ContentShareObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class ContentShareControllerStub:ContentShareController, @unchecked Sendable {


    
    public func startContentShare(source p0: ContentShareSource) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startContentShare(source p0: ContentShareSource, config p1: LocalVideoConfiguration) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopContentShare() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addContentShareObserver(observer p0: ContentShareObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeContentShareObserver(observer p0: ContentShareObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/contentshare/ContentShareObserver.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockContentShareObserver: ContentShareObserver, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ContentShareObserver
    public typealias Stubbing = __StubbingProxy_ContentShareObserver
    public typealias Verification = __VerificationProxy_ContentShareObserver

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ContentShareObserver)?

    public func enableDefaultImplementation(_ stub: any ContentShareObserver) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func contentShareDidStart() {
        return cuckoo_manager.call(
            "contentShareDidStart()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.contentShareDidStart()
        )
    }

    public func contentShareDidStop(status p0: ContentShareStatus) {
        return cuckoo_manager.call(
            "contentShareDidStop(status p0: ContentShareStatus)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.contentShareDidStop(status: p0)
        )
    }

    public struct __StubbingProxy_ContentShareObserver: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func contentShareDidStart() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareObserver.self,
                method: "contentShareDidStart()",
                parameterMatchers: matchers
            ))
        }
        
        func contentShareDidStop<M1: Cuckoo.Matchable>(status p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(ContentShareStatus)> where M1.MatchedType == ContentShareStatus {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareStatus)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareObserver.self,
                method: "contentShareDidStop(status p0: ContentShareStatus)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_ContentShareObserver: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func contentShareDidStart() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "contentShareDidStart()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func contentShareDidStop<M1: Cuckoo.Matchable>(status p0: M1) -> Cuckoo.__DoNotUse<(ContentShareStatus), Void> where M1.MatchedType == ContentShareStatus {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareStatus)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "contentShareDidStop(status p0: ContentShareStatus)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class ContentShareObserverStub:ContentShareObserver, @unchecked Sendable {


    
    public func contentShareDidStart() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func contentShareDidStop(status p0: ContentShareStatus) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/metric/MetricsObserver.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockMetricsObserver: MetricsObserver, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any MetricsObserver
    public typealias Stubbing = __StubbingProxy_MetricsObserver
    public typealias Verification = __VerificationProxy_MetricsObserver

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any MetricsObserver)?

    public func enableDefaultImplementation(_ stub: any MetricsObserver) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func metricsDidReceive(metrics p0: [AnyHashable: Any]) {
        return cuckoo_manager.call(
            "metricsDidReceive(metrics p0: [AnyHashable: Any])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.metricsDidReceive(metrics: p0)
        )
    }

    public struct __StubbingProxy_MetricsObserver: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func metricsDidReceive<M1: Cuckoo.Matchable>(metrics p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([AnyHashable: Any])> where M1.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<([AnyHashable: Any])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockMetricsObserver.self,
                method: "metricsDidReceive(metrics p0: [AnyHashable: Any])",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_MetricsObserver: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func metricsDidReceive<M1: Cuckoo.Matchable>(metrics p0: M1) -> Cuckoo.__DoNotUse<([AnyHashable: Any]), Void> where M1.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<([AnyHashable: Any])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "metricsDidReceive(metrics p0: [AnyHashable: Any])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class MetricsObserverStub:MetricsObserver, @unchecked Sendable {


    
    public func metricsDidReceive(metrics p0: [AnyHashable: Any]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/video/VideoRenderView.swift'

import Cuckoo
import Foundation
import VideoToolbox
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockVideoRenderView: VideoRenderView, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any VideoRenderView
    public typealias Stubbing = __StubbingProxy_VideoRenderView
    public typealias Verification = __VerificationProxy_VideoRenderView

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any VideoRenderView)?

    public func enableDefaultImplementation(_ stub: any VideoRenderView) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func onVideoFrameReceived(frame p0: VideoFrame) {
        return cuckoo_manager.call(
            "onVideoFrameReceived(frame p0: VideoFrame)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.onVideoFrameReceived(frame: p0)
        )
    }

    public struct __StubbingProxy_VideoRenderView: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func onVideoFrameReceived<M1: Cuckoo.Matchable>(frame p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoFrame)> where M1.MatchedType == VideoFrame {
            let matchers: [Cuckoo.ParameterMatcher<(VideoFrame)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoRenderView.self,
                method: "onVideoFrameReceived(frame p0: VideoFrame)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_VideoRenderView: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func onVideoFrameReceived<M1: Cuckoo.Matchable>(frame p0: M1) -> Cuckoo.__DoNotUse<(VideoFrame), Void> where M1.MatchedType == VideoFrame {
            let matchers: [Cuckoo.ParameterMatcher<(VideoFrame)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "onVideoFrameReceived(frame p0: VideoFrame)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class VideoRenderViewStub:VideoRenderView, @unchecked Sendable {


    
    public func onVideoFrameReceived(frame p0: VideoFrame) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/video/VideoSink.swift'

import Cuckoo
import CoreMedia
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockVideoSink: VideoSink, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any VideoSink
    public typealias Stubbing = __StubbingProxy_VideoSink
    public typealias Verification = __VerificationProxy_VideoSink

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any VideoSink)?

    public func enableDefaultImplementation(_ stub: any VideoSink) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func onVideoFrameReceived(frame p0: VideoFrame) {
        return cuckoo_manager.call(
            "onVideoFrameReceived(frame p0: VideoFrame)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.onVideoFrameReceived(frame: p0)
        )
    }

    public struct __StubbingProxy_VideoSink: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func onVideoFrameReceived<M1: Cuckoo.Matchable>(frame p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoFrame)> where M1.MatchedType == VideoFrame {
            let matchers: [Cuckoo.ParameterMatcher<(VideoFrame)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoSink.self,
                method: "onVideoFrameReceived(frame p0: VideoFrame)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_VideoSink: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func onVideoFrameReceived<M1: Cuckoo.Matchable>(frame p0: M1) -> Cuckoo.__DoNotUse<(VideoFrame), Void> where M1.MatchedType == VideoFrame {
            let matchers: [Cuckoo.ParameterMatcher<(VideoFrame)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "onVideoFrameReceived(frame p0: VideoFrame)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class VideoSinkStub:VideoSink, @unchecked Sendable {


    
    public func onVideoFrameReceived(frame p0: VideoFrame) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/video/VideoSource.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockVideoSource: VideoSource, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any VideoSource
    public typealias Stubbing = __StubbingProxy_VideoSource
    public typealias Verification = __VerificationProxy_VideoSource

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any VideoSource)?

    public func enableDefaultImplementation(_ stub: any VideoSource) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var videoContentHint: VideoContentHint {
        get {
            return cuckoo_manager.getter(
                "videoContentHint",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.videoContentHint
            )
        }
        set {
            cuckoo_manager.setter(
                "videoContentHint",
                value: newValue,
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.videoContentHint = newValue
            )
        }
    }


    public func addVideoSink(sink p0: VideoSink) {
        return cuckoo_manager.call(
            "addVideoSink(sink p0: VideoSink)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addVideoSink(sink: p0)
        )
    }

    public func removeVideoSink(sink p0: VideoSink) {
        return cuckoo_manager.call(
            "removeVideoSink(sink p0: VideoSink)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeVideoSink(sink: p0)
        )
    }

    public struct __StubbingProxy_VideoSource: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var videoContentHint: Cuckoo.ProtocolToBeStubbedProperty<MockVideoSource,VideoContentHint> {
            return .init(manager: cuckoo_manager, name: "videoContentHint")
        }
        
        func addVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSink)> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoSource.self,
                method: "addVideoSink(sink p0: VideoSink)",
                parameterMatchers: matchers
            ))
        }
        
        func removeVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSink)> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoSource.self,
                method: "removeVideoSink(sink p0: VideoSink)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_VideoSource: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var videoContentHint: Cuckoo.VerifyProperty<VideoContentHint> {
            return .init(manager: cuckoo_manager, name: "videoContentHint", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func addVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.__DoNotUse<(VideoSink), Void> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addVideoSink(sink p0: VideoSink)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.__DoNotUse<(VideoSink), Void> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeVideoSink(sink p0: VideoSink)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class VideoSourceStub:VideoSource, @unchecked Sendable {
    
    public var videoContentHint: VideoContentHint {
        get {
            return DefaultValueRegistry.defaultValue(for: (VideoContentHint).self)
        }
        set {}
    }


    
    public func addVideoSink(sink p0: VideoSink) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeVideoSink(sink p0: VideoSink) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/video/VideoTileController.swift'

import Cuckoo
import CoreGraphics.CGImage
import Foundation
import VideoToolbox
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockVideoTileController: VideoTileController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any VideoTileController
    public typealias Stubbing = __StubbingProxy_VideoTileController
    public typealias Verification = __VerificationProxy_VideoTileController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any VideoTileController)?

    public func enableDefaultImplementation(_ stub: any VideoTileController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func onReceiveFrame(frame p0: VideoFrame?, videoId p1: Int, attendeeId p2: String?, pauseState p3: VideoPauseState) {
        return cuckoo_manager.call(
            "onReceiveFrame(frame p0: VideoFrame?, videoId p1: Int, attendeeId p2: String?, pauseState p3: VideoPauseState)",
            parameters: (p0, p1, p2, p3),
            escapingParameters: (p0, p1, p2, p3),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.onReceiveFrame(frame: p0, videoId: p1, attendeeId: p2, pauseState: p3)
        )
    }

    public func bindVideoView(videoView p0: VideoRenderView, tileId p1: Int) {
        return cuckoo_manager.call(
            "bindVideoView(videoView p0: VideoRenderView, tileId p1: Int)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.bindVideoView(videoView: p0, tileId: p1)
        )
    }

    public func unbindVideoView(tileId p0: Int) {
        return cuckoo_manager.call(
            "unbindVideoView(tileId p0: Int)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unbindVideoView(tileId: p0)
        )
    }

    public func addVideoTileObserver(observer p0: VideoTileObserver) {
        return cuckoo_manager.call(
            "addVideoTileObserver(observer p0: VideoTileObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addVideoTileObserver(observer: p0)
        )
    }

    public func removeVideoTileObserver(observer p0: VideoTileObserver) {
        return cuckoo_manager.call(
            "removeVideoTileObserver(observer p0: VideoTileObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeVideoTileObserver(observer: p0)
        )
    }

    public func pauseRemoteVideoTile(tileId p0: Int) {
        return cuckoo_manager.call(
            "pauseRemoteVideoTile(tileId p0: Int)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.pauseRemoteVideoTile(tileId: p0)
        )
    }

    public func resumeRemoteVideoTile(tileId p0: Int) {
        return cuckoo_manager.call(
            "resumeRemoteVideoTile(tileId p0: Int)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.resumeRemoteVideoTile(tileId: p0)
        )
    }

    public struct __StubbingProxy_VideoTileController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func onReceiveFrame<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.Matchable>(frame p0: M1, videoId p1: M2, attendeeId p2: M3, pauseState p3: M4) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoFrame?, Int, String?, VideoPauseState)> where M1.OptionalMatchedType == VideoFrame, M2.MatchedType == Int, M3.OptionalMatchedType == String, M4.MatchedType == VideoPauseState {
            let matchers: [Cuckoo.ParameterMatcher<(VideoFrame?, Int, String?, VideoPauseState)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileController.self,
                method: "onReceiveFrame(frame p0: VideoFrame?, videoId p1: Int, attendeeId p2: String?, pauseState p3: VideoPauseState)",
                parameterMatchers: matchers
            ))
        }
        
        func bindVideoView<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(videoView p0: M1, tileId p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoRenderView, Int)> where M1.MatchedType == VideoRenderView, M2.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(VideoRenderView, Int)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileController.self,
                method: "bindVideoView(videoView p0: VideoRenderView, tileId p1: Int)",
                parameterMatchers: matchers
            ))
        }
        
        func unbindVideoView<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Int)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileController.self,
                method: "unbindVideoView(tileId p0: Int)",
                parameterMatchers: matchers
            ))
        }
        
        func addVideoTileObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoTileObserver)> where M1.MatchedType == VideoTileObserver {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileController.self,
                method: "addVideoTileObserver(observer p0: VideoTileObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeVideoTileObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoTileObserver)> where M1.MatchedType == VideoTileObserver {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileController.self,
                method: "removeVideoTileObserver(observer p0: VideoTileObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func pauseRemoteVideoTile<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Int)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileController.self,
                method: "pauseRemoteVideoTile(tileId p0: Int)",
                parameterMatchers: matchers
            ))
        }
        
        func resumeRemoteVideoTile<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Int)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileController.self,
                method: "resumeRemoteVideoTile(tileId p0: Int)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_VideoTileController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func onReceiveFrame<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.Matchable>(frame p0: M1, videoId p1: M2, attendeeId p2: M3, pauseState p3: M4) -> Cuckoo.__DoNotUse<(VideoFrame?, Int, String?, VideoPauseState), Void> where M1.OptionalMatchedType == VideoFrame, M2.MatchedType == Int, M3.OptionalMatchedType == String, M4.MatchedType == VideoPauseState {
            let matchers: [Cuckoo.ParameterMatcher<(VideoFrame?, Int, String?, VideoPauseState)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return cuckoo_manager.verify(
                "onReceiveFrame(frame p0: VideoFrame?, videoId p1: Int, attendeeId p2: String?, pauseState p3: VideoPauseState)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func bindVideoView<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(videoView p0: M1, tileId p1: M2) -> Cuckoo.__DoNotUse<(VideoRenderView, Int), Void> where M1.MatchedType == VideoRenderView, M2.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(VideoRenderView, Int)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "bindVideoView(videoView p0: VideoRenderView, tileId p1: Int)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unbindVideoView<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.__DoNotUse<(Int), Void> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "unbindVideoView(tileId p0: Int)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addVideoTileObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(VideoTileObserver), Void> where M1.MatchedType == VideoTileObserver {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addVideoTileObserver(observer p0: VideoTileObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeVideoTileObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(VideoTileObserver), Void> where M1.MatchedType == VideoTileObserver {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeVideoTileObserver(observer p0: VideoTileObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func pauseRemoteVideoTile<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.__DoNotUse<(Int), Void> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "pauseRemoteVideoTile(tileId p0: Int)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func resumeRemoteVideoTile<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.__DoNotUse<(Int), Void> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "resumeRemoteVideoTile(tileId p0: Int)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class VideoTileControllerStub:VideoTileController, @unchecked Sendable {


    
    public func onReceiveFrame(frame p0: VideoFrame?, videoId p1: Int, attendeeId p2: String?, pauseState p3: VideoPauseState) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func bindVideoView(videoView p0: VideoRenderView, tileId p1: Int) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unbindVideoView(tileId p0: Int) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addVideoTileObserver(observer p0: VideoTileObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeVideoTileObserver(observer p0: VideoTileObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func pauseRemoteVideoTile(tileId p0: Int) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func resumeRemoteVideoTile(tileId p0: Int) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/video/VideoTileControllerFacade.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockVideoTileControllerFacade: VideoTileControllerFacade, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any VideoTileControllerFacade
    public typealias Stubbing = __StubbingProxy_VideoTileControllerFacade
    public typealias Verification = __VerificationProxy_VideoTileControllerFacade

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any VideoTileControllerFacade)?

    public func enableDefaultImplementation(_ stub: any VideoTileControllerFacade) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func bindVideoView(videoView p0: VideoRenderView, tileId p1: Int) {
        return cuckoo_manager.call(
            "bindVideoView(videoView p0: VideoRenderView, tileId p1: Int)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.bindVideoView(videoView: p0, tileId: p1)
        )
    }

    public func unbindVideoView(tileId p0: Int) {
        return cuckoo_manager.call(
            "unbindVideoView(tileId p0: Int)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unbindVideoView(tileId: p0)
        )
    }

    public func addVideoTileObserver(observer p0: VideoTileObserver) {
        return cuckoo_manager.call(
            "addVideoTileObserver(observer p0: VideoTileObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addVideoTileObserver(observer: p0)
        )
    }

    public func removeVideoTileObserver(observer p0: VideoTileObserver) {
        return cuckoo_manager.call(
            "removeVideoTileObserver(observer p0: VideoTileObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeVideoTileObserver(observer: p0)
        )
    }

    public func pauseRemoteVideoTile(tileId p0: Int) {
        return cuckoo_manager.call(
            "pauseRemoteVideoTile(tileId p0: Int)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.pauseRemoteVideoTile(tileId: p0)
        )
    }

    public func resumeRemoteVideoTile(tileId p0: Int) {
        return cuckoo_manager.call(
            "resumeRemoteVideoTile(tileId p0: Int)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.resumeRemoteVideoTile(tileId: p0)
        )
    }

    public struct __StubbingProxy_VideoTileControllerFacade: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func bindVideoView<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(videoView p0: M1, tileId p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoRenderView, Int)> where M1.MatchedType == VideoRenderView, M2.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(VideoRenderView, Int)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileControllerFacade.self,
                method: "bindVideoView(videoView p0: VideoRenderView, tileId p1: Int)",
                parameterMatchers: matchers
            ))
        }
        
        func unbindVideoView<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Int)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileControllerFacade.self,
                method: "unbindVideoView(tileId p0: Int)",
                parameterMatchers: matchers
            ))
        }
        
        func addVideoTileObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoTileObserver)> where M1.MatchedType == VideoTileObserver {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileControllerFacade.self,
                method: "addVideoTileObserver(observer p0: VideoTileObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeVideoTileObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoTileObserver)> where M1.MatchedType == VideoTileObserver {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileControllerFacade.self,
                method: "removeVideoTileObserver(observer p0: VideoTileObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func pauseRemoteVideoTile<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Int)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileControllerFacade.self,
                method: "pauseRemoteVideoTile(tileId p0: Int)",
                parameterMatchers: matchers
            ))
        }
        
        func resumeRemoteVideoTile<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Int)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoTileControllerFacade.self,
                method: "resumeRemoteVideoTile(tileId p0: Int)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_VideoTileControllerFacade: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func bindVideoView<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(videoView p0: M1, tileId p1: M2) -> Cuckoo.__DoNotUse<(VideoRenderView, Int), Void> where M1.MatchedType == VideoRenderView, M2.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(VideoRenderView, Int)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "bindVideoView(videoView p0: VideoRenderView, tileId p1: Int)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unbindVideoView<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.__DoNotUse<(Int), Void> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "unbindVideoView(tileId p0: Int)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addVideoTileObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(VideoTileObserver), Void> where M1.MatchedType == VideoTileObserver {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addVideoTileObserver(observer p0: VideoTileObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeVideoTileObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(VideoTileObserver), Void> where M1.MatchedType == VideoTileObserver {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeVideoTileObserver(observer p0: VideoTileObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func pauseRemoteVideoTile<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.__DoNotUse<(Int), Void> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "pauseRemoteVideoTile(tileId p0: Int)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func resumeRemoteVideoTile<M1: Cuckoo.Matchable>(tileId p0: M1) -> Cuckoo.__DoNotUse<(Int), Void> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "resumeRemoteVideoTile(tileId p0: Int)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class VideoTileControllerFacadeStub:VideoTileControllerFacade, @unchecked Sendable {


    
    public func bindVideoView(videoView p0: VideoRenderView, tileId p1: Int) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unbindVideoView(tileId p0: Int) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addVideoTileObserver(observer p0: VideoTileObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeVideoTileObserver(observer p0: VideoTileObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func pauseRemoteVideoTile(tileId p0: Int) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func resumeRemoteVideoTile(tileId p0: Int) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/video/capture/CameraCaptureSource.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockCameraCaptureSource: CameraCaptureSource, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any CameraCaptureSource
    public typealias Stubbing = __StubbingProxy_CameraCaptureSource
    public typealias Verification = __VerificationProxy_CameraCaptureSource

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any CameraCaptureSource)?

    public func enableDefaultImplementation(_ stub: any CameraCaptureSource) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var device: MediaDevice? {
        get {
            return cuckoo_manager.getter(
                "device",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.device
            )
        }
        set {
            cuckoo_manager.setter(
                "device",
                value: newValue,
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.device = newValue
            )
        }
    }

    public var torchEnabled: Bool {
        get {
            return cuckoo_manager.getter(
                "torchEnabled",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.torchEnabled
            )
        }
        set {
            cuckoo_manager.setter(
                "torchEnabled",
                value: newValue,
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.torchEnabled = newValue
            )
        }
    }

    public var format: VideoCaptureFormat {
        get {
            return cuckoo_manager.getter(
                "format",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.format
            )
        }
        set {
            cuckoo_manager.setter(
                "format",
                value: newValue,
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.format = newValue
            )
        }
    }

    public var videoContentHint: VideoContentHint {
        get {
            return cuckoo_manager.getter(
                "videoContentHint",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.videoContentHint
            )
        }
        set {
            cuckoo_manager.setter(
                "videoContentHint",
                value: newValue,
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.videoContentHint = newValue
            )
        }
    }


    public func switchCamera() {
        return cuckoo_manager.call(
            "switchCamera()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.switchCamera()
        )
    }

    public func start() {
        return cuckoo_manager.call(
            "start()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start()
        )
    }

    public func stop() {
        return cuckoo_manager.call(
            "stop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stop()
        )
    }

    public func addCaptureSourceObserver(observer p0: CaptureSourceObserver) {
        return cuckoo_manager.call(
            "addCaptureSourceObserver(observer p0: CaptureSourceObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addCaptureSourceObserver(observer: p0)
        )
    }

    public func removeCaptureSourceObserver(observer p0: CaptureSourceObserver) {
        return cuckoo_manager.call(
            "removeCaptureSourceObserver(observer p0: CaptureSourceObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeCaptureSourceObserver(observer: p0)
        )
    }

    public func addVideoSink(sink p0: VideoSink) {
        return cuckoo_manager.call(
            "addVideoSink(sink p0: VideoSink)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addVideoSink(sink: p0)
        )
    }

    public func removeVideoSink(sink p0: VideoSink) {
        return cuckoo_manager.call(
            "removeVideoSink(sink p0: VideoSink)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeVideoSink(sink: p0)
        )
    }

    public struct __StubbingProxy_CameraCaptureSource: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var device: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockCameraCaptureSource,MediaDevice> {
            return .init(manager: cuckoo_manager, name: "device")
        }
        
        var torchEnabled: Cuckoo.ProtocolToBeStubbedProperty<MockCameraCaptureSource,Bool> {
            return .init(manager: cuckoo_manager, name: "torchEnabled")
        }
        
        var format: Cuckoo.ProtocolToBeStubbedProperty<MockCameraCaptureSource,VideoCaptureFormat> {
            return .init(manager: cuckoo_manager, name: "format")
        }
        
        var videoContentHint: Cuckoo.ProtocolToBeStubbedProperty<MockCameraCaptureSource,VideoContentHint> {
            return .init(manager: cuckoo_manager, name: "videoContentHint")
        }
        
        func switchCamera() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCameraCaptureSource.self,
                method: "switchCamera()",
                parameterMatchers: matchers
            ))
        }
        
        func start() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCameraCaptureSource.self,
                method: "start()",
                parameterMatchers: matchers
            ))
        }
        
        func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCameraCaptureSource.self,
                method: "stop()",
                parameterMatchers: matchers
            ))
        }
        
        func addCaptureSourceObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(CaptureSourceObserver)> where M1.MatchedType == CaptureSourceObserver {
            let matchers: [Cuckoo.ParameterMatcher<(CaptureSourceObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCameraCaptureSource.self,
                method: "addCaptureSourceObserver(observer p0: CaptureSourceObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeCaptureSourceObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(CaptureSourceObserver)> where M1.MatchedType == CaptureSourceObserver {
            let matchers: [Cuckoo.ParameterMatcher<(CaptureSourceObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCameraCaptureSource.self,
                method: "removeCaptureSourceObserver(observer p0: CaptureSourceObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func addVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSink)> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCameraCaptureSource.self,
                method: "addVideoSink(sink p0: VideoSink)",
                parameterMatchers: matchers
            ))
        }
        
        func removeVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSink)> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCameraCaptureSource.self,
                method: "removeVideoSink(sink p0: VideoSink)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_CameraCaptureSource: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var device: Cuckoo.VerifyOptionalProperty<MediaDevice> {
            return .init(manager: cuckoo_manager, name: "device", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var torchEnabled: Cuckoo.VerifyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "torchEnabled", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var format: Cuckoo.VerifyProperty<VideoCaptureFormat> {
            return .init(manager: cuckoo_manager, name: "format", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var videoContentHint: Cuckoo.VerifyProperty<VideoContentHint> {
            return .init(manager: cuckoo_manager, name: "videoContentHint", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func switchCamera() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "switchCamera()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func start() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "start()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addCaptureSourceObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(CaptureSourceObserver), Void> where M1.MatchedType == CaptureSourceObserver {
            let matchers: [Cuckoo.ParameterMatcher<(CaptureSourceObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addCaptureSourceObserver(observer p0: CaptureSourceObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeCaptureSourceObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(CaptureSourceObserver), Void> where M1.MatchedType == CaptureSourceObserver {
            let matchers: [Cuckoo.ParameterMatcher<(CaptureSourceObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeCaptureSourceObserver(observer p0: CaptureSourceObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.__DoNotUse<(VideoSink), Void> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addVideoSink(sink p0: VideoSink)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.__DoNotUse<(VideoSink), Void> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeVideoSink(sink p0: VideoSink)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class CameraCaptureSourceStub:CameraCaptureSource, @unchecked Sendable {
    
    public var device: MediaDevice? {
        get {
            return DefaultValueRegistry.defaultValue(for: (MediaDevice?).self)
        }
        set {}
    }
    
    public var torchEnabled: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        set {}
    }
    
    public var format: VideoCaptureFormat {
        get {
            return DefaultValueRegistry.defaultValue(for: (VideoCaptureFormat).self)
        }
        set {}
    }
    
    public var videoContentHint: VideoContentHint {
        get {
            return DefaultValueRegistry.defaultValue(for: (VideoContentHint).self)
        }
        set {}
    }


    
    public func switchCamera() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func start() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addCaptureSourceObserver(observer p0: CaptureSourceObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeCaptureSourceObserver(observer p0: CaptureSourceObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addVideoSink(sink p0: VideoSink) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeVideoSink(sink p0: VideoSink) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/video/capture/CaptureSourceObserver.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockCaptureSourceObserver: CaptureSourceObserver, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any CaptureSourceObserver
    public typealias Stubbing = __StubbingProxy_CaptureSourceObserver
    public typealias Verification = __VerificationProxy_CaptureSourceObserver

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any CaptureSourceObserver)?

    public func enableDefaultImplementation(_ stub: any CaptureSourceObserver) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func captureDidStart() {
        return cuckoo_manager.call(
            "captureDidStart()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.captureDidStart()
        )
    }

    public func captureDidStop() {
        return cuckoo_manager.call(
            "captureDidStop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.captureDidStop()
        )
    }

    public func captureDidFail(error p0: CaptureSourceError) {
        return cuckoo_manager.call(
            "captureDidFail(error p0: CaptureSourceError)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.captureDidFail(error: p0)
        )
    }

    public struct __StubbingProxy_CaptureSourceObserver: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func captureDidStart() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCaptureSourceObserver.self,
                method: "captureDidStart()",
                parameterMatchers: matchers
            ))
        }
        
        func captureDidStop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCaptureSourceObserver.self,
                method: "captureDidStop()",
                parameterMatchers: matchers
            ))
        }
        
        func captureDidFail<M1: Cuckoo.Matchable>(error p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(CaptureSourceError)> where M1.MatchedType == CaptureSourceError {
            let matchers: [Cuckoo.ParameterMatcher<(CaptureSourceError)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCaptureSourceObserver.self,
                method: "captureDidFail(error p0: CaptureSourceError)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_CaptureSourceObserver: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func captureDidStart() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "captureDidStart()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func captureDidStop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "captureDidStop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func captureDidFail<M1: Cuckoo.Matchable>(error p0: M1) -> Cuckoo.__DoNotUse<(CaptureSourceError), Void> where M1.MatchedType == CaptureSourceError {
            let matchers: [Cuckoo.ParameterMatcher<(CaptureSourceError)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "captureDidFail(error p0: CaptureSourceError)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class CaptureSourceObserverStub:CaptureSourceObserver, @unchecked Sendable {


    
    public func captureDidStart() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func captureDidStop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func captureDidFail(error p0: CaptureSourceError) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/audiovideo/video/capture/VideoCaptureSource.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockVideoCaptureSource: VideoCaptureSource, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any VideoCaptureSource
    public typealias Stubbing = __StubbingProxy_VideoCaptureSource
    public typealias Verification = __VerificationProxy_VideoCaptureSource

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any VideoCaptureSource)?

    public func enableDefaultImplementation(_ stub: any VideoCaptureSource) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var videoContentHint: VideoContentHint {
        get {
            return cuckoo_manager.getter(
                "videoContentHint",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.videoContentHint
            )
        }
        set {
            cuckoo_manager.setter(
                "videoContentHint",
                value: newValue,
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.videoContentHint = newValue
            )
        }
    }


    public func start() {
        return cuckoo_manager.call(
            "start()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start()
        )
    }

    public func stop() {
        return cuckoo_manager.call(
            "stop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stop()
        )
    }

    public func addCaptureSourceObserver(observer p0: CaptureSourceObserver) {
        return cuckoo_manager.call(
            "addCaptureSourceObserver(observer p0: CaptureSourceObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addCaptureSourceObserver(observer: p0)
        )
    }

    public func removeCaptureSourceObserver(observer p0: CaptureSourceObserver) {
        return cuckoo_manager.call(
            "removeCaptureSourceObserver(observer p0: CaptureSourceObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeCaptureSourceObserver(observer: p0)
        )
    }

    public func addVideoSink(sink p0: VideoSink) {
        return cuckoo_manager.call(
            "addVideoSink(sink p0: VideoSink)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addVideoSink(sink: p0)
        )
    }

    public func removeVideoSink(sink p0: VideoSink) {
        return cuckoo_manager.call(
            "removeVideoSink(sink p0: VideoSink)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeVideoSink(sink: p0)
        )
    }

    public struct __StubbingProxy_VideoCaptureSource: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var videoContentHint: Cuckoo.ProtocolToBeStubbedProperty<MockVideoCaptureSource,VideoContentHint> {
            return .init(manager: cuckoo_manager, name: "videoContentHint")
        }
        
        func start() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoCaptureSource.self,
                method: "start()",
                parameterMatchers: matchers
            ))
        }
        
        func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoCaptureSource.self,
                method: "stop()",
                parameterMatchers: matchers
            ))
        }
        
        func addCaptureSourceObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(CaptureSourceObserver)> where M1.MatchedType == CaptureSourceObserver {
            let matchers: [Cuckoo.ParameterMatcher<(CaptureSourceObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoCaptureSource.self,
                method: "addCaptureSourceObserver(observer p0: CaptureSourceObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeCaptureSourceObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(CaptureSourceObserver)> where M1.MatchedType == CaptureSourceObserver {
            let matchers: [Cuckoo.ParameterMatcher<(CaptureSourceObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoCaptureSource.self,
                method: "removeCaptureSourceObserver(observer p0: CaptureSourceObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func addVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSink)> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoCaptureSource.self,
                method: "addVideoSink(sink p0: VideoSink)",
                parameterMatchers: matchers
            ))
        }
        
        func removeVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSink)> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoCaptureSource.self,
                method: "removeVideoSink(sink p0: VideoSink)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_VideoCaptureSource: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var videoContentHint: Cuckoo.VerifyProperty<VideoContentHint> {
            return .init(manager: cuckoo_manager, name: "videoContentHint", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func start() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "start()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addCaptureSourceObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(CaptureSourceObserver), Void> where M1.MatchedType == CaptureSourceObserver {
            let matchers: [Cuckoo.ParameterMatcher<(CaptureSourceObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addCaptureSourceObserver(observer p0: CaptureSourceObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeCaptureSourceObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(CaptureSourceObserver), Void> where M1.MatchedType == CaptureSourceObserver {
            let matchers: [Cuckoo.ParameterMatcher<(CaptureSourceObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeCaptureSourceObserver(observer p0: CaptureSourceObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.__DoNotUse<(VideoSink), Void> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addVideoSink(sink p0: VideoSink)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeVideoSink<M1: Cuckoo.Matchable>(sink p0: M1) -> Cuckoo.__DoNotUse<(VideoSink), Void> where M1.MatchedType == VideoSink {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSink)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeVideoSink(sink p0: VideoSink)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class VideoCaptureSourceStub:VideoCaptureSource, @unchecked Sendable {
    
    public var videoContentHint: VideoContentHint {
        get {
            return DefaultValueRegistry.defaultValue(for: (VideoContentHint).self)
        }
        set {}
    }


    
    public func start() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addCaptureSourceObserver(observer p0: CaptureSourceObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeCaptureSourceObserver(observer p0: CaptureSourceObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addVideoSink(sink p0: VideoSink) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeVideoSink(sink p0: VideoSink) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/device/DeviceController.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockDeviceController: DeviceController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any DeviceController
    public typealias Stubbing = __StubbingProxy_DeviceController
    public typealias Verification = __VerificationProxy_DeviceController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any DeviceController)?

    public func enableDefaultImplementation(_ stub: any DeviceController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func listAudioDevices() -> [MediaDevice] {
        return cuckoo_manager.call(
            "listAudioDevices() -> [MediaDevice]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.listAudioDevices()
        )
    }

    public func chooseAudioDevice(mediaDevice p0: MediaDevice) {
        return cuckoo_manager.call(
            "chooseAudioDevice(mediaDevice p0: MediaDevice)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.chooseAudioDevice(mediaDevice: p0)
        )
    }

    public func addDeviceChangeObserver(observer p0: DeviceChangeObserver) {
        return cuckoo_manager.call(
            "addDeviceChangeObserver(observer p0: DeviceChangeObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addDeviceChangeObserver(observer: p0)
        )
    }

    public func removeDeviceChangeObserver(observer p0: DeviceChangeObserver) {
        return cuckoo_manager.call(
            "removeDeviceChangeObserver(observer p0: DeviceChangeObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeDeviceChangeObserver(observer: p0)
        )
    }

    public func switchCamera() {
        return cuckoo_manager.call(
            "switchCamera()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.switchCamera()
        )
    }

    public func getActiveCamera() -> MediaDevice? {
        return cuckoo_manager.call(
            "getActiveCamera() -> MediaDevice?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getActiveCamera()
        )
    }

    public func getActiveAudioDevice() -> MediaDevice? {
        return cuckoo_manager.call(
            "getActiveAudioDevice() -> MediaDevice?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getActiveAudioDevice()
        )
    }

    public struct __StubbingProxy_DeviceController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func listAudioDevices() -> Cuckoo.ProtocolStubFunction<(), [MediaDevice]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDeviceController.self,
                method: "listAudioDevices() -> [MediaDevice]",
                parameterMatchers: matchers
            ))
        }
        
        func chooseAudioDevice<M1: Cuckoo.Matchable>(mediaDevice p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MediaDevice)> where M1.MatchedType == MediaDevice {
            let matchers: [Cuckoo.ParameterMatcher<(MediaDevice)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDeviceController.self,
                method: "chooseAudioDevice(mediaDevice p0: MediaDevice)",
                parameterMatchers: matchers
            ))
        }
        
        func addDeviceChangeObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(DeviceChangeObserver)> where M1.MatchedType == DeviceChangeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(DeviceChangeObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDeviceController.self,
                method: "addDeviceChangeObserver(observer p0: DeviceChangeObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeDeviceChangeObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(DeviceChangeObserver)> where M1.MatchedType == DeviceChangeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(DeviceChangeObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDeviceController.self,
                method: "removeDeviceChangeObserver(observer p0: DeviceChangeObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func switchCamera() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDeviceController.self,
                method: "switchCamera()",
                parameterMatchers: matchers
            ))
        }
        
        func getActiveCamera() -> Cuckoo.ProtocolStubFunction<(), MediaDevice?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDeviceController.self,
                method: "getActiveCamera() -> MediaDevice?",
                parameterMatchers: matchers
            ))
        }
        
        func getActiveAudioDevice() -> Cuckoo.ProtocolStubFunction<(), MediaDevice?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDeviceController.self,
                method: "getActiveAudioDevice() -> MediaDevice?",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_DeviceController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func listAudioDevices() -> Cuckoo.__DoNotUse<(), [MediaDevice]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "listAudioDevices() -> [MediaDevice]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func chooseAudioDevice<M1: Cuckoo.Matchable>(mediaDevice p0: M1) -> Cuckoo.__DoNotUse<(MediaDevice), Void> where M1.MatchedType == MediaDevice {
            let matchers: [Cuckoo.ParameterMatcher<(MediaDevice)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "chooseAudioDevice(mediaDevice p0: MediaDevice)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addDeviceChangeObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(DeviceChangeObserver), Void> where M1.MatchedType == DeviceChangeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(DeviceChangeObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addDeviceChangeObserver(observer p0: DeviceChangeObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeDeviceChangeObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(DeviceChangeObserver), Void> where M1.MatchedType == DeviceChangeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(DeviceChangeObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeDeviceChangeObserver(observer p0: DeviceChangeObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func switchCamera() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "switchCamera()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getActiveCamera() -> Cuckoo.__DoNotUse<(), MediaDevice?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getActiveCamera() -> MediaDevice?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getActiveAudioDevice() -> Cuckoo.__DoNotUse<(), MediaDevice?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getActiveAudioDevice() -> MediaDevice?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class DeviceControllerStub:DeviceController, @unchecked Sendable {


    
    public func listAudioDevices() -> [MediaDevice] {
        return DefaultValueRegistry.defaultValue(for: ([MediaDevice]).self)
    }
    
    public func chooseAudioDevice(mediaDevice p0: MediaDevice) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addDeviceChangeObserver(observer p0: DeviceChangeObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeDeviceChangeObserver(observer p0: DeviceChangeObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func switchCamera() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getActiveCamera() -> MediaDevice? {
        return DefaultValueRegistry.defaultValue(for: (MediaDevice?).self)
    }
    
    public func getActiveAudioDevice() -> MediaDevice? {
        return DefaultValueRegistry.defaultValue(for: (MediaDevice?).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/ingestion/AppStateMonitor.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockAppStateMonitor: AppStateMonitor, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AppStateMonitor
    public typealias Stubbing = __StubbingProxy_AppStateMonitor
    public typealias Verification = __VerificationProxy_AppStateMonitor

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AppStateMonitor)?

    public func enableDefaultImplementation(_ stub: any AppStateMonitor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var delegate: AppStateMonitorDelegate? {
        get {
            return cuckoo_manager.getter(
                "delegate",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.delegate
            )
        }
        set {
            cuckoo_manager.setter(
                "delegate",
                value: newValue,
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.delegate = newValue
            )
        }
    }

    public var appState: AppState {
        get {
            return cuckoo_manager.getter(
                "appState",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.appState
            )
        }
    }


    public func start() {
        return cuckoo_manager.call(
            "start()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start()
        )
    }

    public func stop() {
        return cuckoo_manager.call(
            "stop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stop()
        )
    }

    public func getBatteryLevel() -> NSNumber? {
        return cuckoo_manager.call(
            "getBatteryLevel() -> NSNumber?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getBatteryLevel()
        )
    }

    public func getBatteryState() -> BatteryState {
        return cuckoo_manager.call(
            "getBatteryState() -> BatteryState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getBatteryState()
        )
    }

    public func isLowPowerModeEnabled() -> Bool {
        return cuckoo_manager.call(
            "isLowPowerModeEnabled() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isLowPowerModeEnabled()
        )
    }

    public func getNetworkConnectionType() -> NetworkConnectionType {
        return cuckoo_manager.call(
            "getNetworkConnectionType() -> NetworkConnectionType",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getNetworkConnectionType()
        )
    }

    public struct __StubbingProxy_AppStateMonitor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var delegate: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockAppStateMonitor,AppStateMonitorDelegate> {
            return .init(manager: cuckoo_manager, name: "delegate")
        }
        
        var appState: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAppStateMonitor,AppState> {
            return .init(manager: cuckoo_manager, name: "appState")
        }
        
        func start() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAppStateMonitor.self,
                method: "start()",
                parameterMatchers: matchers
            ))
        }
        
        func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAppStateMonitor.self,
                method: "stop()",
                parameterMatchers: matchers
            ))
        }
        
        func getBatteryLevel() -> Cuckoo.ProtocolStubFunction<(), NSNumber?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAppStateMonitor.self,
                method: "getBatteryLevel() -> NSNumber?",
                parameterMatchers: matchers
            ))
        }
        
        func getBatteryState() -> Cuckoo.ProtocolStubFunction<(), BatteryState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAppStateMonitor.self,
                method: "getBatteryState() -> BatteryState",
                parameterMatchers: matchers
            ))
        }
        
        func isLowPowerModeEnabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAppStateMonitor.self,
                method: "isLowPowerModeEnabled() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func getNetworkConnectionType() -> Cuckoo.ProtocolStubFunction<(), NetworkConnectionType> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAppStateMonitor.self,
                method: "getNetworkConnectionType() -> NetworkConnectionType",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_AppStateMonitor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var delegate: Cuckoo.VerifyOptionalProperty<AppStateMonitorDelegate> {
            return .init(manager: cuckoo_manager, name: "delegate", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var appState: Cuckoo.VerifyReadOnlyProperty<AppState> {
            return .init(manager: cuckoo_manager, name: "appState", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func start() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "start()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getBatteryLevel() -> Cuckoo.__DoNotUse<(), NSNumber?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getBatteryLevel() -> NSNumber?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getBatteryState() -> Cuckoo.__DoNotUse<(), BatteryState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getBatteryState() -> BatteryState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isLowPowerModeEnabled() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "isLowPowerModeEnabled() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getNetworkConnectionType() -> Cuckoo.__DoNotUse<(), NetworkConnectionType> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getNetworkConnectionType() -> NetworkConnectionType",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class AppStateMonitorStub:AppStateMonitor, @unchecked Sendable {
    
    public var delegate: AppStateMonitorDelegate? {
        get {
            return DefaultValueRegistry.defaultValue(for: (AppStateMonitorDelegate?).self)
        }
        set {}
    }
    
    public var appState: AppState {
        get {
            return DefaultValueRegistry.defaultValue(for: (AppState).self)
        }
    }


    
    public func start() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getBatteryLevel() -> NSNumber? {
        return DefaultValueRegistry.defaultValue(for: (NSNumber?).self)
    }
    
    public func getBatteryState() -> BatteryState {
        return DefaultValueRegistry.defaultValue(for: (BatteryState).self)
    }
    
    public func isLowPowerModeEnabled() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func getNetworkConnectionType() -> NetworkConnectionType {
        return DefaultValueRegistry.defaultValue(for: (NetworkConnectionType).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/ingestion/AppStateMonitorDelegate.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockAppStateMonitorDelegate: AppStateMonitorDelegate, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AppStateMonitorDelegate
    public typealias Stubbing = __StubbingProxy_AppStateMonitorDelegate
    public typealias Verification = __VerificationProxy_AppStateMonitorDelegate

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AppStateMonitorDelegate)?

    public func enableDefaultImplementation(_ stub: any AppStateMonitorDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func appStateDidChange(monitor p0: AppStateMonitor, newAppState p1: AppState) {
        return cuckoo_manager.call(
            "appStateDidChange(monitor p0: AppStateMonitor, newAppState p1: AppState)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.appStateDidChange(monitor: p0, newAppState: p1)
        )
    }

    public func didReceiveMemoryWarning(monitor p0: AppStateMonitor) {
        return cuckoo_manager.call(
            "didReceiveMemoryWarning(monitor p0: AppStateMonitor)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.didReceiveMemoryWarning(monitor: p0)
        )
    }

    public func networkConnectionTypeDidChange(monitor p0: AppStateMonitor, newNetworkConnectionType p1: NetworkConnectionType) {
        return cuckoo_manager.call(
            "networkConnectionTypeDidChange(monitor p0: AppStateMonitor, newNetworkConnectionType p1: NetworkConnectionType)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.networkConnectionTypeDidChange(monitor: p0, newNetworkConnectionType: p1)
        )
    }

    public struct __StubbingProxy_AppStateMonitorDelegate: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func appStateDidChange<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(monitor p0: M1, newAppState p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(AppStateMonitor, AppState)> where M1.MatchedType == AppStateMonitor, M2.MatchedType == AppState {
            let matchers: [Cuckoo.ParameterMatcher<(AppStateMonitor, AppState)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAppStateMonitorDelegate.self,
                method: "appStateDidChange(monitor p0: AppStateMonitor, newAppState p1: AppState)",
                parameterMatchers: matchers
            ))
        }
        
        func didReceiveMemoryWarning<M1: Cuckoo.Matchable>(monitor p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AppStateMonitor)> where M1.MatchedType == AppStateMonitor {
            let matchers: [Cuckoo.ParameterMatcher<(AppStateMonitor)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAppStateMonitorDelegate.self,
                method: "didReceiveMemoryWarning(monitor p0: AppStateMonitor)",
                parameterMatchers: matchers
            ))
        }
        
        func networkConnectionTypeDidChange<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(monitor p0: M1, newNetworkConnectionType p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(AppStateMonitor, NetworkConnectionType)> where M1.MatchedType == AppStateMonitor, M2.MatchedType == NetworkConnectionType {
            let matchers: [Cuckoo.ParameterMatcher<(AppStateMonitor, NetworkConnectionType)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAppStateMonitorDelegate.self,
                method: "networkConnectionTypeDidChange(monitor p0: AppStateMonitor, newNetworkConnectionType p1: NetworkConnectionType)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_AppStateMonitorDelegate: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func appStateDidChange<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(monitor p0: M1, newAppState p1: M2) -> Cuckoo.__DoNotUse<(AppStateMonitor, AppState), Void> where M1.MatchedType == AppStateMonitor, M2.MatchedType == AppState {
            let matchers: [Cuckoo.ParameterMatcher<(AppStateMonitor, AppState)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "appStateDidChange(monitor p0: AppStateMonitor, newAppState p1: AppState)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func didReceiveMemoryWarning<M1: Cuckoo.Matchable>(monitor p0: M1) -> Cuckoo.__DoNotUse<(AppStateMonitor), Void> where M1.MatchedType == AppStateMonitor {
            let matchers: [Cuckoo.ParameterMatcher<(AppStateMonitor)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "didReceiveMemoryWarning(monitor p0: AppStateMonitor)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func networkConnectionTypeDidChange<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(monitor p0: M1, newNetworkConnectionType p1: M2) -> Cuckoo.__DoNotUse<(AppStateMonitor, NetworkConnectionType), Void> where M1.MatchedType == AppStateMonitor, M2.MatchedType == NetworkConnectionType {
            let matchers: [Cuckoo.ParameterMatcher<(AppStateMonitor, NetworkConnectionType)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "networkConnectionTypeDidChange(monitor p0: AppStateMonitor, newNetworkConnectionType p1: NetworkConnectionType)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class AppStateMonitorDelegateStub:AppStateMonitorDelegate, @unchecked Sendable {


    
    public func appStateDidChange(monitor p0: AppStateMonitor, newAppState p1: AppState) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func didReceiveMemoryWarning(monitor p0: AppStateMonitor) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func networkConnectionTypeDidChange(monitor p0: AppStateMonitor, newNetworkConnectionType p1: NetworkConnectionType) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/ingestion/EventBuffer.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockEventBuffer: EventBuffer, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any EventBuffer
    public typealias Stubbing = __StubbingProxy_EventBuffer
    public typealias Verification = __VerificationProxy_EventBuffer

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any EventBuffer)?

    public func enableDefaultImplementation(_ stub: any EventBuffer) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func add(item p0: SDKEvent) {
        return cuckoo_manager.call(
            "add(item p0: SDKEvent)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.add(item: p0)
        )
    }

    public func process() {
        return cuckoo_manager.call(
            "process()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.process()
        )
    }

    public struct __StubbingProxy_EventBuffer: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func add<M1: Cuckoo.Matchable>(item p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(SDKEvent)> where M1.MatchedType == SDKEvent {
            let matchers: [Cuckoo.ParameterMatcher<(SDKEvent)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventBuffer.self,
                method: "add(item p0: SDKEvent)",
                parameterMatchers: matchers
            ))
        }
        
        func process() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEventBuffer.self,
                method: "process()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_EventBuffer: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func add<M1: Cuckoo.Matchable>(item p0: M1) -> Cuckoo.__DoNotUse<(SDKEvent), Void> where M1.MatchedType == SDKEvent {
            let matchers: [Cuckoo.ParameterMatcher<(SDKEvent)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "add(item p0: SDKEvent)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func process() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "process()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class EventBufferStub:EventBuffer, @unchecked Sendable {


    
    public func add(item p0: SDKEvent) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func process() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/ingestion/EventReporter.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockEventReporter: EventReporter, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any EventReporter
    public typealias Stubbing = __StubbingProxy_EventReporter
    public typealias Verification = __VerificationProxy_EventReporter

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any EventReporter)?

    public func enableDefaultImplementation(_ stub: any EventReporter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func report(event p0: SDKEvent) {
        return cuckoo_manager.call(
            "report(event p0: SDKEvent)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.report(event: p0)
        )
    }

    public func start() {
        return cuckoo_manager.call(
            "start()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start()
        )
    }

    public func stop() {
        return cuckoo_manager.call(
            "stop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stop()
        )
    }

    public struct __StubbingProxy_EventReporter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func report<M1: Cuckoo.Matchable>(event p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(SDKEvent)> where M1.MatchedType == SDKEvent {
            let matchers: [Cuckoo.ParameterMatcher<(SDKEvent)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventReporter.self,
                method: "report(event p0: SDKEvent)",
                parameterMatchers: matchers
            ))
        }
        
        func start() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEventReporter.self,
                method: "start()",
                parameterMatchers: matchers
            ))
        }
        
        func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEventReporter.self,
                method: "stop()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_EventReporter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func report<M1: Cuckoo.Matchable>(event p0: M1) -> Cuckoo.__DoNotUse<(SDKEvent), Void> where M1.MatchedType == SDKEvent {
            let matchers: [Cuckoo.ParameterMatcher<(SDKEvent)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "report(event p0: SDKEvent)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func start() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "start()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class EventReporterStub:EventReporter, @unchecked Sendable {


    
    public func report(event p0: SDKEvent) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func start() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/ingestion/EventSender.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockEventSender: EventSender, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any EventSender
    public typealias Stubbing = __StubbingProxy_EventSender
    public typealias Verification = __VerificationProxy_EventSender

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any EventSender)?

    public func enableDefaultImplementation(_ stub: any EventSender) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func sendEvents(ingestionRecord p0: IngestionRecord, completionHandler p1: @escaping (Bool) -> Void) {
        return cuckoo_manager.call(
            "sendEvents(ingestionRecord p0: IngestionRecord, completionHandler p1: @escaping (Bool) -> Void)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.sendEvents(ingestionRecord: p0, completionHandler: p1)
        )
    }

    public struct __StubbingProxy_EventSender: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func sendEvents<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(ingestionRecord p0: M1, completionHandler p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(IngestionRecord,  (Bool) -> Void)> where M1.MatchedType == IngestionRecord, M2.MatchedType ==  (Bool) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(IngestionRecord,  (Bool) -> Void)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventSender.self,
                method: "sendEvents(ingestionRecord p0: IngestionRecord, completionHandler p1: @escaping (Bool) -> Void)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_EventSender: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func sendEvents<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(ingestionRecord p0: M1, completionHandler p1: M2) -> Cuckoo.__DoNotUse<(IngestionRecord,  (Bool) -> Void), Void> where M1.MatchedType == IngestionRecord, M2.MatchedType ==  (Bool) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(IngestionRecord,  (Bool) -> Void)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "sendEvents(ingestionRecord p0: IngestionRecord, completionHandler p1: @escaping (Bool) -> Void)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class EventSenderStub:EventSender, @unchecked Sendable {


    
    public func sendEvents(ingestionRecord p0: IngestionRecord, completionHandler p1: @escaping (Bool) -> Void) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/ingestion/IngestionEventConverter.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockIngestionEventConverter: IngestionEventConverter, Cuckoo.ClassMock, @unchecked Sendable {
    public typealias MocksType = IngestionEventConverter
    public typealias Stubbing = __StubbingProxy_IngestionEventConverter
    public typealias Verification = __VerificationProxy_IngestionEventConverter

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: IngestionEventConverter?

    public func enableDefaultImplementation(_ stub: IngestionEventConverter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public override func toIngestionMeetingEvent(event p0: SDKEvent, ingestionConfiguration p1: IngestionConfiguration) -> IngestionMeetingEvent {
        return cuckoo_manager.call(
            "toIngestionMeetingEvent(event p0: SDKEvent, ingestionConfiguration p1: IngestionConfiguration) -> IngestionMeetingEvent",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: super.toIngestionMeetingEvent(event: p0, ingestionConfiguration: p1),
            defaultCall: __defaultImplStub!.toIngestionMeetingEvent(event: p0, ingestionConfiguration: p1)
        )
    }

    public override func toIngestionRecord(dirtyMeetingEvents p0: [DirtyMeetingEventItem], ingestionConfiguration p1: IngestionConfiguration) -> IngestionRecord {
        return cuckoo_manager.call(
            "toIngestionRecord(dirtyMeetingEvents p0: [DirtyMeetingEventItem], ingestionConfiguration p1: IngestionConfiguration) -> IngestionRecord",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: super.toIngestionRecord(dirtyMeetingEvents: p0, ingestionConfiguration: p1),
            defaultCall: __defaultImplStub!.toIngestionRecord(dirtyMeetingEvents: p0, ingestionConfiguration: p1)
        )
    }

    public override func toIngestionRecord(meetingEvents p0: [MeetingEventItem], ingestionConfiguration p1: IngestionConfiguration) -> IngestionRecord {
        return cuckoo_manager.call(
            "toIngestionRecord(meetingEvents p0: [MeetingEventItem], ingestionConfiguration p1: IngestionConfiguration) -> IngestionRecord",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: super.toIngestionRecord(meetingEvents: p0, ingestionConfiguration: p1),
            defaultCall: __defaultImplStub!.toIngestionRecord(meetingEvents: p0, ingestionConfiguration: p1)
        )
    }

    public struct __StubbingProxy_IngestionEventConverter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func toIngestionMeetingEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event p0: M1, ingestionConfiguration p1: M2) -> Cuckoo.ClassStubFunction<(SDKEvent, IngestionConfiguration), IngestionMeetingEvent> where M1.MatchedType == SDKEvent, M2.MatchedType == IngestionConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(SDKEvent, IngestionConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockIngestionEventConverter.self,
                method: "toIngestionMeetingEvent(event p0: SDKEvent, ingestionConfiguration p1: IngestionConfiguration) -> IngestionMeetingEvent",
                parameterMatchers: matchers
            ))
        }
        
        func toIngestionRecord<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(dirtyMeetingEvents p0: M1, ingestionConfiguration p1: M2) -> Cuckoo.ClassStubFunction<([DirtyMeetingEventItem], IngestionConfiguration), IngestionRecord> where M1.MatchedType == [DirtyMeetingEventItem], M2.MatchedType == IngestionConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<([DirtyMeetingEventItem], IngestionConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockIngestionEventConverter.self,
                method: "toIngestionRecord(dirtyMeetingEvents p0: [DirtyMeetingEventItem], ingestionConfiguration p1: IngestionConfiguration) -> IngestionRecord",
                parameterMatchers: matchers
            ))
        }
        
        func toIngestionRecord<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(meetingEvents p0: M1, ingestionConfiguration p1: M2) -> Cuckoo.ClassStubFunction<([MeetingEventItem], IngestionConfiguration), IngestionRecord> where M1.MatchedType == [MeetingEventItem], M2.MatchedType == IngestionConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<([MeetingEventItem], IngestionConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockIngestionEventConverter.self,
                method: "toIngestionRecord(meetingEvents p0: [MeetingEventItem], ingestionConfiguration p1: IngestionConfiguration) -> IngestionRecord",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_IngestionEventConverter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func toIngestionMeetingEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event p0: M1, ingestionConfiguration p1: M2) -> Cuckoo.__DoNotUse<(SDKEvent, IngestionConfiguration), IngestionMeetingEvent> where M1.MatchedType == SDKEvent, M2.MatchedType == IngestionConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(SDKEvent, IngestionConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "toIngestionMeetingEvent(event p0: SDKEvent, ingestionConfiguration p1: IngestionConfiguration) -> IngestionMeetingEvent",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func toIngestionRecord<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(dirtyMeetingEvents p0: M1, ingestionConfiguration p1: M2) -> Cuckoo.__DoNotUse<([DirtyMeetingEventItem], IngestionConfiguration), IngestionRecord> where M1.MatchedType == [DirtyMeetingEventItem], M2.MatchedType == IngestionConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<([DirtyMeetingEventItem], IngestionConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "toIngestionRecord(dirtyMeetingEvents p0: [DirtyMeetingEventItem], ingestionConfiguration p1: IngestionConfiguration) -> IngestionRecord",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func toIngestionRecord<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(meetingEvents p0: M1, ingestionConfiguration p1: M2) -> Cuckoo.__DoNotUse<([MeetingEventItem], IngestionConfiguration), IngestionRecord> where M1.MatchedType == [MeetingEventItem], M2.MatchedType == IngestionConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<([MeetingEventItem], IngestionConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "toIngestionRecord(meetingEvents p0: [MeetingEventItem], ingestionConfiguration p1: IngestionConfiguration) -> IngestionRecord",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class IngestionEventConverterStub:IngestionEventConverter, @unchecked Sendable {


    
    public override func toIngestionMeetingEvent(event p0: SDKEvent, ingestionConfiguration p1: IngestionConfiguration) -> IngestionMeetingEvent {
        return DefaultValueRegistry.defaultValue(for: (IngestionMeetingEvent).self)
    }
    
    public override func toIngestionRecord(dirtyMeetingEvents p0: [DirtyMeetingEventItem], ingestionConfiguration p1: IngestionConfiguration) -> IngestionRecord {
        return DefaultValueRegistry.defaultValue(for: (IngestionRecord).self)
    }
    
    public override func toIngestionRecord(meetingEvents p0: [MeetingEventItem], ingestionConfiguration p1: IngestionConfiguration) -> IngestionRecord {
        return DefaultValueRegistry.defaultValue(for: (IngestionRecord).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/analytics/MeetingStatsCollector.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockMeetingStatsCollector: MeetingStatsCollector, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any MeetingStatsCollector
    public typealias Stubbing = __StubbingProxy_MeetingStatsCollector
    public typealias Verification = __VerificationProxy_MeetingStatsCollector

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any MeetingStatsCollector)?

    public func enableDefaultImplementation(_ stub: any MeetingStatsCollector) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func incrementRetryCount() {
        return cuckoo_manager.call(
            "incrementRetryCount()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.incrementRetryCount()
        )
    }

    public func incrementPoorConnectionCount() {
        return cuckoo_manager.call(
            "incrementPoorConnectionCount()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.incrementPoorConnectionCount()
        )
    }

    public func addMeetingHistoryEvent(historyEventName p0: MeetingHistoryEventName, timestampMs p1: Int64) {
        return cuckoo_manager.call(
            "addMeetingHistoryEvent(historyEventName p0: MeetingHistoryEventName, timestampMs p1: Int64)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addMeetingHistoryEvent(historyEventName: p0, timestampMs: p1)
        )
    }

    public func updateMaxVideoTile(videoTileCount p0: Int) {
        return cuckoo_manager.call(
            "updateMaxVideoTile(videoTileCount p0: Int)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.updateMaxVideoTile(videoTileCount: p0)
        )
    }

    public func updateMeetingStartConnectingTimeMs() {
        return cuckoo_manager.call(
            "updateMeetingStartConnectingTimeMs()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.updateMeetingStartConnectingTimeMs()
        )
    }

    public func updateMeetingStartTimeMs() {
        return cuckoo_manager.call(
            "updateMeetingStartTimeMs()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.updateMeetingStartTimeMs()
        )
    }

    public func updateMeetingStartReconnectingTimeMs() {
        return cuckoo_manager.call(
            "updateMeetingStartReconnectingTimeMs()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.updateMeetingStartReconnectingTimeMs()
        )
    }

    public func updateMeetingReconnectedTimeMs() {
        return cuckoo_manager.call(
            "updateMeetingReconnectedTimeMs()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.updateMeetingReconnectedTimeMs()
        )
    }

    public func resetMeetingStats() {
        return cuckoo_manager.call(
            "resetMeetingStats()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.resetMeetingStats()
        )
    }

    public func getMeetingStats() -> [AnyHashable: Any] {
        return cuckoo_manager.call(
            "getMeetingStats() -> [AnyHashable: Any]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getMeetingStats()
        )
    }

    public func getMeetingHistory() -> [MeetingHistoryEvent] {
        return cuckoo_manager.call(
            "getMeetingHistory() -> [MeetingHistoryEvent]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getMeetingHistory()
        )
    }

    public struct __StubbingProxy_MeetingStatsCollector: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func incrementRetryCount() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockMeetingStatsCollector.self,
                method: "incrementRetryCount()",
                parameterMatchers: matchers
            ))
        }
        
        func incrementPoorConnectionCount() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockMeetingStatsCollector.self,
                method: "incrementPoorConnectionCount()",
                parameterMatchers: matchers
            ))
        }
        
        func addMeetingHistoryEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(historyEventName p0: M1, timestampMs p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(MeetingHistoryEventName, Int64)> where M1.MatchedType == MeetingHistoryEventName, M2.MatchedType == Int64 {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingHistoryEventName, Int64)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockMeetingStatsCollector.self,
                method: "addMeetingHistoryEvent(historyEventName p0: MeetingHistoryEventName, timestampMs p1: Int64)",
                parameterMatchers: matchers
            ))
        }
        
        func updateMaxVideoTile<M1: Cuckoo.Matchable>(videoTileCount p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Int)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockMeetingStatsCollector.self,
                method: "updateMaxVideoTile(videoTileCount p0: Int)",
                parameterMatchers: matchers
            ))
        }
        
        func updateMeetingStartConnectingTimeMs() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockMeetingStatsCollector.self,
                method: "updateMeetingStartConnectingTimeMs()",
                parameterMatchers: matchers
            ))
        }
        
        func updateMeetingStartTimeMs() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockMeetingStatsCollector.self,
                method: "updateMeetingStartTimeMs()",
                parameterMatchers: matchers
            ))
        }
        
        func updateMeetingStartReconnectingTimeMs() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockMeetingStatsCollector.self,
                method: "updateMeetingStartReconnectingTimeMs()",
                parameterMatchers: matchers
            ))
        }
        
        func updateMeetingReconnectedTimeMs() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockMeetingStatsCollector.self,
                method: "updateMeetingReconnectedTimeMs()",
                parameterMatchers: matchers
            ))
        }
        
        func resetMeetingStats() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockMeetingStatsCollector.self,
                method: "resetMeetingStats()",
                parameterMatchers: matchers
            ))
        }
        
        func getMeetingStats() -> Cuckoo.ProtocolStubFunction<(), [AnyHashable: Any]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockMeetingStatsCollector.self,
                method: "getMeetingStats() -> [AnyHashable: Any]",
                parameterMatchers: matchers
            ))
        }
        
        func getMeetingHistory() -> Cuckoo.ProtocolStubFunction<(), [MeetingHistoryEvent]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockMeetingStatsCollector.self,
                method: "getMeetingHistory() -> [MeetingHistoryEvent]",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_MeetingStatsCollector: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func incrementRetryCount() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "incrementRetryCount()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func incrementPoorConnectionCount() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "incrementPoorConnectionCount()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addMeetingHistoryEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(historyEventName p0: M1, timestampMs p1: M2) -> Cuckoo.__DoNotUse<(MeetingHistoryEventName, Int64), Void> where M1.MatchedType == MeetingHistoryEventName, M2.MatchedType == Int64 {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingHistoryEventName, Int64)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "addMeetingHistoryEvent(historyEventName p0: MeetingHistoryEventName, timestampMs p1: Int64)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateMaxVideoTile<M1: Cuckoo.Matchable>(videoTileCount p0: M1) -> Cuckoo.__DoNotUse<(Int), Void> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "updateMaxVideoTile(videoTileCount p0: Int)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateMeetingStartConnectingTimeMs() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "updateMeetingStartConnectingTimeMs()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateMeetingStartTimeMs() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "updateMeetingStartTimeMs()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateMeetingStartReconnectingTimeMs() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "updateMeetingStartReconnectingTimeMs()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateMeetingReconnectedTimeMs() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "updateMeetingReconnectedTimeMs()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func resetMeetingStats() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "resetMeetingStats()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getMeetingStats() -> Cuckoo.__DoNotUse<(), [AnyHashable: Any]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getMeetingStats() -> [AnyHashable: Any]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getMeetingHistory() -> Cuckoo.__DoNotUse<(), [MeetingHistoryEvent]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getMeetingHistory() -> [MeetingHistoryEvent]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class MeetingStatsCollectorStub:MeetingStatsCollector, @unchecked Sendable {


    
    public func incrementRetryCount() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func incrementPoorConnectionCount() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addMeetingHistoryEvent(historyEventName p0: MeetingHistoryEventName, timestampMs p1: Int64) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateMaxVideoTile(videoTileCount p0: Int) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateMeetingStartConnectingTimeMs() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateMeetingStartTimeMs() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateMeetingStartReconnectingTimeMs() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateMeetingReconnectedTimeMs() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func resetMeetingStats() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getMeetingStats() -> [AnyHashable: Any] {
        return DefaultValueRegistry.defaultValue(for: ([AnyHashable: Any]).self)
    }
    
    public func getMeetingHistory() -> [MeetingHistoryEvent] {
        return DefaultValueRegistry.defaultValue(for: ([MeetingHistoryEvent]).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/audio/protocols/AudioClientController.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockAudioClientController: AudioClientController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AudioClientController
    public typealias Stubbing = __StubbingProxy_AudioClientController
    public typealias Verification = __VerificationProxy_AudioClientController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AudioClientController)?

    public func enableDefaultImplementation(_ stub: any AudioClientController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func setMute(mute p0: Bool) -> Bool {
        return cuckoo_manager.call(
            "setMute(mute p0: Bool) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setMute(mute: p0)
        )
    }

    public func setPlaybackMute(mute p0: Bool) -> Bool {
        return cuckoo_manager.call(
            "setPlaybackMute(mute p0: Bool) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setPlaybackMute(mute: p0)
        )
    }

    public func start(audioFallbackUrl p0: String, audioHostUrl p1: String, meetingId p2: String, attendeeId p3: String, joinToken p4: String, callKitEnabled p5: Bool, audioMode p6: AudioMode, audioDeviceCapabilities p7: AudioDeviceCapabilities, enableAudioRedundancy p8: Bool, reconnectTimeoutMs p9: Int) throws {
        return try cuckoo_manager.callThrows(
            "start(audioFallbackUrl p0: String, audioHostUrl p1: String, meetingId p2: String, attendeeId p3: String, joinToken p4: String, callKitEnabled p5: Bool, audioMode p6: AudioMode, audioDeviceCapabilities p7: AudioDeviceCapabilities, enableAudioRedundancy p8: Bool, reconnectTimeoutMs p9: Int) throws",
            parameters: (p0, p1, p2, p3, p4, p5, p6, p7, p8, p9),
            escapingParameters: (p0, p1, p2, p3, p4, p5, p6, p7, p8, p9),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start(audioFallbackUrl: p0, audioHostUrl: p1, meetingId: p2, attendeeId: p3, joinToken: p4, callKitEnabled: p5, audioMode: p6, audioDeviceCapabilities: p7, enableAudioRedundancy: p8, reconnectTimeoutMs: p9)
        )
    }

    public func stop() {
        return cuckoo_manager.call(
            "stop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stop()
        )
    }

    public func setVoiceFocusEnabled(enabled p0: Bool) -> Bool {
        return cuckoo_manager.call(
            "setVoiceFocusEnabled(enabled p0: Bool) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setVoiceFocusEnabled(enabled: p0)
        )
    }

    public func isVoiceFocusEnabled() -> Bool {
        return cuckoo_manager.call(
            "isVoiceFocusEnabled() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isVoiceFocusEnabled()
        )
    }

    public func promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver) {
        return cuckoo_manager.call(
            "promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.promoteToPrimaryMeeting(credentials: p0, observer: p1)
        )
    }

    public func demoteFromPrimaryMeeting() {
        return cuckoo_manager.call(
            "demoteFromPrimaryMeeting()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.demoteFromPrimaryMeeting()
        )
    }

    public struct __StubbingProxy_AudioClientController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func setMute<M1: Cuckoo.Matchable>(mute p0: M1) -> Cuckoo.ProtocolStubFunction<(Bool), Bool> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientController.self,
                method: "setMute(mute p0: Bool) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func setPlaybackMute<M1: Cuckoo.Matchable>(mute p0: M1) -> Cuckoo.ProtocolStubFunction<(Bool), Bool> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientController.self,
                method: "setPlaybackMute(mute p0: Bool) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func start<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable, M6: Cuckoo.Matchable, M7: Cuckoo.Matchable, M8: Cuckoo.Matchable, M9: Cuckoo.Matchable, M10: Cuckoo.Matchable>(audioFallbackUrl p0: M1, audioHostUrl p1: M2, meetingId p2: M3, attendeeId p3: M4, joinToken p4: M5, callKitEnabled p5: M6, audioMode p6: M7, audioDeviceCapabilities p7: M8, enableAudioRedundancy p8: M9, reconnectTimeoutMs p9: M10) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String, String, String, String, String, Bool, AudioMode, AudioDeviceCapabilities, Bool, Int),Swift.Error> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == String, M4.MatchedType == String, M5.MatchedType == String, M6.MatchedType == Bool, M7.MatchedType == AudioMode, M8.MatchedType == AudioDeviceCapabilities, M9.MatchedType == Bool, M10.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, String, String, String, Bool, AudioMode, AudioDeviceCapabilities, Bool, Int)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }, wrap(matchable: p5) { $0.5 }, wrap(matchable: p6) { $0.6 }, wrap(matchable: p7) { $0.7 }, wrap(matchable: p8) { $0.8 }, wrap(matchable: p9) { $0.9 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientController.self,
                method: "start(audioFallbackUrl p0: String, audioHostUrl p1: String, meetingId p2: String, attendeeId p3: String, joinToken p4: String, callKitEnabled p5: Bool, audioMode p6: AudioMode, audioDeviceCapabilities p7: AudioDeviceCapabilities, enableAudioRedundancy p8: Bool, reconnectTimeoutMs p9: Int) throws",
                parameterMatchers: matchers
            ))
        }
        
        func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientController.self,
                method: "stop()",
                parameterMatchers: matchers
            ))
        }
        
        func setVoiceFocusEnabled<M1: Cuckoo.Matchable>(enabled p0: M1) -> Cuckoo.ProtocolStubFunction<(Bool), Bool> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientController.self,
                method: "setVoiceFocusEnabled(enabled p0: Bool) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func isVoiceFocusEnabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientController.self,
                method: "isVoiceFocusEnabled() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func promoteToPrimaryMeeting<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(credentials p0: M1, observer p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver)> where M1.MatchedType == MeetingSessionCredentials, M2.MatchedType == PrimaryMeetingPromotionObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientController.self,
                method: "promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func demoteFromPrimaryMeeting() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientController.self,
                method: "demoteFromPrimaryMeeting()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_AudioClientController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func setMute<M1: Cuckoo.Matchable>(mute p0: M1) -> Cuckoo.__DoNotUse<(Bool), Bool> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setMute(mute p0: Bool) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setPlaybackMute<M1: Cuckoo.Matchable>(mute p0: M1) -> Cuckoo.__DoNotUse<(Bool), Bool> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setPlaybackMute(mute p0: Bool) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func start<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable, M6: Cuckoo.Matchable, M7: Cuckoo.Matchable, M8: Cuckoo.Matchable, M9: Cuckoo.Matchable, M10: Cuckoo.Matchable>(audioFallbackUrl p0: M1, audioHostUrl p1: M2, meetingId p2: M3, attendeeId p3: M4, joinToken p4: M5, callKitEnabled p5: M6, audioMode p6: M7, audioDeviceCapabilities p7: M8, enableAudioRedundancy p8: M9, reconnectTimeoutMs p9: M10) -> Cuckoo.__DoNotUse<(String, String, String, String, String, Bool, AudioMode, AudioDeviceCapabilities, Bool, Int), Void> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == String, M4.MatchedType == String, M5.MatchedType == String, M6.MatchedType == Bool, M7.MatchedType == AudioMode, M8.MatchedType == AudioDeviceCapabilities, M9.MatchedType == Bool, M10.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, String, String, String, Bool, AudioMode, AudioDeviceCapabilities, Bool, Int)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }, wrap(matchable: p5) { $0.5 }, wrap(matchable: p6) { $0.6 }, wrap(matchable: p7) { $0.7 }, wrap(matchable: p8) { $0.8 }, wrap(matchable: p9) { $0.9 }]
            return cuckoo_manager.verify(
                "start(audioFallbackUrl p0: String, audioHostUrl p1: String, meetingId p2: String, attendeeId p3: String, joinToken p4: String, callKitEnabled p5: Bool, audioMode p6: AudioMode, audioDeviceCapabilities p7: AudioDeviceCapabilities, enableAudioRedundancy p8: Bool, reconnectTimeoutMs p9: Int) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setVoiceFocusEnabled<M1: Cuckoo.Matchable>(enabled p0: M1) -> Cuckoo.__DoNotUse<(Bool), Bool> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setVoiceFocusEnabled(enabled p0: Bool) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isVoiceFocusEnabled() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "isVoiceFocusEnabled() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func promoteToPrimaryMeeting<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(credentials p0: M1, observer p1: M2) -> Cuckoo.__DoNotUse<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver), Void> where M1.MatchedType == MeetingSessionCredentials, M2.MatchedType == PrimaryMeetingPromotionObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func demoteFromPrimaryMeeting() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "demoteFromPrimaryMeeting()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class AudioClientControllerStub:AudioClientController, @unchecked Sendable {


    
    public func setMute(mute p0: Bool) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func setPlaybackMute(mute p0: Bool) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func start(audioFallbackUrl p0: String, audioHostUrl p1: String, meetingId p2: String, attendeeId p3: String, joinToken p4: String, callKitEnabled p5: Bool, audioMode p6: AudioMode, audioDeviceCapabilities p7: AudioDeviceCapabilities, enableAudioRedundancy p8: Bool, reconnectTimeoutMs p9: Int) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setVoiceFocusEnabled(enabled p0: Bool) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func isVoiceFocusEnabled() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func demoteFromPrimaryMeeting() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/audio/protocols/AudioClientObserver.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockAudioClientObserver: AudioClientObserver, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AudioClientObserver
    public typealias Stubbing = __StubbingProxy_AudioClientObserver
    public typealias Verification = __VerificationProxy_AudioClientObserver

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AudioClientObserver)?

    public func enableDefaultImplementation(_ stub: any AudioClientObserver) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var audioStatus: MeetingSessionStatusCode {
        get {
            return cuckoo_manager.getter(
                "audioStatus",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.audioStatus
            )
        }
    }


    public func notifyAudioClientObserver(observerFunction p0: @escaping (_ observer: AudioVideoObserver) -> Void) {
        return cuckoo_manager.call(
            "notifyAudioClientObserver(observerFunction p0: @escaping (_ observer: AudioVideoObserver) -> Void)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.notifyAudioClientObserver(observerFunction: p0)
        )
    }

    public func subscribeToAudioClientStateChange(observer p0: AudioVideoObserver) {
        return cuckoo_manager.call(
            "subscribeToAudioClientStateChange(observer p0: AudioVideoObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.subscribeToAudioClientStateChange(observer: p0)
        )
    }

    public func subscribeToRealTimeEvents(observer p0: RealtimeObserver) {
        return cuckoo_manager.call(
            "subscribeToRealTimeEvents(observer p0: RealtimeObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.subscribeToRealTimeEvents(observer: p0)
        )
    }

    public func unsubscribeFromAudioClientStateChange(observer p0: AudioVideoObserver) {
        return cuckoo_manager.call(
            "unsubscribeFromAudioClientStateChange(observer p0: AudioVideoObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unsubscribeFromAudioClientStateChange(observer: p0)
        )
    }

    public func unsubscribeFromRealTimeEvents(observer p0: RealtimeObserver) {
        return cuckoo_manager.call(
            "unsubscribeFromRealTimeEvents(observer p0: RealtimeObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unsubscribeFromRealTimeEvents(observer: p0)
        )
    }

    public func subscribeToTranscriptEvent(observer p0: TranscriptEventObserver) {
        return cuckoo_manager.call(
            "subscribeToTranscriptEvent(observer p0: TranscriptEventObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.subscribeToTranscriptEvent(observer: p0)
        )
    }

    public func unsubscribeFromTranscriptEvent(observer p0: TranscriptEventObserver) {
        return cuckoo_manager.call(
            "unsubscribeFromTranscriptEvent(observer p0: TranscriptEventObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unsubscribeFromTranscriptEvent(observer: p0)
        )
    }

    public func setPrimaryMeetingPromotionObserver(observer p0: PrimaryMeetingPromotionObserver) {
        return cuckoo_manager.call(
            "setPrimaryMeetingPromotionObserver(observer p0: PrimaryMeetingPromotionObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setPrimaryMeetingPromotionObserver(observer: p0)
        )
    }

    public struct __StubbingProxy_AudioClientObserver: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var audioStatus: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAudioClientObserver,MeetingSessionStatusCode> {
            return .init(manager: cuckoo_manager, name: "audioStatus")
        }
        
        func notifyAudioClientObserver<M1: Cuckoo.Matchable>(observerFunction p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<( (_ observer: AudioVideoObserver) -> Void)> where M1.MatchedType ==  (_ observer: AudioVideoObserver) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<( (_ observer: AudioVideoObserver) -> Void)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientObserver.self,
                method: "notifyAudioClientObserver(observerFunction p0: @escaping (_ observer: AudioVideoObserver) -> Void)",
                parameterMatchers: matchers
            ))
        }
        
        func subscribeToAudioClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AudioVideoObserver)> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientObserver.self,
                method: "subscribeToAudioClientStateChange(observer p0: AudioVideoObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func subscribeToRealTimeEvents<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(RealtimeObserver)> where M1.MatchedType == RealtimeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(RealtimeObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientObserver.self,
                method: "subscribeToRealTimeEvents(observer p0: RealtimeObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func unsubscribeFromAudioClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AudioVideoObserver)> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientObserver.self,
                method: "unsubscribeFromAudioClientStateChange(observer p0: AudioVideoObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func unsubscribeFromRealTimeEvents<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(RealtimeObserver)> where M1.MatchedType == RealtimeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(RealtimeObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientObserver.self,
                method: "unsubscribeFromRealTimeEvents(observer p0: RealtimeObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func subscribeToTranscriptEvent<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(TranscriptEventObserver)> where M1.MatchedType == TranscriptEventObserver {
            let matchers: [Cuckoo.ParameterMatcher<(TranscriptEventObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientObserver.self,
                method: "subscribeToTranscriptEvent(observer p0: TranscriptEventObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func unsubscribeFromTranscriptEvent<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(TranscriptEventObserver)> where M1.MatchedType == TranscriptEventObserver {
            let matchers: [Cuckoo.ParameterMatcher<(TranscriptEventObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientObserver.self,
                method: "unsubscribeFromTranscriptEvent(observer p0: TranscriptEventObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func setPrimaryMeetingPromotionObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PrimaryMeetingPromotionObserver)> where M1.MatchedType == PrimaryMeetingPromotionObserver {
            let matchers: [Cuckoo.ParameterMatcher<(PrimaryMeetingPromotionObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientObserver.self,
                method: "setPrimaryMeetingPromotionObserver(observer p0: PrimaryMeetingPromotionObserver)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_AudioClientObserver: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var audioStatus: Cuckoo.VerifyReadOnlyProperty<MeetingSessionStatusCode> {
            return .init(manager: cuckoo_manager, name: "audioStatus", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func notifyAudioClientObserver<M1: Cuckoo.Matchable>(observerFunction p0: M1) -> Cuckoo.__DoNotUse<( (_ observer: AudioVideoObserver) -> Void), Void> where M1.MatchedType ==  (_ observer: AudioVideoObserver) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<( (_ observer: AudioVideoObserver) -> Void)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "notifyAudioClientObserver(observerFunction p0: @escaping (_ observer: AudioVideoObserver) -> Void)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func subscribeToAudioClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(AudioVideoObserver), Void> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "subscribeToAudioClientStateChange(observer p0: AudioVideoObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func subscribeToRealTimeEvents<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(RealtimeObserver), Void> where M1.MatchedType == RealtimeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(RealtimeObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "subscribeToRealTimeEvents(observer p0: RealtimeObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unsubscribeFromAudioClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(AudioVideoObserver), Void> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "unsubscribeFromAudioClientStateChange(observer p0: AudioVideoObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unsubscribeFromRealTimeEvents<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(RealtimeObserver), Void> where M1.MatchedType == RealtimeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(RealtimeObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "unsubscribeFromRealTimeEvents(observer p0: RealtimeObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func subscribeToTranscriptEvent<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(TranscriptEventObserver), Void> where M1.MatchedType == TranscriptEventObserver {
            let matchers: [Cuckoo.ParameterMatcher<(TranscriptEventObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "subscribeToTranscriptEvent(observer p0: TranscriptEventObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unsubscribeFromTranscriptEvent<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(TranscriptEventObserver), Void> where M1.MatchedType == TranscriptEventObserver {
            let matchers: [Cuckoo.ParameterMatcher<(TranscriptEventObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "unsubscribeFromTranscriptEvent(observer p0: TranscriptEventObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setPrimaryMeetingPromotionObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(PrimaryMeetingPromotionObserver), Void> where M1.MatchedType == PrimaryMeetingPromotionObserver {
            let matchers: [Cuckoo.ParameterMatcher<(PrimaryMeetingPromotionObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setPrimaryMeetingPromotionObserver(observer p0: PrimaryMeetingPromotionObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class AudioClientObserverStub:AudioClientObserver, @unchecked Sendable {
    
    public var audioStatus: MeetingSessionStatusCode {
        get {
            return DefaultValueRegistry.defaultValue(for: (MeetingSessionStatusCode).self)
        }
    }


    
    public func notifyAudioClientObserver(observerFunction p0: @escaping (_ observer: AudioVideoObserver) -> Void) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func subscribeToAudioClientStateChange(observer p0: AudioVideoObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func subscribeToRealTimeEvents(observer p0: RealtimeObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unsubscribeFromAudioClientStateChange(observer p0: AudioVideoObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unsubscribeFromRealTimeEvents(observer p0: RealtimeObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func subscribeToTranscriptEvent(observer p0: TranscriptEventObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unsubscribeFromTranscriptEvent(observer p0: TranscriptEventObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setPrimaryMeetingPromotionObserver(observer p0: PrimaryMeetingPromotionObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/audio/protocols/AudioClientProtocol.swift'

import Cuckoo
import AmazonChimeSDKMedia
import Foundation
import AVFoundation
import UIKit
@testable import AmazonChimeSDK

public class MockAudioClientProtocol: AudioClientProtocol, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AudioClientProtocol
    public typealias Stubbing = __StubbingProxy_AudioClientProtocol
    public typealias Verification = __VerificationProxy_AudioClientProtocol

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AudioClientProtocol)?

    public func enableDefaultImplementation(_ stub: any AudioClientProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var delegate: AudioClientDelegate! {
        get {
            return cuckoo_manager.getter(
                "delegate",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.delegate
            )
        }
        set {
            cuckoo_manager.setter(
                "delegate",
                value: newValue,
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.delegate = newValue
            )
        }
    }


    public func startSession(_ p0: String!, basePort p1: Int, callId p2: String!, profileId p3: String!, microphoneMute p4: Bool, speakerMute p5: Bool, isPresenter p6: Bool, sessionToken p7: String!, audioWsUrl p8: String!, callKitEnabled p9: Bool, appInfo p10: AppInfo!, audioMode p11: AudioModeInternal, audioDeviceCapabilities p12: AudioDeviceCapabilitiesInternal, enableAudioRedundancy p13: Bool, reconnectTimeoutMs p14: Int) -> audio_client_status_t {
        return cuckoo_manager.call(
            "startSession(_ p0: String!, basePort p1: Int, callId p2: String!, profileId p3: String!, microphoneMute p4: Bool, speakerMute p5: Bool, isPresenter p6: Bool, sessionToken p7: String!, audioWsUrl p8: String!, callKitEnabled p9: Bool, appInfo p10: AppInfo!, audioMode p11: AudioModeInternal, audioDeviceCapabilities p12: AudioDeviceCapabilitiesInternal, enableAudioRedundancy p13: Bool, reconnectTimeoutMs p14: Int) -> audio_client_status_t",
            parameters: (p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14),
            escapingParameters: (p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startSession(p0, basePort: p1, callId: p2, profileId: p3, microphoneMute: p4, speakerMute: p5, isPresenter: p6, sessionToken: p7, audioWsUrl: p8, callKitEnabled: p9, appInfo: p10, audioMode: p11, audioDeviceCapabilities: p12, enableAudioRedundancy: p13, reconnectTimeoutMs: p14)
        )
    }

    public func stopSession() -> Int {
        return cuckoo_manager.call(
            "stopSession() -> Int",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopSession()
        )
    }

    public func isSpeakerOn() -> Bool {
        return cuckoo_manager.call(
            "isSpeakerOn() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isSpeakerOn()
        )
    }

    public func setSpeakerOn(_ p0: Bool) -> Bool {
        return cuckoo_manager.call(
            "setSpeakerOn(_ p0: Bool) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setSpeakerOn(p0)
        )
    }

    public func stopAudioRecord() -> Int {
        return cuckoo_manager.call(
            "stopAudioRecord() -> Int",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopAudioRecord()
        )
    }

    public func isMicrophoneMuted() -> Bool {
        return cuckoo_manager.call(
            "isMicrophoneMuted() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isMicrophoneMuted()
        )
    }

    public func setMicrophoneMuted(_ p0: Bool) -> Int {
        return cuckoo_manager.call(
            "setMicrophoneMuted(_ p0: Bool) -> Int",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setMicrophoneMuted(p0)
        )
    }

    public func setSpeakerMuted(_ p0: Bool) -> Int {
        return cuckoo_manager.call(
            "setSpeakerMuted(_ p0: Bool) -> Int",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setSpeakerMuted(p0)
        )
    }

    public func setPresenter(_ p0: Bool) {
        return cuckoo_manager.call(
            "setPresenter(_ p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setPresenter(p0)
        )
    }

    public func remoteMute() {
        return cuckoo_manager.call(
            "remoteMute()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.remoteMute()
        )
    }

    public func audioLogCallBack(_ p0: loglevel_t, msg p1: String!) {
        return cuckoo_manager.call(
            "audioLogCallBack(_ p0: loglevel_t, msg p1: String!)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.audioLogCallBack(p0, msg: p1)
        )
    }

    public func isBliteNSSelected() -> Bool {
        return cuckoo_manager.call(
            "isBliteNSSelected() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isBliteNSSelected()
        )
    }

    public func setBliteNSSelected(_ p0: Bool) -> Int {
        return cuckoo_manager.call(
            "setBliteNSSelected(_ p0: Bool) -> Int",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setBliteNSSelected(p0)
        )
    }

    public func endOnHold() {
        return cuckoo_manager.call(
            "endOnHold()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.endOnHold()
        )
    }

    public func joinPrimaryMeeting(_ p0: String!, externalUserId p1: String!, joinToken p2: String!) {
        return cuckoo_manager.call(
            "joinPrimaryMeeting(_ p0: String!, externalUserId p1: String!, joinToken p2: String!)",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.joinPrimaryMeeting(p0, externalUserId: p1, joinToken: p2)
        )
    }

    public func leavePrimaryMeeting() {
        return cuckoo_manager.call(
            "leavePrimaryMeeting()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.leavePrimaryMeeting()
        )
    }

    public struct __StubbingProxy_AudioClientProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var delegate: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockAudioClientProtocol,AudioClientDelegate> {
            return .init(manager: cuckoo_manager, name: "delegate")
        }
        
        func startSession<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.Matchable, M6: Cuckoo.Matchable, M7: Cuckoo.Matchable, M8: Cuckoo.OptionalMatchable, M9: Cuckoo.OptionalMatchable, M10: Cuckoo.Matchable, M11: Cuckoo.OptionalMatchable, M12: Cuckoo.Matchable, M13: Cuckoo.Matchable, M14: Cuckoo.Matchable, M15: Cuckoo.Matchable>(_ p0: M1, basePort p1: M2, callId p2: M3, profileId p3: M4, microphoneMute p4: M5, speakerMute p5: M6, isPresenter p6: M7, sessionToken p7: M8, audioWsUrl p8: M9, callKitEnabled p9: M10, appInfo p10: M11, audioMode p11: M12, audioDeviceCapabilities p12: M13, enableAudioRedundancy p13: M14, reconnectTimeoutMs p14: M15) -> Cuckoo.ProtocolStubFunction<(String?, Int, String?, String?, Bool, Bool, Bool, String?, String?, Bool, AppInfo?, AudioModeInternal, AudioDeviceCapabilitiesInternal, Bool, Int), audio_client_status_t> where M1.OptionalMatchedType == String, M2.MatchedType == Int, M3.OptionalMatchedType == String, M4.OptionalMatchedType == String, M5.MatchedType == Bool, M6.MatchedType == Bool, M7.MatchedType == Bool, M8.OptionalMatchedType == String, M9.OptionalMatchedType == String, M10.MatchedType == Bool, M11.OptionalMatchedType == AppInfo, M12.MatchedType == AudioModeInternal, M13.MatchedType == AudioDeviceCapabilitiesInternal, M14.MatchedType == Bool, M15.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(String?, Int, String?, String?, Bool, Bool, Bool, String?, String?, Bool, AppInfo?, AudioModeInternal, AudioDeviceCapabilitiesInternal, Bool, Int)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }, wrap(matchable: p5) { $0.5 }, wrap(matchable: p6) { $0.6 }, wrap(matchable: p7) { $0.7 }, wrap(matchable: p8) { $0.8 }, wrap(matchable: p9) { $0.9 }, wrap(matchable: p10) { $0.10 }, wrap(matchable: p11) { $0.11 }, wrap(matchable: p12) { $0.12 }, wrap(matchable: p13) { $0.13 }, wrap(matchable: p14) { $0.14 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "startSession(_ p0: String!, basePort p1: Int, callId p2: String!, profileId p3: String!, microphoneMute p4: Bool, speakerMute p5: Bool, isPresenter p6: Bool, sessionToken p7: String!, audioWsUrl p8: String!, callKitEnabled p9: Bool, appInfo p10: AppInfo!, audioMode p11: AudioModeInternal, audioDeviceCapabilities p12: AudioDeviceCapabilitiesInternal, enableAudioRedundancy p13: Bool, reconnectTimeoutMs p14: Int) -> audio_client_status_t",
                parameterMatchers: matchers
            ))
        }
        
        func stopSession() -> Cuckoo.ProtocolStubFunction<(), Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "stopSession() -> Int",
                parameterMatchers: matchers
            ))
        }
        
        func isSpeakerOn() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "isSpeakerOn() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func setSpeakerOn<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubFunction<(Bool), Bool> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "setSpeakerOn(_ p0: Bool) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func stopAudioRecord() -> Cuckoo.ProtocolStubFunction<(), Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "stopAudioRecord() -> Int",
                parameterMatchers: matchers
            ))
        }
        
        func isMicrophoneMuted() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "isMicrophoneMuted() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func setMicrophoneMuted<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubFunction<(Bool), Int> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "setMicrophoneMuted(_ p0: Bool) -> Int",
                parameterMatchers: matchers
            ))
        }
        
        func setSpeakerMuted<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubFunction<(Bool), Int> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "setSpeakerMuted(_ p0: Bool) -> Int",
                parameterMatchers: matchers
            ))
        }
        
        func setPresenter<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "setPresenter(_ p0: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func remoteMute() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "remoteMute()",
                parameterMatchers: matchers
            ))
        }
        
        func audioLogCallBack<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(_ p0: M1, msg p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(loglevel_t, String?)> where M1.MatchedType == loglevel_t, M2.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(loglevel_t, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "audioLogCallBack(_ p0: loglevel_t, msg p1: String!)",
                parameterMatchers: matchers
            ))
        }
        
        func isBliteNSSelected() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "isBliteNSSelected() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func setBliteNSSelected<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubFunction<(Bool), Int> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "setBliteNSSelected(_ p0: Bool) -> Int",
                parameterMatchers: matchers
            ))
        }
        
        func endOnHold() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "endOnHold()",
                parameterMatchers: matchers
            ))
        }
        
        func joinPrimaryMeeting<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(_ p0: M1, externalUserId p1: M2, joinToken p2: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(String?, String?, String?)> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "joinPrimaryMeeting(_ p0: String!, externalUserId p1: String!, joinToken p2: String!)",
                parameterMatchers: matchers
            ))
        }
        
        func leavePrimaryMeeting() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioClientProtocol.self,
                method: "leavePrimaryMeeting()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_AudioClientProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var delegate: Cuckoo.VerifyOptionalProperty<AudioClientDelegate> {
            return .init(manager: cuckoo_manager, name: "delegate", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func startSession<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.Matchable, M6: Cuckoo.Matchable, M7: Cuckoo.Matchable, M8: Cuckoo.OptionalMatchable, M9: Cuckoo.OptionalMatchable, M10: Cuckoo.Matchable, M11: Cuckoo.OptionalMatchable, M12: Cuckoo.Matchable, M13: Cuckoo.Matchable, M14: Cuckoo.Matchable, M15: Cuckoo.Matchable>(_ p0: M1, basePort p1: M2, callId p2: M3, profileId p3: M4, microphoneMute p4: M5, speakerMute p5: M6, isPresenter p6: M7, sessionToken p7: M8, audioWsUrl p8: M9, callKitEnabled p9: M10, appInfo p10: M11, audioMode p11: M12, audioDeviceCapabilities p12: M13, enableAudioRedundancy p13: M14, reconnectTimeoutMs p14: M15) -> Cuckoo.__DoNotUse<(String?, Int, String?, String?, Bool, Bool, Bool, String?, String?, Bool, AppInfo?, AudioModeInternal, AudioDeviceCapabilitiesInternal, Bool, Int), audio_client_status_t> where M1.OptionalMatchedType == String, M2.MatchedType == Int, M3.OptionalMatchedType == String, M4.OptionalMatchedType == String, M5.MatchedType == Bool, M6.MatchedType == Bool, M7.MatchedType == Bool, M8.OptionalMatchedType == String, M9.OptionalMatchedType == String, M10.MatchedType == Bool, M11.OptionalMatchedType == AppInfo, M12.MatchedType == AudioModeInternal, M13.MatchedType == AudioDeviceCapabilitiesInternal, M14.MatchedType == Bool, M15.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(String?, Int, String?, String?, Bool, Bool, Bool, String?, String?, Bool, AppInfo?, AudioModeInternal, AudioDeviceCapabilitiesInternal, Bool, Int)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }, wrap(matchable: p5) { $0.5 }, wrap(matchable: p6) { $0.6 }, wrap(matchable: p7) { $0.7 }, wrap(matchable: p8) { $0.8 }, wrap(matchable: p9) { $0.9 }, wrap(matchable: p10) { $0.10 }, wrap(matchable: p11) { $0.11 }, wrap(matchable: p12) { $0.12 }, wrap(matchable: p13) { $0.13 }, wrap(matchable: p14) { $0.14 }]
            return cuckoo_manager.verify(
                "startSession(_ p0: String!, basePort p1: Int, callId p2: String!, profileId p3: String!, microphoneMute p4: Bool, speakerMute p5: Bool, isPresenter p6: Bool, sessionToken p7: String!, audioWsUrl p8: String!, callKitEnabled p9: Bool, appInfo p10: AppInfo!, audioMode p11: AudioModeInternal, audioDeviceCapabilities p12: AudioDeviceCapabilitiesInternal, enableAudioRedundancy p13: Bool, reconnectTimeoutMs p14: Int) -> audio_client_status_t",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopSession() -> Cuckoo.__DoNotUse<(), Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopSession() -> Int",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isSpeakerOn() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "isSpeakerOn() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setSpeakerOn<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(Bool), Bool> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setSpeakerOn(_ p0: Bool) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopAudioRecord() -> Cuckoo.__DoNotUse<(), Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopAudioRecord() -> Int",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isMicrophoneMuted() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "isMicrophoneMuted() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setMicrophoneMuted<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(Bool), Int> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setMicrophoneMuted(_ p0: Bool) -> Int",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setSpeakerMuted<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(Bool), Int> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setSpeakerMuted(_ p0: Bool) -> Int",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setPresenter<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setPresenter(_ p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func remoteMute() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "remoteMute()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func audioLogCallBack<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(_ p0: M1, msg p1: M2) -> Cuckoo.__DoNotUse<(loglevel_t, String?), Void> where M1.MatchedType == loglevel_t, M2.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(loglevel_t, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "audioLogCallBack(_ p0: loglevel_t, msg p1: String!)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isBliteNSSelected() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "isBliteNSSelected() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setBliteNSSelected<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(Bool), Int> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setBliteNSSelected(_ p0: Bool) -> Int",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func endOnHold() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "endOnHold()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func joinPrimaryMeeting<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(_ p0: M1, externalUserId p1: M2, joinToken p2: M3) -> Cuckoo.__DoNotUse<(String?, String?, String?), Void> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "joinPrimaryMeeting(_ p0: String!, externalUserId p1: String!, joinToken p2: String!)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func leavePrimaryMeeting() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "leavePrimaryMeeting()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class AudioClientProtocolStub:AudioClientProtocol, @unchecked Sendable {
    
    public var delegate: AudioClientDelegate! {
        get {
            return DefaultValueRegistry.defaultValue(for: (AudioClientDelegate?).self)
        }
        set {}
    }


    
    public func startSession(_ p0: String!, basePort p1: Int, callId p2: String!, profileId p3: String!, microphoneMute p4: Bool, speakerMute p5: Bool, isPresenter p6: Bool, sessionToken p7: String!, audioWsUrl p8: String!, callKitEnabled p9: Bool, appInfo p10: AppInfo!, audioMode p11: AudioModeInternal, audioDeviceCapabilities p12: AudioDeviceCapabilitiesInternal, enableAudioRedundancy p13: Bool, reconnectTimeoutMs p14: Int) -> audio_client_status_t {
        return DefaultValueRegistry.defaultValue(for: (audio_client_status_t).self)
    }
    
    public func stopSession() -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    public func isSpeakerOn() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func setSpeakerOn(_ p0: Bool) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func stopAudioRecord() -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    public func isMicrophoneMuted() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func setMicrophoneMuted(_ p0: Bool) -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    public func setSpeakerMuted(_ p0: Bool) -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    public func setPresenter(_ p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func remoteMute() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func audioLogCallBack(_ p0: loglevel_t, msg p1: String!) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func isBliteNSSelected() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func setBliteNSSelected(_ p0: Bool) -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    public func endOnHold() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func joinPrimaryMeeting(_ p0: String!, externalUserId p1: String!, joinToken p2: String!) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func leavePrimaryMeeting() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/audio/protocols/AudioLock.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockAudioLock: AudioLock, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AudioLock
    public typealias Stubbing = __StubbingProxy_AudioLock
    public typealias Verification = __VerificationProxy_AudioLock

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AudioLock)?

    public func enableDefaultImplementation(_ stub: any AudioLock) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func lock() {
        return cuckoo_manager.call(
            "lock()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.lock()
        )
    }

    public func unlock() {
        return cuckoo_manager.call(
            "unlock()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unlock()
        )
    }

    public struct __StubbingProxy_AudioLock: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func lock() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioLock.self,
                method: "lock()",
                parameterMatchers: matchers
            ))
        }
        
        func unlock() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAudioLock.self,
                method: "unlock()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_AudioLock: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func lock() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "lock()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unlock() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "unlock()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class AudioLockStub:AudioLock, @unchecked Sendable {


    
    public func lock() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unlock() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/audio/protocols/AudioSession.swift'

import Cuckoo
import AVFoundation
import Foundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockAudioSession: AudioSession, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AudioSession
    public typealias Stubbing = __StubbingProxy_AudioSession
    public typealias Verification = __VerificationProxy_AudioSession

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AudioSession)?

    public func enableDefaultImplementation(_ stub: any AudioSession) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var recordPermission: AVAudioSession.RecordPermission {
        get {
            return cuckoo_manager.getter(
                "recordPermission",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.recordPermission
            )
        }
    }

    public var availableInputs: [AVAudioSessionPortDescription]? {
        get {
            return cuckoo_manager.getter(
                "availableInputs",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.availableInputs
            )
        }
    }

    public var currentRoute: AVAudioSessionRouteDescription {
        get {
            return cuckoo_manager.getter(
                "currentRoute",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.currentRoute
            )
        }
    }


    public func setPreferredInput(_ p0: AVAudioSessionPortDescription?) throws {
        return try cuckoo_manager.callThrows(
            "setPreferredInput(_ p0: AVAudioSessionPortDescription?) throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setPreferredInput(p0)
        )
    }

    public func overrideOutputAudioPort(_ p0: AVAudioSession.PortOverride) throws {
        return try cuckoo_manager.callThrows(
            "overrideOutputAudioPort(_ p0: AVAudioSession.PortOverride) throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.overrideOutputAudioPort(p0)
        )
    }

    public struct __StubbingProxy_AudioSession: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var recordPermission: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAudioSession,AVAudioSession.RecordPermission> {
            return .init(manager: cuckoo_manager, name: "recordPermission")
        }
        
        var availableInputs: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAudioSession,[AVAudioSessionPortDescription]?> {
            return .init(manager: cuckoo_manager, name: "availableInputs")
        }
        
        var currentRoute: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAudioSession,AVAudioSessionRouteDescription> {
            return .init(manager: cuckoo_manager, name: "currentRoute")
        }
        
        func setPreferredInput<M1: Cuckoo.OptionalMatchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(AVAudioSessionPortDescription?),Swift.Error> where M1.OptionalMatchedType == AVAudioSessionPortDescription {
            let matchers: [Cuckoo.ParameterMatcher<(AVAudioSessionPortDescription?)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioSession.self,
                method: "setPreferredInput(_ p0: AVAudioSessionPortDescription?) throws",
                parameterMatchers: matchers
            ))
        }
        
        func overrideOutputAudioPort<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(AVAudioSession.PortOverride),Swift.Error> where M1.MatchedType == AVAudioSession.PortOverride {
            let matchers: [Cuckoo.ParameterMatcher<(AVAudioSession.PortOverride)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAudioSession.self,
                method: "overrideOutputAudioPort(_ p0: AVAudioSession.PortOverride) throws",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_AudioSession: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var recordPermission: Cuckoo.VerifyReadOnlyProperty<AVAudioSession.RecordPermission> {
            return .init(manager: cuckoo_manager, name: "recordPermission", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var availableInputs: Cuckoo.VerifyReadOnlyProperty<[AVAudioSessionPortDescription]?> {
            return .init(manager: cuckoo_manager, name: "availableInputs", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var currentRoute: Cuckoo.VerifyReadOnlyProperty<AVAudioSessionRouteDescription> {
            return .init(manager: cuckoo_manager, name: "currentRoute", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func setPreferredInput<M1: Cuckoo.OptionalMatchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(AVAudioSessionPortDescription?), Void> where M1.OptionalMatchedType == AVAudioSessionPortDescription {
            let matchers: [Cuckoo.ParameterMatcher<(AVAudioSessionPortDescription?)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setPreferredInput(_ p0: AVAudioSessionPortDescription?) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func overrideOutputAudioPort<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(AVAudioSession.PortOverride), Void> where M1.MatchedType == AVAudioSession.PortOverride {
            let matchers: [Cuckoo.ParameterMatcher<(AVAudioSession.PortOverride)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "overrideOutputAudioPort(_ p0: AVAudioSession.PortOverride) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class AudioSessionStub:AudioSession, @unchecked Sendable {
    
    public var recordPermission: AVAudioSession.RecordPermission {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVAudioSession.RecordPermission).self)
        }
    }
    
    public var availableInputs: [AVAudioSessionPortDescription]? {
        get {
            return DefaultValueRegistry.defaultValue(for: ([AVAudioSessionPortDescription]?).self)
        }
    }
    
    public var currentRoute: AVAudioSessionRouteDescription {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVAudioSessionRouteDescription).self)
        }
    }


    
    public func setPreferredInput(_ p0: AVAudioSessionPortDescription?) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func overrideOutputAudioPort(_ p0: AVAudioSession.PortOverride) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/contentshare/ContentShareVideoClientController.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockContentShareVideoClientController: ContentShareVideoClientController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ContentShareVideoClientController
    public typealias Stubbing = __StubbingProxy_ContentShareVideoClientController
    public typealias Verification = __VerificationProxy_ContentShareVideoClientController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ContentShareVideoClientController)?

    public func enableDefaultImplementation(_ stub: any ContentShareVideoClientController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func startVideoShare(source p0: VideoSource) {
        return cuckoo_manager.call(
            "startVideoShare(source p0: VideoSource)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startVideoShare(source: p0)
        )
    }

    public func startVideoShare(source p0: VideoSource, config p1: LocalVideoConfiguration) {
        return cuckoo_manager.call(
            "startVideoShare(source p0: VideoSource, config p1: LocalVideoConfiguration)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startVideoShare(source: p0, config: p1)
        )
    }

    public func stopVideoShare() {
        return cuckoo_manager.call(
            "stopVideoShare()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopVideoShare()
        )
    }

    public func subscribeToVideoClientStateChange(observer p0: ContentShareObserver) {
        return cuckoo_manager.call(
            "subscribeToVideoClientStateChange(observer p0: ContentShareObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.subscribeToVideoClientStateChange(observer: p0)
        )
    }

    public func unsubscribeFromVideoClientStateChange(observer p0: ContentShareObserver) {
        return cuckoo_manager.call(
            "unsubscribeFromVideoClientStateChange(observer p0: ContentShareObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unsubscribeFromVideoClientStateChange(observer: p0)
        )
    }

    public struct __StubbingProxy_ContentShareVideoClientController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func startVideoShare<M1: Cuckoo.Matchable>(source p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSource)> where M1.MatchedType == VideoSource {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareVideoClientController.self,
                method: "startVideoShare(source p0: VideoSource)",
                parameterMatchers: matchers
            ))
        }
        
        func startVideoShare<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(source p0: M1, config p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSource, LocalVideoConfiguration)> where M1.MatchedType == VideoSource, M2.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource, LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareVideoClientController.self,
                method: "startVideoShare(source p0: VideoSource, config p1: LocalVideoConfiguration)",
                parameterMatchers: matchers
            ))
        }
        
        func stopVideoShare() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareVideoClientController.self,
                method: "stopVideoShare()",
                parameterMatchers: matchers
            ))
        }
        
        func subscribeToVideoClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(ContentShareObserver)> where M1.MatchedType == ContentShareObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareVideoClientController.self,
                method: "subscribeToVideoClientStateChange(observer p0: ContentShareObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func unsubscribeFromVideoClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(ContentShareObserver)> where M1.MatchedType == ContentShareObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockContentShareVideoClientController.self,
                method: "unsubscribeFromVideoClientStateChange(observer p0: ContentShareObserver)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_ContentShareVideoClientController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func startVideoShare<M1: Cuckoo.Matchable>(source p0: M1) -> Cuckoo.__DoNotUse<(VideoSource), Void> where M1.MatchedType == VideoSource {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startVideoShare(source p0: VideoSource)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startVideoShare<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(source p0: M1, config p1: M2) -> Cuckoo.__DoNotUse<(VideoSource, LocalVideoConfiguration), Void> where M1.MatchedType == VideoSource, M2.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource, LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "startVideoShare(source p0: VideoSource, config p1: LocalVideoConfiguration)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopVideoShare() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopVideoShare()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func subscribeToVideoClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(ContentShareObserver), Void> where M1.MatchedType == ContentShareObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "subscribeToVideoClientStateChange(observer p0: ContentShareObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unsubscribeFromVideoClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(ContentShareObserver), Void> where M1.MatchedType == ContentShareObserver {
            let matchers: [Cuckoo.ParameterMatcher<(ContentShareObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "unsubscribeFromVideoClientStateChange(observer p0: ContentShareObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class ContentShareVideoClientControllerStub:ContentShareVideoClientController, @unchecked Sendable {


    
    public func startVideoShare(source p0: VideoSource) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startVideoShare(source p0: VideoSource, config p1: LocalVideoConfiguration) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopVideoShare() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func subscribeToVideoClientStateChange(observer p0: ContentShareObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unsubscribeFromVideoClientStateChange(observer p0: ContentShareObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/ingestion/DirtyEventDao.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

class MockDirtyEventDao: DirtyEventDao, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any DirtyEventDao
    typealias Stubbing = __StubbingProxy_DirtyEventDao
    typealias Verification = __VerificationProxy_DirtyEventDao

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any DirtyEventDao)?

    func enableDefaultImplementation(_ stub: any DirtyEventDao) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    func queryDirtyMeetingEventItems(size p0: Int) -> [DirtyMeetingEventItem] {
        return cuckoo_manager.call(
            "queryDirtyMeetingEventItems(size p0: Int) -> [DirtyMeetingEventItem]",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.queryDirtyMeetingEventItems(size: p0)
        )
    }

    func deleteDirtyMeetingEventsByIds(ids p0: [String]) -> Bool {
        return cuckoo_manager.call(
            "deleteDirtyMeetingEventsByIds(ids p0: [String]) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.deleteDirtyMeetingEventsByIds(ids: p0)
        )
    }

    func insertDirtyMeetingEventItems(dirtyEvents p0: [DirtyMeetingEventItem]) -> Bool {
        return cuckoo_manager.call(
            "insertDirtyMeetingEventItems(dirtyEvents p0: [DirtyMeetingEventItem]) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.insertDirtyMeetingEventItems(dirtyEvents: p0)
        )
    }

    struct __StubbingProxy_DirtyEventDao: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func queryDirtyMeetingEventItems<M1: Cuckoo.Matchable>(size p0: M1) -> Cuckoo.ProtocolStubFunction<(Int), [DirtyMeetingEventItem]> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDirtyEventDao.self,
                method: "queryDirtyMeetingEventItems(size p0: Int) -> [DirtyMeetingEventItem]",
                parameterMatchers: matchers
            ))
        }
        
        func deleteDirtyMeetingEventsByIds<M1: Cuckoo.Matchable>(ids p0: M1) -> Cuckoo.ProtocolStubFunction<([String]), Bool> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDirtyEventDao.self,
                method: "deleteDirtyMeetingEventsByIds(ids p0: [String]) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func insertDirtyMeetingEventItems<M1: Cuckoo.Matchable>(dirtyEvents p0: M1) -> Cuckoo.ProtocolStubFunction<([DirtyMeetingEventItem]), Bool> where M1.MatchedType == [DirtyMeetingEventItem] {
            let matchers: [Cuckoo.ParameterMatcher<([DirtyMeetingEventItem])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDirtyEventDao.self,
                method: "insertDirtyMeetingEventItems(dirtyEvents p0: [DirtyMeetingEventItem]) -> Bool",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_DirtyEventDao: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func queryDirtyMeetingEventItems<M1: Cuckoo.Matchable>(size p0: M1) -> Cuckoo.__DoNotUse<(Int), [DirtyMeetingEventItem]> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "queryDirtyMeetingEventItems(size p0: Int) -> [DirtyMeetingEventItem]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func deleteDirtyMeetingEventsByIds<M1: Cuckoo.Matchable>(ids p0: M1) -> Cuckoo.__DoNotUse<([String]), Bool> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "deleteDirtyMeetingEventsByIds(ids p0: [String]) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func insertDirtyMeetingEventItems<M1: Cuckoo.Matchable>(dirtyEvents p0: M1) -> Cuckoo.__DoNotUse<([DirtyMeetingEventItem]), Bool> where M1.MatchedType == [DirtyMeetingEventItem] {
            let matchers: [Cuckoo.ParameterMatcher<([DirtyMeetingEventItem])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "insertDirtyMeetingEventItems(dirtyEvents p0: [DirtyMeetingEventItem]) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class DirtyEventDaoStub:DirtyEventDao, @unchecked Sendable {


    
    func queryDirtyMeetingEventItems(size p0: Int) -> [DirtyMeetingEventItem] {
        return DefaultValueRegistry.defaultValue(for: ([DirtyMeetingEventItem]).self)
    }
    
    func deleteDirtyMeetingEventsByIds(ids p0: [String]) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    func insertDirtyMeetingEventItems(dirtyEvents p0: [DirtyMeetingEventItem]) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/ingestion/EventDao.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

class MockEventDao: EventDao, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any EventDao
    typealias Stubbing = __StubbingProxy_EventDao
    typealias Verification = __VerificationProxy_EventDao

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any EventDao)?

    func enableDefaultImplementation(_ stub: any EventDao) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    func queryMeetingEventItems(size p0: Int) -> [MeetingEventItem] {
        return cuckoo_manager.call(
            "queryMeetingEventItems(size p0: Int) -> [MeetingEventItem]",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.queryMeetingEventItems(size: p0)
        )
    }

    func insertMeetingEvent(event p0: MeetingEventItem) -> Bool {
        return cuckoo_manager.call(
            "insertMeetingEvent(event p0: MeetingEventItem) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.insertMeetingEvent(event: p0)
        )
    }

    func deleteMeetingEventsByIds(ids p0: [String]) -> Bool {
        return cuckoo_manager.call(
            "deleteMeetingEventsByIds(ids p0: [String]) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.deleteMeetingEventsByIds(ids: p0)
        )
    }

    struct __StubbingProxy_EventDao: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func queryMeetingEventItems<M1: Cuckoo.Matchable>(size p0: M1) -> Cuckoo.ProtocolStubFunction<(Int), [MeetingEventItem]> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventDao.self,
                method: "queryMeetingEventItems(size p0: Int) -> [MeetingEventItem]",
                parameterMatchers: matchers
            ))
        }
        
        func insertMeetingEvent<M1: Cuckoo.Matchable>(event p0: M1) -> Cuckoo.ProtocolStubFunction<(MeetingEventItem), Bool> where M1.MatchedType == MeetingEventItem {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingEventItem)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventDao.self,
                method: "insertMeetingEvent(event p0: MeetingEventItem) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func deleteMeetingEventsByIds<M1: Cuckoo.Matchable>(ids p0: M1) -> Cuckoo.ProtocolStubFunction<([String]), Bool> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEventDao.self,
                method: "deleteMeetingEventsByIds(ids p0: [String]) -> Bool",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_EventDao: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func queryMeetingEventItems<M1: Cuckoo.Matchable>(size p0: M1) -> Cuckoo.__DoNotUse<(Int), [MeetingEventItem]> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "queryMeetingEventItems(size p0: Int) -> [MeetingEventItem]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func insertMeetingEvent<M1: Cuckoo.Matchable>(event p0: M1) -> Cuckoo.__DoNotUse<(MeetingEventItem), Bool> where M1.MatchedType == MeetingEventItem {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingEventItem)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "insertMeetingEvent(event p0: MeetingEventItem) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func deleteMeetingEventsByIds<M1: Cuckoo.Matchable>(ids p0: M1) -> Cuckoo.__DoNotUse<([String]), Bool> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "deleteMeetingEventsByIds(ids p0: [String]) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class EventDaoStub:EventDao, @unchecked Sendable {


    
    func queryMeetingEventItems(size p0: Int) -> [MeetingEventItem] {
        return DefaultValueRegistry.defaultValue(for: ([MeetingEventItem]).self)
    }
    
    func insertMeetingEvent(event p0: MeetingEventItem) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    func deleteMeetingEventsByIds(ids p0: [String]) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/ingestion/database/DatabaseClient.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

class MockDatabaseClient: DatabaseClient, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any DatabaseClient
    typealias Stubbing = __StubbingProxy_DatabaseClient
    typealias Verification = __VerificationProxy_DatabaseClient

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any DatabaseClient)?

    func enableDefaultImplementation(_ stub: any DatabaseClient) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    func close() -> Bool {
        return cuckoo_manager.call(
            "close() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.close()
        )
    }

    func query(statement p0: String, params p1: [Any?]?) -> [[String: Any?]] {
        return cuckoo_manager.call(
            "query(statement p0: String, params p1: [Any?]?) -> [[String: Any?]]",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.query(statement: p0, params: p1)
        )
    }

    func write(statement p0: String, params p1: [Any?]?) -> Bool {
        return cuckoo_manager.call(
            "write(statement p0: String, params p1: [Any?]?) -> Bool",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.write(statement: p0, params: p1)
        )
    }

    struct __StubbingProxy_DatabaseClient: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func close() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDatabaseClient.self,
                method: "close() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func query<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(statement p0: M1, params p1: M2) -> Cuckoo.ProtocolStubFunction<(String, [Any?]?), [[String: Any?]]> where M1.MatchedType == String, M2.OptionalMatchedType == [Any?] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [Any?]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDatabaseClient.self,
                method: "query(statement p0: String, params p1: [Any?]?) -> [[String: Any?]]",
                parameterMatchers: matchers
            ))
        }
        
        func write<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(statement p0: M1, params p1: M2) -> Cuckoo.ProtocolStubFunction<(String, [Any?]?), Bool> where M1.MatchedType == String, M2.OptionalMatchedType == [Any?] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [Any?]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDatabaseClient.self,
                method: "write(statement p0: String, params p1: [Any?]?) -> Bool",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_DatabaseClient: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "close() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func query<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(statement p0: M1, params p1: M2) -> Cuckoo.__DoNotUse<(String, [Any?]?), [[String: Any?]]> where M1.MatchedType == String, M2.OptionalMatchedType == [Any?] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [Any?]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "query(statement p0: String, params p1: [Any?]?) -> [[String: Any?]]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func write<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(statement p0: M1, params p1: M2) -> Cuckoo.__DoNotUse<(String, [Any?]?), Bool> where M1.MatchedType == String, M2.OptionalMatchedType == [Any?] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [Any?]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "write(statement p0: String, params p1: [Any?]?) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class DatabaseClientStub:DatabaseClient, @unchecked Sendable {


    
    func close() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    func query(statement p0: String, params p1: [Any?]?) -> [[String: Any?]] {
        return DefaultValueRegistry.defaultValue(for: ([[String: Any?]]).self)
    }
    
    func write(statement p0: String, params p1: [Any?]?) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/ingestion/database/DatabaseManager.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

class MockDatabaseManager: DatabaseManager, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any DatabaseManager
    typealias Stubbing = __StubbingProxy_DatabaseManager
    typealias Verification = __VerificationProxy_DatabaseManager

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any DatabaseManager)?

    func enableDefaultImplementation(_ stub: any DatabaseManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    func query(tableName p0: String, size p1: Int) -> [[String: Any?]] {
        return cuckoo_manager.call(
            "query(tableName p0: String, size p1: Int) -> [[String: Any?]]",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.query(tableName: p0, size: p1)
        )
    }

    func insert(tableName p0: String, contentValue p1: [String: Any]) -> Bool {
        return cuckoo_manager.call(
            "insert(tableName p0: String, contentValue p1: [String: Any]) -> Bool",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.insert(tableName: p0, contentValue: p1)
        )
    }

    func insertMultiples(tableName p0: String, contentValues p1: [[String: Any]]) -> Bool {
        return cuckoo_manager.call(
            "insertMultiples(tableName p0: String, contentValues p1: [[String: Any]]) -> Bool",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.insertMultiples(tableName: p0, contentValues: p1)
        )
    }

    func delete(tableName p0: String, ids p1: [String]) -> Bool {
        return cuckoo_manager.call(
            "delete(tableName p0: String, ids p1: [String]) -> Bool",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.delete(tableName: p0, ids: p1)
        )
    }

    func execute(statement p0: String) {
        return cuckoo_manager.call(
            "execute(statement p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.execute(statement: p0)
        )
    }

    func clear(tableName p0: String) {
        return cuckoo_manager.call(
            "clear(tableName p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.clear(tableName: p0)
        )
    }

    struct __StubbingProxy_DatabaseManager: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func query<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tableName p0: M1, size p1: M2) -> Cuckoo.ProtocolStubFunction<(String, Int), [[String: Any?]]> where M1.MatchedType == String, M2.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(String, Int)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDatabaseManager.self,
                method: "query(tableName p0: String, size p1: Int) -> [[String: Any?]]",
                parameterMatchers: matchers
            ))
        }
        
        func insert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tableName p0: M1, contentValue p1: M2) -> Cuckoo.ProtocolStubFunction<(String, [String: Any]), Bool> where M1.MatchedType == String, M2.MatchedType == [String: Any] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: Any])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDatabaseManager.self,
                method: "insert(tableName p0: String, contentValue p1: [String: Any]) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func insertMultiples<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tableName p0: M1, contentValues p1: M2) -> Cuckoo.ProtocolStubFunction<(String, [[String: Any]]), Bool> where M1.MatchedType == String, M2.MatchedType == [[String: Any]] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [[String: Any]])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDatabaseManager.self,
                method: "insertMultiples(tableName p0: String, contentValues p1: [[String: Any]]) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func delete<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tableName p0: M1, ids p1: M2) -> Cuckoo.ProtocolStubFunction<(String, [String]), Bool> where M1.MatchedType == String, M2.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDatabaseManager.self,
                method: "delete(tableName p0: String, ids p1: [String]) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func execute<M1: Cuckoo.Matchable>(statement p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDatabaseManager.self,
                method: "execute(statement p0: String)",
                parameterMatchers: matchers
            ))
        }
        
        func clear<M1: Cuckoo.Matchable>(tableName p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDatabaseManager.self,
                method: "clear(tableName p0: String)",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_DatabaseManager: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func query<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tableName p0: M1, size p1: M2) -> Cuckoo.__DoNotUse<(String, Int), [[String: Any?]]> where M1.MatchedType == String, M2.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(String, Int)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "query(tableName p0: String, size p1: Int) -> [[String: Any?]]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func insert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tableName p0: M1, contentValue p1: M2) -> Cuckoo.__DoNotUse<(String, [String: Any]), Bool> where M1.MatchedType == String, M2.MatchedType == [String: Any] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: Any])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "insert(tableName p0: String, contentValue p1: [String: Any]) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func insertMultiples<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tableName p0: M1, contentValues p1: M2) -> Cuckoo.__DoNotUse<(String, [[String: Any]]), Bool> where M1.MatchedType == String, M2.MatchedType == [[String: Any]] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [[String: Any]])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "insertMultiples(tableName p0: String, contentValues p1: [[String: Any]]) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func delete<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tableName p0: M1, ids p1: M2) -> Cuckoo.__DoNotUse<(String, [String]), Bool> where M1.MatchedType == String, M2.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "delete(tableName p0: String, ids p1: [String]) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func execute<M1: Cuckoo.Matchable>(statement p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "execute(statement p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func clear<M1: Cuckoo.Matchable>(tableName p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "clear(tableName p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class DatabaseManagerStub:DatabaseManager, @unchecked Sendable {


    
    func query(tableName p0: String, size p1: Int) -> [[String: Any?]] {
        return DefaultValueRegistry.defaultValue(for: ([[String: Any?]]).self)
    }
    
    func insert(tableName p0: String, contentValue p1: [String: Any]) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    func insertMultiples(tableName p0: String, contentValues p1: [[String: Any]]) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    func delete(tableName p0: String, ids p1: [String]) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    func execute(statement p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func clear(tableName p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/metric/ClientMetricsCollector.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockClientMetricsCollector: ClientMetricsCollector, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ClientMetricsCollector
    public typealias Stubbing = __StubbingProxy_ClientMetricsCollector
    public typealias Verification = __VerificationProxy_ClientMetricsCollector

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ClientMetricsCollector)?

    public func enableDefaultImplementation(_ stub: any ClientMetricsCollector) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func processAudioClientMetrics(metrics p0: [AnyHashable: Any]) {
        return cuckoo_manager.call(
            "processAudioClientMetrics(metrics p0: [AnyHashable: Any])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.processAudioClientMetrics(metrics: p0)
        )
    }

    public func processVideoClientMetrics(metrics p0: [AnyHashable: Any]) {
        return cuckoo_manager.call(
            "processVideoClientMetrics(metrics p0: [AnyHashable: Any])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.processVideoClientMetrics(metrics: p0)
        )
    }

    public func processContentShareVideoClientMetrics(metrics p0: [AnyHashable: Any]) {
        return cuckoo_manager.call(
            "processContentShareVideoClientMetrics(metrics p0: [AnyHashable: Any])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.processContentShareVideoClientMetrics(metrics: p0)
        )
    }

    public func subscribeToMetrics(observer p0: MetricsObserver) {
        return cuckoo_manager.call(
            "subscribeToMetrics(observer p0: MetricsObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.subscribeToMetrics(observer: p0)
        )
    }

    public func unsubscribeFromMetrics(observer p0: MetricsObserver) {
        return cuckoo_manager.call(
            "unsubscribeFromMetrics(observer p0: MetricsObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unsubscribeFromMetrics(observer: p0)
        )
    }

    public struct __StubbingProxy_ClientMetricsCollector: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func processAudioClientMetrics<M1: Cuckoo.Matchable>(metrics p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([AnyHashable: Any])> where M1.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<([AnyHashable: Any])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClientMetricsCollector.self,
                method: "processAudioClientMetrics(metrics p0: [AnyHashable: Any])",
                parameterMatchers: matchers
            ))
        }
        
        func processVideoClientMetrics<M1: Cuckoo.Matchable>(metrics p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([AnyHashable: Any])> where M1.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<([AnyHashable: Any])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClientMetricsCollector.self,
                method: "processVideoClientMetrics(metrics p0: [AnyHashable: Any])",
                parameterMatchers: matchers
            ))
        }
        
        func processContentShareVideoClientMetrics<M1: Cuckoo.Matchable>(metrics p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([AnyHashable: Any])> where M1.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<([AnyHashable: Any])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClientMetricsCollector.self,
                method: "processContentShareVideoClientMetrics(metrics p0: [AnyHashable: Any])",
                parameterMatchers: matchers
            ))
        }
        
        func subscribeToMetrics<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MetricsObserver)> where M1.MatchedType == MetricsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MetricsObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClientMetricsCollector.self,
                method: "subscribeToMetrics(observer p0: MetricsObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func unsubscribeFromMetrics<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MetricsObserver)> where M1.MatchedType == MetricsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MetricsObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClientMetricsCollector.self,
                method: "unsubscribeFromMetrics(observer p0: MetricsObserver)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_ClientMetricsCollector: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func processAudioClientMetrics<M1: Cuckoo.Matchable>(metrics p0: M1) -> Cuckoo.__DoNotUse<([AnyHashable: Any]), Void> where M1.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<([AnyHashable: Any])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "processAudioClientMetrics(metrics p0: [AnyHashable: Any])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func processVideoClientMetrics<M1: Cuckoo.Matchable>(metrics p0: M1) -> Cuckoo.__DoNotUse<([AnyHashable: Any]), Void> where M1.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<([AnyHashable: Any])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "processVideoClientMetrics(metrics p0: [AnyHashable: Any])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func processContentShareVideoClientMetrics<M1: Cuckoo.Matchable>(metrics p0: M1) -> Cuckoo.__DoNotUse<([AnyHashable: Any]), Void> where M1.MatchedType == [AnyHashable: Any] {
            let matchers: [Cuckoo.ParameterMatcher<([AnyHashable: Any])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "processContentShareVideoClientMetrics(metrics p0: [AnyHashable: Any])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func subscribeToMetrics<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(MetricsObserver), Void> where M1.MatchedType == MetricsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MetricsObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "subscribeToMetrics(observer p0: MetricsObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unsubscribeFromMetrics<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(MetricsObserver), Void> where M1.MatchedType == MetricsObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MetricsObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "unsubscribeFromMetrics(observer p0: MetricsObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class ClientMetricsCollectorStub:ClientMetricsCollector, @unchecked Sendable {


    
    public func processAudioClientMetrics(metrics p0: [AnyHashable: Any]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func processVideoClientMetrics(metrics p0: [AnyHashable: Any]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func processContentShareVideoClientMetrics(metrics p0: [AnyHashable: Any]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func subscribeToMetrics(observer p0: MetricsObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unsubscribeFromMetrics(observer p0: MetricsObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/video/VideoClientController.swift'

import Cuckoo
import AmazonChimeSDKMedia
import Foundation
import AVFoundation
import UIKit
@testable import AmazonChimeSDK

public class MockVideoClientController: VideoClientController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any VideoClientController
    public typealias Stubbing = __StubbingProxy_VideoClientController
    public typealias Verification = __VerificationProxy_VideoClientController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any VideoClientController)?

    public func enableDefaultImplementation(_ stub: any VideoClientController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func start() {
        return cuckoo_manager.call(
            "start()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start()
        )
    }

    public func stopAndDestroy() {
        return cuckoo_manager.call(
            "stopAndDestroy()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopAndDestroy()
        )
    }

    public func startLocalVideo() throws {
        return try cuckoo_manager.callThrows(
            "startLocalVideo() throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startLocalVideo()
        )
    }

    public func startLocalVideo(config p0: LocalVideoConfiguration) throws {
        return try cuckoo_manager.callThrows(
            "startLocalVideo(config p0: LocalVideoConfiguration) throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startLocalVideo(config: p0)
        )
    }

    public func startLocalVideo(source p0: VideoSource) {
        return cuckoo_manager.call(
            "startLocalVideo(source p0: VideoSource)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startLocalVideo(source: p0)
        )
    }

    public func startLocalVideo(source p0: VideoSource, config p1: LocalVideoConfiguration) {
        return cuckoo_manager.call(
            "startLocalVideo(source p0: VideoSource, config p1: LocalVideoConfiguration)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startLocalVideo(source: p0, config: p1)
        )
    }

    public func stopLocalVideo() {
        return cuckoo_manager.call(
            "stopLocalVideo()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopLocalVideo()
        )
    }

    public func startRemoteVideo() {
        return cuckoo_manager.call(
            "startRemoteVideo()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startRemoteVideo()
        )
    }

    public func stopRemoteVideo() {
        return cuckoo_manager.call(
            "stopRemoteVideo()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopRemoteVideo()
        )
    }

    public func switchCamera() {
        return cuckoo_manager.call(
            "switchCamera()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.switchCamera()
        )
    }

    public func getCurrentDevice() -> MediaDevice? {
        return cuckoo_manager.call(
            "getCurrentDevice() -> MediaDevice?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getCurrentDevice()
        )
    }

    public func getConfiguration() -> MeetingSessionConfiguration {
        return cuckoo_manager.call(
            "getConfiguration() -> MeetingSessionConfiguration",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getConfiguration()
        )
    }

    public func subscribeToVideoClientStateChange(observer p0: AudioVideoObserver) {
        return cuckoo_manager.call(
            "subscribeToVideoClientStateChange(observer p0: AudioVideoObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.subscribeToVideoClientStateChange(observer: p0)
        )
    }

    public func unsubscribeFromVideoClientStateChange(observer p0: AudioVideoObserver) {
        return cuckoo_manager.call(
            "unsubscribeFromVideoClientStateChange(observer p0: AudioVideoObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unsubscribeFromVideoClientStateChange(observer: p0)
        )
    }

    public func subscribeToVideoTileControllerObservers(observer p0: VideoTileController) {
        return cuckoo_manager.call(
            "subscribeToVideoTileControllerObservers(observer p0: VideoTileController)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.subscribeToVideoTileControllerObservers(observer: p0)
        )
    }

    public func unsubscribeFromVideoTileControllerObservers(observer p0: VideoTileController) {
        return cuckoo_manager.call(
            "unsubscribeFromVideoTileControllerObservers(observer p0: VideoTileController)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unsubscribeFromVideoTileControllerObservers(observer: p0)
        )
    }

    public func pauseResumeRemoteVideo(_ p0: UInt32, pause p1: Bool) {
        return cuckoo_manager.call(
            "pauseResumeRemoteVideo(_ p0: UInt32, pause p1: Bool)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.pauseResumeRemoteVideo(p0, pause: p1)
        )
    }

    public func subscribeToReceiveDataMessage(topic p0: String, observer p1: DataMessageObserver) {
        return cuckoo_manager.call(
            "subscribeToReceiveDataMessage(topic p0: String, observer p1: DataMessageObserver)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.subscribeToReceiveDataMessage(topic: p0, observer: p1)
        )
    }

    public func unsubscribeFromReceiveDataMessageFromTopic(topic p0: String) {
        return cuckoo_manager.call(
            "unsubscribeFromReceiveDataMessageFromTopic(topic p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unsubscribeFromReceiveDataMessageFromTopic(topic: p0)
        )
    }

    public func sendDataMessage(topic p0: String, data p1: Any, lifetimeMs p2: Int32) throws {
        return try cuckoo_manager.callThrows(
            "sendDataMessage(topic p0: String, data p1: Any, lifetimeMs p2: Int32) throws",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.sendDataMessage(topic: p0, data: p1, lifetimeMs: p2)
        )
    }

    public func updateVideoSourceSubscriptions(addedOrUpdated p0: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed p1: Array<RemoteVideoSource>) {
        return cuckoo_manager.call(
            "updateVideoSourceSubscriptions(addedOrUpdated p0: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed p1: Array<RemoteVideoSource>)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.updateVideoSourceSubscriptions(addedOrUpdated: p0, removed: p1)
        )
    }

    public func promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver) {
        return cuckoo_manager.call(
            "promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.promoteToPrimaryMeeting(credentials: p0, observer: p1)
        )
    }

    public func demoteFromPrimaryMeeting() {
        return cuckoo_manager.call(
            "demoteFromPrimaryMeeting()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.demoteFromPrimaryMeeting()
        )
    }

    public struct __StubbingProxy_VideoClientController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func start() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "start()",
                parameterMatchers: matchers
            ))
        }
        
        func stopAndDestroy() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "stopAndDestroy()",
                parameterMatchers: matchers
            ))
        }
        
        func startLocalVideo() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "startLocalVideo() throws",
                parameterMatchers: matchers
            ))
        }
        
        func startLocalVideo<M1: Cuckoo.Matchable>(config p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(LocalVideoConfiguration),Swift.Error> where M1.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "startLocalVideo(config p0: LocalVideoConfiguration) throws",
                parameterMatchers: matchers
            ))
        }
        
        func startLocalVideo<M1: Cuckoo.Matchable>(source p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSource)> where M1.MatchedType == VideoSource {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "startLocalVideo(source p0: VideoSource)",
                parameterMatchers: matchers
            ))
        }
        
        func startLocalVideo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(source p0: M1, config p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSource, LocalVideoConfiguration)> where M1.MatchedType == VideoSource, M2.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource, LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "startLocalVideo(source p0: VideoSource, config p1: LocalVideoConfiguration)",
                parameterMatchers: matchers
            ))
        }
        
        func stopLocalVideo() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "stopLocalVideo()",
                parameterMatchers: matchers
            ))
        }
        
        func startRemoteVideo() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "startRemoteVideo()",
                parameterMatchers: matchers
            ))
        }
        
        func stopRemoteVideo() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "stopRemoteVideo()",
                parameterMatchers: matchers
            ))
        }
        
        func switchCamera() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "switchCamera()",
                parameterMatchers: matchers
            ))
        }
        
        func getCurrentDevice() -> Cuckoo.ProtocolStubFunction<(), MediaDevice?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "getCurrentDevice() -> MediaDevice?",
                parameterMatchers: matchers
            ))
        }
        
        func getConfiguration() -> Cuckoo.ProtocolStubFunction<(), MeetingSessionConfiguration> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "getConfiguration() -> MeetingSessionConfiguration",
                parameterMatchers: matchers
            ))
        }
        
        func subscribeToVideoClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AudioVideoObserver)> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "subscribeToVideoClientStateChange(observer p0: AudioVideoObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func unsubscribeFromVideoClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AudioVideoObserver)> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "unsubscribeFromVideoClientStateChange(observer p0: AudioVideoObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func subscribeToVideoTileControllerObservers<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoTileController)> where M1.MatchedType == VideoTileController {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileController)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "subscribeToVideoTileControllerObservers(observer p0: VideoTileController)",
                parameterMatchers: matchers
            ))
        }
        
        func unsubscribeFromVideoTileControllerObservers<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoTileController)> where M1.MatchedType == VideoTileController {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileController)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "unsubscribeFromVideoTileControllerObservers(observer p0: VideoTileController)",
                parameterMatchers: matchers
            ))
        }
        
        func pauseResumeRemoteVideo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ p0: M1, pause p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(UInt32, Bool)> where M1.MatchedType == UInt32, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(UInt32, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "pauseResumeRemoteVideo(_ p0: UInt32, pause p1: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func subscribeToReceiveDataMessage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(topic p0: M1, observer p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, DataMessageObserver)> where M1.MatchedType == String, M2.MatchedType == DataMessageObserver {
            let matchers: [Cuckoo.ParameterMatcher<(String, DataMessageObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "subscribeToReceiveDataMessage(topic p0: String, observer p1: DataMessageObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func unsubscribeFromReceiveDataMessageFromTopic<M1: Cuckoo.Matchable>(topic p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "unsubscribeFromReceiveDataMessageFromTopic(topic p0: String)",
                parameterMatchers: matchers
            ))
        }
        
        func sendDataMessage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(topic p0: M1, data p1: M2, lifetimeMs p2: M3) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String, Any, Int32),Swift.Error> where M1.MatchedType == String, M2.MatchedType == Any, M3.MatchedType == Int32 {
            let matchers: [Cuckoo.ParameterMatcher<(String, Any, Int32)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "sendDataMessage(topic p0: String, data p1: Any, lifetimeMs p2: Int32) throws",
                parameterMatchers: matchers
            ))
        }
        
        func updateVideoSourceSubscriptions<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(addedOrUpdated p0: M1, removed p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, Array<RemoteVideoSource>)> where M1.MatchedType == Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, M2.MatchedType == Array<RemoteVideoSource> {
            let matchers: [Cuckoo.ParameterMatcher<(Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, Array<RemoteVideoSource>)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "updateVideoSourceSubscriptions(addedOrUpdated p0: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed p1: Array<RemoteVideoSource>)",
                parameterMatchers: matchers
            ))
        }
        
        func promoteToPrimaryMeeting<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(credentials p0: M1, observer p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver)> where M1.MatchedType == MeetingSessionCredentials, M2.MatchedType == PrimaryMeetingPromotionObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func demoteFromPrimaryMeeting() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientController.self,
                method: "demoteFromPrimaryMeeting()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_VideoClientController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func start() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "start()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopAndDestroy() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopAndDestroy()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startLocalVideo() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "startLocalVideo() throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startLocalVideo<M1: Cuckoo.Matchable>(config p0: M1) -> Cuckoo.__DoNotUse<(LocalVideoConfiguration), Void> where M1.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startLocalVideo(config p0: LocalVideoConfiguration) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startLocalVideo<M1: Cuckoo.Matchable>(source p0: M1) -> Cuckoo.__DoNotUse<(VideoSource), Void> where M1.MatchedType == VideoSource {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startLocalVideo(source p0: VideoSource)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startLocalVideo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(source p0: M1, config p1: M2) -> Cuckoo.__DoNotUse<(VideoSource, LocalVideoConfiguration), Void> where M1.MatchedType == VideoSource, M2.MatchedType == LocalVideoConfiguration {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSource, LocalVideoConfiguration)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "startLocalVideo(source p0: VideoSource, config p1: LocalVideoConfiguration)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopLocalVideo() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopLocalVideo()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startRemoteVideo() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "startRemoteVideo()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopRemoteVideo() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopRemoteVideo()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func switchCamera() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "switchCamera()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getCurrentDevice() -> Cuckoo.__DoNotUse<(), MediaDevice?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getCurrentDevice() -> MediaDevice?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getConfiguration() -> Cuckoo.__DoNotUse<(), MeetingSessionConfiguration> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getConfiguration() -> MeetingSessionConfiguration",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func subscribeToVideoClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(AudioVideoObserver), Void> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "subscribeToVideoClientStateChange(observer p0: AudioVideoObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unsubscribeFromVideoClientStateChange<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(AudioVideoObserver), Void> where M1.MatchedType == AudioVideoObserver {
            let matchers: [Cuckoo.ParameterMatcher<(AudioVideoObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "unsubscribeFromVideoClientStateChange(observer p0: AudioVideoObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func subscribeToVideoTileControllerObservers<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(VideoTileController), Void> where M1.MatchedType == VideoTileController {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileController)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "subscribeToVideoTileControllerObservers(observer p0: VideoTileController)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unsubscribeFromVideoTileControllerObservers<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(VideoTileController), Void> where M1.MatchedType == VideoTileController {
            let matchers: [Cuckoo.ParameterMatcher<(VideoTileController)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "unsubscribeFromVideoTileControllerObservers(observer p0: VideoTileController)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func pauseResumeRemoteVideo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ p0: M1, pause p1: M2) -> Cuckoo.__DoNotUse<(UInt32, Bool), Void> where M1.MatchedType == UInt32, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(UInt32, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "pauseResumeRemoteVideo(_ p0: UInt32, pause p1: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func subscribeToReceiveDataMessage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(topic p0: M1, observer p1: M2) -> Cuckoo.__DoNotUse<(String, DataMessageObserver), Void> where M1.MatchedType == String, M2.MatchedType == DataMessageObserver {
            let matchers: [Cuckoo.ParameterMatcher<(String, DataMessageObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "subscribeToReceiveDataMessage(topic p0: String, observer p1: DataMessageObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unsubscribeFromReceiveDataMessageFromTopic<M1: Cuckoo.Matchable>(topic p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "unsubscribeFromReceiveDataMessageFromTopic(topic p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func sendDataMessage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(topic p0: M1, data p1: M2, lifetimeMs p2: M3) -> Cuckoo.__DoNotUse<(String, Any, Int32), Void> where M1.MatchedType == String, M2.MatchedType == Any, M3.MatchedType == Int32 {
            let matchers: [Cuckoo.ParameterMatcher<(String, Any, Int32)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "sendDataMessage(topic p0: String, data p1: Any, lifetimeMs p2: Int32) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateVideoSourceSubscriptions<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(addedOrUpdated p0: M1, removed p1: M2) -> Cuckoo.__DoNotUse<(Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, Array<RemoteVideoSource>), Void> where M1.MatchedType == Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, M2.MatchedType == Array<RemoteVideoSource> {
            let matchers: [Cuckoo.ParameterMatcher<(Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, Array<RemoteVideoSource>)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "updateVideoSourceSubscriptions(addedOrUpdated p0: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed p1: Array<RemoteVideoSource>)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func promoteToPrimaryMeeting<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(credentials p0: M1, observer p1: M2) -> Cuckoo.__DoNotUse<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver), Void> where M1.MatchedType == MeetingSessionCredentials, M2.MatchedType == PrimaryMeetingPromotionObserver {
            let matchers: [Cuckoo.ParameterMatcher<(MeetingSessionCredentials, PrimaryMeetingPromotionObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func demoteFromPrimaryMeeting() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "demoteFromPrimaryMeeting()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class VideoClientControllerStub:VideoClientController, @unchecked Sendable {


    
    public func start() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopAndDestroy() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startLocalVideo() throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startLocalVideo(config p0: LocalVideoConfiguration) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startLocalVideo(source p0: VideoSource) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startLocalVideo(source p0: VideoSource, config p1: LocalVideoConfiguration) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopLocalVideo() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startRemoteVideo() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopRemoteVideo() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func switchCamera() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getCurrentDevice() -> MediaDevice? {
        return DefaultValueRegistry.defaultValue(for: (MediaDevice?).self)
    }
    
    public func getConfiguration() -> MeetingSessionConfiguration {
        return DefaultValueRegistry.defaultValue(for: (MeetingSessionConfiguration).self)
    }
    
    public func subscribeToVideoClientStateChange(observer p0: AudioVideoObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unsubscribeFromVideoClientStateChange(observer p0: AudioVideoObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func subscribeToVideoTileControllerObservers(observer p0: VideoTileController) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unsubscribeFromVideoTileControllerObservers(observer p0: VideoTileController) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func pauseResumeRemoteVideo(_ p0: UInt32, pause p1: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func subscribeToReceiveDataMessage(topic p0: String, observer p1: DataMessageObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unsubscribeFromReceiveDataMessageFromTopic(topic p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func sendDataMessage(topic p0: String, data p1: Any, lifetimeMs p2: Int32) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateVideoSourceSubscriptions(addedOrUpdated p0: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed p1: Array<RemoteVideoSource>) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func promoteToPrimaryMeeting(credentials p0: MeetingSessionCredentials, observer p1: PrimaryMeetingPromotionObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func demoteFromPrimaryMeeting() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/internal/video/VideoClientProtocol.swift'

import Cuckoo
import AmazonChimeSDKMedia
import Foundation
import AVFoundation
import UIKit
@testable import AmazonChimeSDK

public class MockVideoClientProtocol: VideoClientProtocol, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any VideoClientProtocol
    public typealias Stubbing = __StubbingProxy_VideoClientProtocol
    public typealias Verification = __VerificationProxy_VideoClientProtocol

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any VideoClientProtocol)?

    public func enableDefaultImplementation(_ stub: any VideoClientProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var delegate: VideoClientDelegate! {
        get {
            return cuckoo_manager.getter(
                "delegate",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.delegate
            )
        }
        set {
            cuckoo_manager.setter(
                "delegate",
                value: newValue,
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.delegate = newValue
            )
        }
    }


    public func start(_ p0: String!, token p1: String!, sending p2: Bool, config p3: VideoConfiguration!, appInfo p4: app_detailed_info_t, signalingUrl p5: String!) {
        return cuckoo_manager.call(
            "start(_ p0: String!, token p1: String!, sending p2: Bool, config p3: VideoConfiguration!, appInfo p4: app_detailed_info_t, signalingUrl p5: String!)",
            parameters: (p0, p1, p2, p3, p4, p5),
            escapingParameters: (p0, p1, p2, p3, p4, p5),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start(p0, token: p1, sending: p2, config: p3, appInfo: p4, signalingUrl: p5)
        )
    }

    public func start(_ p0: String!, token p1: String!, sending p2: Bool, config p3: VideoConfiguration!, appInfo p4: app_detailed_info_t) {
        return cuckoo_manager.call(
            "start(_ p0: String!, token p1: String!, sending p2: Bool, config p3: VideoConfiguration!, appInfo p4: app_detailed_info_t)",
            parameters: (p0, p1, p2, p3, p4),
            escapingParameters: (p0, p1, p2, p3, p4),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start(p0, token: p1, sending: p2, config: p3, appInfo: p4)
        )
    }

    public func stop() {
        return cuckoo_manager.call(
            "stop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stop()
        )
    }

    public func setSending(_ p0: Bool) {
        return cuckoo_manager.call(
            "setSending(_ p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setSending(p0)
        )
    }

    public func setReceiving(_ p0: Bool) {
        return cuckoo_manager.call(
            "setReceiving(_ p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setReceiving(p0)
        )
    }

    public func setExternalVideoSource(_ p0: VideoSourceInternal!) {
        return cuckoo_manager.call(
            "setExternalVideoSource(_ p0: VideoSourceInternal!)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setExternalVideoSource(p0)
        )
    }

    public func getServiceType() -> video_client_service_type_t {
        return cuckoo_manager.call(
            "getServiceType() -> video_client_service_type_t",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getServiceType()
        )
    }

    public func setRemotePause(_ p0: UInt32, pause p1: Bool) {
        return cuckoo_manager.call(
            "setRemotePause(_ p0: UInt32, pause p1: Bool)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setRemotePause(p0, pause: p1)
        )
    }

    public func videoLogCallBack(_ p0: video_client_loglevel_t, msg p1: String!) {
        return cuckoo_manager.call(
            "videoLogCallBack(_ p0: video_client_loglevel_t, msg p1: String!)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.videoLogCallBack(p0, msg: p1)
        )
    }

    public func sendDataMessage(_ p0: String!, data p1: UnsafePointer<Int8>!, dataLen p2: UInt32, lifetimeMs p3: Int32) {
        return cuckoo_manager.call(
            "sendDataMessage(_ p0: String!, data p1: UnsafePointer<Int8>!, dataLen p2: UInt32, lifetimeMs p3: Int32)",
            parameters: (p0, p1, p2, p3),
            escapingParameters: (p0, p1, p2, p3),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.sendDataMessage(p0, data: p1, dataLen: p2, lifetimeMs: p3)
        )
    }

    public func updateVideoSourceSubscriptions(_ p0: [AnyHashable: Any]!, withRemoved p1: [Any]!) {
        return cuckoo_manager.call(
            "updateVideoSourceSubscriptions(_ p0: [AnyHashable: Any]!, withRemoved p1: [Any]!)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.updateVideoSourceSubscriptions(p0, withRemoved: p1)
        )
    }

    public func promotePrimaryMeeting(_ p0: String!, externalUserId p1: String!, joinToken p2: String!) {
        return cuckoo_manager.call(
            "promotePrimaryMeeting(_ p0: String!, externalUserId p1: String!, joinToken p2: String!)",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.promotePrimaryMeeting(p0, externalUserId: p1, joinToken: p2)
        )
    }

    public func demoteFromPrimaryMeeting() {
        return cuckoo_manager.call(
            "demoteFromPrimaryMeeting()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.demoteFromPrimaryMeeting()
        )
    }

    public func setMaxBitRateKbps(_ p0: UInt32) {
        return cuckoo_manager.call(
            "setMaxBitRateKbps(_ p0: UInt32)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setMaxBitRateKbps(p0)
        )
    }

    public func setContentMaxResolutionUHD(_ p0: Bool) {
        return cuckoo_manager.call(
            "setContentMaxResolutionUHD(_ p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setContentMaxResolutionUHD(p0)
        )
    }

    public struct __StubbingProxy_VideoClientProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var delegate: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockVideoClientProtocol,VideoClientDelegate> {
            return .init(manager: cuckoo_manager, name: "delegate")
        }
        
        func start<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.Matchable, M6: Cuckoo.OptionalMatchable>(_ p0: M1, token p1: M2, sending p2: M3, config p3: M4, appInfo p4: M5, signalingUrl p5: M6) -> Cuckoo.ProtocolStubNoReturnFunction<(String?, String?, Bool, VideoConfiguration?, app_detailed_info_t, String?)> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == Bool, M4.OptionalMatchedType == VideoConfiguration, M5.MatchedType == app_detailed_info_t, M6.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, Bool, VideoConfiguration?, app_detailed_info_t, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }, wrap(matchable: p5) { $0.5 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "start(_ p0: String!, token p1: String!, sending p2: Bool, config p3: VideoConfiguration!, appInfo p4: app_detailed_info_t, signalingUrl p5: String!)",
                parameterMatchers: matchers
            ))
        }
        
        func start<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.Matchable>(_ p0: M1, token p1: M2, sending p2: M3, config p3: M4, appInfo p4: M5) -> Cuckoo.ProtocolStubNoReturnFunction<(String?, String?, Bool, VideoConfiguration?, app_detailed_info_t)> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == Bool, M4.OptionalMatchedType == VideoConfiguration, M5.MatchedType == app_detailed_info_t {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, Bool, VideoConfiguration?, app_detailed_info_t)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "start(_ p0: String!, token p1: String!, sending p2: Bool, config p3: VideoConfiguration!, appInfo p4: app_detailed_info_t)",
                parameterMatchers: matchers
            ))
        }
        
        func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "stop()",
                parameterMatchers: matchers
            ))
        }
        
        func setSending<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "setSending(_ p0: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func setReceiving<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "setReceiving(_ p0: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func setExternalVideoSource<M1: Cuckoo.OptionalMatchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoSourceInternal?)> where M1.OptionalMatchedType == VideoSourceInternal {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSourceInternal?)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "setExternalVideoSource(_ p0: VideoSourceInternal!)",
                parameterMatchers: matchers
            ))
        }
        
        func getServiceType() -> Cuckoo.ProtocolStubFunction<(), video_client_service_type_t> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "getServiceType() -> video_client_service_type_t",
                parameterMatchers: matchers
            ))
        }
        
        func setRemotePause<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ p0: M1, pause p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(UInt32, Bool)> where M1.MatchedType == UInt32, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(UInt32, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "setRemotePause(_ p0: UInt32, pause p1: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func videoLogCallBack<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(_ p0: M1, msg p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(video_client_loglevel_t, String?)> where M1.MatchedType == video_client_loglevel_t, M2.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(video_client_loglevel_t, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "videoLogCallBack(_ p0: video_client_loglevel_t, msg p1: String!)",
                parameterMatchers: matchers
            ))
        }
        
        func sendDataMessage<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(_ p0: M1, data p1: M2, dataLen p2: M3, lifetimeMs p3: M4) -> Cuckoo.ProtocolStubNoReturnFunction<(String?, UnsafePointer<Int8>?, UInt32, Int32)> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == UnsafePointer<Int8>, M3.MatchedType == UInt32, M4.MatchedType == Int32 {
            let matchers: [Cuckoo.ParameterMatcher<(String?, UnsafePointer<Int8>?, UInt32, Int32)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "sendDataMessage(_ p0: String!, data p1: UnsafePointer<Int8>!, dataLen p2: UInt32, lifetimeMs p3: Int32)",
                parameterMatchers: matchers
            ))
        }
        
        func updateVideoSourceSubscriptions<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(_ p0: M1, withRemoved p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<([AnyHashable: Any]?, [Any]?)> where M1.OptionalMatchedType == [AnyHashable: Any], M2.OptionalMatchedType == [Any] {
            let matchers: [Cuckoo.ParameterMatcher<([AnyHashable: Any]?, [Any]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "updateVideoSourceSubscriptions(_ p0: [AnyHashable: Any]!, withRemoved p1: [Any]!)",
                parameterMatchers: matchers
            ))
        }
        
        func promotePrimaryMeeting<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(_ p0: M1, externalUserId p1: M2, joinToken p2: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(String?, String?, String?)> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "promotePrimaryMeeting(_ p0: String!, externalUserId p1: String!, joinToken p2: String!)",
                parameterMatchers: matchers
            ))
        }
        
        func demoteFromPrimaryMeeting() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "demoteFromPrimaryMeeting()",
                parameterMatchers: matchers
            ))
        }
        
        func setMaxBitRateKbps<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(UInt32)> where M1.MatchedType == UInt32 {
            let matchers: [Cuckoo.ParameterMatcher<(UInt32)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "setMaxBitRateKbps(_ p0: UInt32)",
                parameterMatchers: matchers
            ))
        }
        
        func setContentMaxResolutionUHD<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVideoClientProtocol.self,
                method: "setContentMaxResolutionUHD(_ p0: Bool)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_VideoClientProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var delegate: Cuckoo.VerifyOptionalProperty<VideoClientDelegate> {
            return .init(manager: cuckoo_manager, name: "delegate", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func start<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.Matchable, M6: Cuckoo.OptionalMatchable>(_ p0: M1, token p1: M2, sending p2: M3, config p3: M4, appInfo p4: M5, signalingUrl p5: M6) -> Cuckoo.__DoNotUse<(String?, String?, Bool, VideoConfiguration?, app_detailed_info_t, String?), Void> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == Bool, M4.OptionalMatchedType == VideoConfiguration, M5.MatchedType == app_detailed_info_t, M6.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, Bool, VideoConfiguration?, app_detailed_info_t, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }, wrap(matchable: p5) { $0.5 }]
            return cuckoo_manager.verify(
                "start(_ p0: String!, token p1: String!, sending p2: Bool, config p3: VideoConfiguration!, appInfo p4: app_detailed_info_t, signalingUrl p5: String!)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func start<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.Matchable>(_ p0: M1, token p1: M2, sending p2: M3, config p3: M4, appInfo p4: M5) -> Cuckoo.__DoNotUse<(String?, String?, Bool, VideoConfiguration?, app_detailed_info_t), Void> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == Bool, M4.OptionalMatchedType == VideoConfiguration, M5.MatchedType == app_detailed_info_t {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, Bool, VideoConfiguration?, app_detailed_info_t)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }]
            return cuckoo_manager.verify(
                "start(_ p0: String!, token p1: String!, sending p2: Bool, config p3: VideoConfiguration!, appInfo p4: app_detailed_info_t)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setSending<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setSending(_ p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setReceiving<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setReceiving(_ p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setExternalVideoSource<M1: Cuckoo.OptionalMatchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(VideoSourceInternal?), Void> where M1.OptionalMatchedType == VideoSourceInternal {
            let matchers: [Cuckoo.ParameterMatcher<(VideoSourceInternal?)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setExternalVideoSource(_ p0: VideoSourceInternal!)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getServiceType() -> Cuckoo.__DoNotUse<(), video_client_service_type_t> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getServiceType() -> video_client_service_type_t",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setRemotePause<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ p0: M1, pause p1: M2) -> Cuckoo.__DoNotUse<(UInt32, Bool), Void> where M1.MatchedType == UInt32, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(UInt32, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "setRemotePause(_ p0: UInt32, pause p1: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func videoLogCallBack<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(_ p0: M1, msg p1: M2) -> Cuckoo.__DoNotUse<(video_client_loglevel_t, String?), Void> where M1.MatchedType == video_client_loglevel_t, M2.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(video_client_loglevel_t, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "videoLogCallBack(_ p0: video_client_loglevel_t, msg p1: String!)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func sendDataMessage<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(_ p0: M1, data p1: M2, dataLen p2: M3, lifetimeMs p3: M4) -> Cuckoo.__DoNotUse<(String?, UnsafePointer<Int8>?, UInt32, Int32), Void> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == UnsafePointer<Int8>, M3.MatchedType == UInt32, M4.MatchedType == Int32 {
            let matchers: [Cuckoo.ParameterMatcher<(String?, UnsafePointer<Int8>?, UInt32, Int32)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return cuckoo_manager.verify(
                "sendDataMessage(_ p0: String!, data p1: UnsafePointer<Int8>!, dataLen p2: UInt32, lifetimeMs p3: Int32)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateVideoSourceSubscriptions<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(_ p0: M1, withRemoved p1: M2) -> Cuckoo.__DoNotUse<([AnyHashable: Any]?, [Any]?), Void> where M1.OptionalMatchedType == [AnyHashable: Any], M2.OptionalMatchedType == [Any] {
            let matchers: [Cuckoo.ParameterMatcher<([AnyHashable: Any]?, [Any]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "updateVideoSourceSubscriptions(_ p0: [AnyHashable: Any]!, withRemoved p1: [Any]!)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func promotePrimaryMeeting<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(_ p0: M1, externalUserId p1: M2, joinToken p2: M3) -> Cuckoo.__DoNotUse<(String?, String?, String?), Void> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "promotePrimaryMeeting(_ p0: String!, externalUserId p1: String!, joinToken p2: String!)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func demoteFromPrimaryMeeting() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "demoteFromPrimaryMeeting()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setMaxBitRateKbps<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(UInt32), Void> where M1.MatchedType == UInt32 {
            let matchers: [Cuckoo.ParameterMatcher<(UInt32)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setMaxBitRateKbps(_ p0: UInt32)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setContentMaxResolutionUHD<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setContentMaxResolutionUHD(_ p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class VideoClientProtocolStub:VideoClientProtocol, @unchecked Sendable {
    
    public var delegate: VideoClientDelegate! {
        get {
            return DefaultValueRegistry.defaultValue(for: (VideoClientDelegate?).self)
        }
        set {}
    }


    
    public func start(_ p0: String!, token p1: String!, sending p2: Bool, config p3: VideoConfiguration!, appInfo p4: app_detailed_info_t, signalingUrl p5: String!) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func start(_ p0: String!, token p1: String!, sending p2: Bool, config p3: VideoConfiguration!, appInfo p4: app_detailed_info_t) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setSending(_ p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setReceiving(_ p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setExternalVideoSource(_ p0: VideoSourceInternal!) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getServiceType() -> video_client_service_type_t {
        return DefaultValueRegistry.defaultValue(for: (video_client_service_type_t).self)
    }
    
    public func setRemotePause(_ p0: UInt32, pause p1: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func videoLogCallBack(_ p0: video_client_loglevel_t, msg p1: String!) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func sendDataMessage(_ p0: String!, data p1: UnsafePointer<Int8>!, dataLen p2: UInt32, lifetimeMs p3: Int32) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateVideoSourceSubscriptions(_ p0: [AnyHashable: Any]!, withRemoved p1: [Any]!) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func promotePrimaryMeeting(_ p0: String!, externalUserId p1: String!, joinToken p2: String!) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func demoteFromPrimaryMeeting() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setMaxBitRateKbps(_ p0: UInt32) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setContentMaxResolutionUHD(_ p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/realtime/RealtimeControllerFacade.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockRealtimeControllerFacade: RealtimeControllerFacade, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any RealtimeControllerFacade
    public typealias Stubbing = __StubbingProxy_RealtimeControllerFacade
    public typealias Verification = __VerificationProxy_RealtimeControllerFacade

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any RealtimeControllerFacade)?

    public func enableDefaultImplementation(_ stub: any RealtimeControllerFacade) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func realtimeLocalMute() -> Bool {
        return cuckoo_manager.call(
            "realtimeLocalMute() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.realtimeLocalMute()
        )
    }

    public func realtimeLocalUnmute() -> Bool {
        return cuckoo_manager.call(
            "realtimeLocalUnmute() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.realtimeLocalUnmute()
        )
    }

    public func realtimePlaybackMute() -> Bool {
        return cuckoo_manager.call(
            "realtimePlaybackMute() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.realtimePlaybackMute()
        )
    }

    public func realtimePlaybackUnmute() -> Bool {
        return cuckoo_manager.call(
            "realtimePlaybackUnmute() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.realtimePlaybackUnmute()
        )
    }

    public func addRealtimeObserver(observer p0: RealtimeObserver) {
        return cuckoo_manager.call(
            "addRealtimeObserver(observer p0: RealtimeObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addRealtimeObserver(observer: p0)
        )
    }

    public func removeRealtimeObserver(observer p0: RealtimeObserver) {
        return cuckoo_manager.call(
            "removeRealtimeObserver(observer p0: RealtimeObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeRealtimeObserver(observer: p0)
        )
    }

    public func addRealtimeDataMessageObserver(topic p0: String, observer p1: DataMessageObserver) {
        return cuckoo_manager.call(
            "addRealtimeDataMessageObserver(topic p0: String, observer p1: DataMessageObserver)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addRealtimeDataMessageObserver(topic: p0, observer: p1)
        )
    }

    public func removeRealtimeDataMessageObserverFromTopic(topic p0: String) {
        return cuckoo_manager.call(
            "removeRealtimeDataMessageObserverFromTopic(topic p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeRealtimeDataMessageObserverFromTopic(topic: p0)
        )
    }

    public func realtimeSendDataMessage(topic p0: String, data p1: Any, lifetimeMs p2: Int32) throws {
        return try cuckoo_manager.callThrows(
            "realtimeSendDataMessage(topic p0: String, data p1: Any, lifetimeMs p2: Int32) throws",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.realtimeSendDataMessage(topic: p0, data: p1, lifetimeMs: p2)
        )
    }

    public func realtimeSetVoiceFocusEnabled(enabled p0: Bool) -> Bool {
        return cuckoo_manager.call(
            "realtimeSetVoiceFocusEnabled(enabled p0: Bool) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.realtimeSetVoiceFocusEnabled(enabled: p0)
        )
    }

    public func realtimeIsVoiceFocusEnabled() -> Bool {
        return cuckoo_manager.call(
            "realtimeIsVoiceFocusEnabled() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.realtimeIsVoiceFocusEnabled()
        )
    }

    public func addRealtimeTranscriptEventObserver(observer p0: TranscriptEventObserver) {
        return cuckoo_manager.call(
            "addRealtimeTranscriptEventObserver(observer p0: TranscriptEventObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.addRealtimeTranscriptEventObserver!(observer: p0)
        )
    }

    public func removeRealtimeTranscriptEventObserver(observer p0: TranscriptEventObserver) {
        return cuckoo_manager.call(
            "removeRealtimeTranscriptEventObserver(observer p0: TranscriptEventObserver)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeRealtimeTranscriptEventObserver!(observer: p0)
        )
    }

    public struct __StubbingProxy_RealtimeControllerFacade: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func realtimeLocalMute() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "realtimeLocalMute() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func realtimeLocalUnmute() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "realtimeLocalUnmute() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func realtimePlaybackMute() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "realtimePlaybackMute() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func realtimePlaybackUnmute() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "realtimePlaybackUnmute() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func addRealtimeObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(RealtimeObserver)> where M1.MatchedType == RealtimeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(RealtimeObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "addRealtimeObserver(observer p0: RealtimeObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeRealtimeObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(RealtimeObserver)> where M1.MatchedType == RealtimeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(RealtimeObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "removeRealtimeObserver(observer p0: RealtimeObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func addRealtimeDataMessageObserver<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(topic p0: M1, observer p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, DataMessageObserver)> where M1.MatchedType == String, M2.MatchedType == DataMessageObserver {
            let matchers: [Cuckoo.ParameterMatcher<(String, DataMessageObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "addRealtimeDataMessageObserver(topic p0: String, observer p1: DataMessageObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeRealtimeDataMessageObserverFromTopic<M1: Cuckoo.Matchable>(topic p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "removeRealtimeDataMessageObserverFromTopic(topic p0: String)",
                parameterMatchers: matchers
            ))
        }
        
        func realtimeSendDataMessage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(topic p0: M1, data p1: M2, lifetimeMs p2: M3) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String, Any, Int32),Swift.Error> where M1.MatchedType == String, M2.MatchedType == Any, M3.MatchedType == Int32 {
            let matchers: [Cuckoo.ParameterMatcher<(String, Any, Int32)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "realtimeSendDataMessage(topic p0: String, data p1: Any, lifetimeMs p2: Int32) throws",
                parameterMatchers: matchers
            ))
        }
        
        func realtimeSetVoiceFocusEnabled<M1: Cuckoo.Matchable>(enabled p0: M1) -> Cuckoo.ProtocolStubFunction<(Bool), Bool> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "realtimeSetVoiceFocusEnabled(enabled p0: Bool) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func realtimeIsVoiceFocusEnabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "realtimeIsVoiceFocusEnabled() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func addRealtimeTranscriptEventObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(TranscriptEventObserver)> where M1.MatchedType == TranscriptEventObserver {
            let matchers: [Cuckoo.ParameterMatcher<(TranscriptEventObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "addRealtimeTranscriptEventObserver(observer p0: TranscriptEventObserver)",
                parameterMatchers: matchers
            ))
        }
        
        func removeRealtimeTranscriptEventObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(TranscriptEventObserver)> where M1.MatchedType == TranscriptEventObserver {
            let matchers: [Cuckoo.ParameterMatcher<(TranscriptEventObserver)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeControllerFacade.self,
                method: "removeRealtimeTranscriptEventObserver(observer p0: TranscriptEventObserver)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_RealtimeControllerFacade: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func realtimeLocalMute() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "realtimeLocalMute() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func realtimeLocalUnmute() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "realtimeLocalUnmute() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func realtimePlaybackMute() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "realtimePlaybackMute() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func realtimePlaybackUnmute() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "realtimePlaybackUnmute() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addRealtimeObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(RealtimeObserver), Void> where M1.MatchedType == RealtimeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(RealtimeObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addRealtimeObserver(observer p0: RealtimeObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeRealtimeObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(RealtimeObserver), Void> where M1.MatchedType == RealtimeObserver {
            let matchers: [Cuckoo.ParameterMatcher<(RealtimeObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeRealtimeObserver(observer p0: RealtimeObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addRealtimeDataMessageObserver<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(topic p0: M1, observer p1: M2) -> Cuckoo.__DoNotUse<(String, DataMessageObserver), Void> where M1.MatchedType == String, M2.MatchedType == DataMessageObserver {
            let matchers: [Cuckoo.ParameterMatcher<(String, DataMessageObserver)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "addRealtimeDataMessageObserver(topic p0: String, observer p1: DataMessageObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeRealtimeDataMessageObserverFromTopic<M1: Cuckoo.Matchable>(topic p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeRealtimeDataMessageObserverFromTopic(topic p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func realtimeSendDataMessage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(topic p0: M1, data p1: M2, lifetimeMs p2: M3) -> Cuckoo.__DoNotUse<(String, Any, Int32), Void> where M1.MatchedType == String, M2.MatchedType == Any, M3.MatchedType == Int32 {
            let matchers: [Cuckoo.ParameterMatcher<(String, Any, Int32)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "realtimeSendDataMessage(topic p0: String, data p1: Any, lifetimeMs p2: Int32) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func realtimeSetVoiceFocusEnabled<M1: Cuckoo.Matchable>(enabled p0: M1) -> Cuckoo.__DoNotUse<(Bool), Bool> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "realtimeSetVoiceFocusEnabled(enabled p0: Bool) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func realtimeIsVoiceFocusEnabled() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "realtimeIsVoiceFocusEnabled() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func addRealtimeTranscriptEventObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(TranscriptEventObserver), Void> where M1.MatchedType == TranscriptEventObserver {
            let matchers: [Cuckoo.ParameterMatcher<(TranscriptEventObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "addRealtimeTranscriptEventObserver(observer p0: TranscriptEventObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeRealtimeTranscriptEventObserver<M1: Cuckoo.Matchable>(observer p0: M1) -> Cuckoo.__DoNotUse<(TranscriptEventObserver), Void> where M1.MatchedType == TranscriptEventObserver {
            let matchers: [Cuckoo.ParameterMatcher<(TranscriptEventObserver)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeRealtimeTranscriptEventObserver(observer p0: TranscriptEventObserver)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class RealtimeControllerFacadeStub:RealtimeControllerFacade, @unchecked Sendable {


    
    public func realtimeLocalMute() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func realtimeLocalUnmute() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func realtimePlaybackMute() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func realtimePlaybackUnmute() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func addRealtimeObserver(observer p0: RealtimeObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeRealtimeObserver(observer p0: RealtimeObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func addRealtimeDataMessageObserver(topic p0: String, observer p1: DataMessageObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeRealtimeDataMessageObserverFromTopic(topic p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func realtimeSendDataMessage(topic p0: String, data p1: Any, lifetimeMs p2: Int32) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func realtimeSetVoiceFocusEnabled(enabled p0: Bool) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func realtimeIsVoiceFocusEnabled() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func addRealtimeTranscriptEventObserver(observer p0: TranscriptEventObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeRealtimeTranscriptEventObserver(observer p0: TranscriptEventObserver) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/realtime/RealtimeObserver.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockRealtimeObserver: RealtimeObserver, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any RealtimeObserver
    public typealias Stubbing = __StubbingProxy_RealtimeObserver
    public typealias Verification = __VerificationProxy_RealtimeObserver

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any RealtimeObserver)?

    public func enableDefaultImplementation(_ stub: any RealtimeObserver) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func volumeDidChange(volumeUpdates p0: [VolumeUpdate]) {
        return cuckoo_manager.call(
            "volumeDidChange(volumeUpdates p0: [VolumeUpdate])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.volumeDidChange(volumeUpdates: p0)
        )
    }

    public func signalStrengthDidChange(signalUpdates p0: [SignalUpdate]) {
        return cuckoo_manager.call(
            "signalStrengthDidChange(signalUpdates p0: [SignalUpdate])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.signalStrengthDidChange(signalUpdates: p0)
        )
    }

    public func attendeesDidJoin(attendeeInfo p0: [AttendeeInfo]) {
        return cuckoo_manager.call(
            "attendeesDidJoin(attendeeInfo p0: [AttendeeInfo])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.attendeesDidJoin(attendeeInfo: p0)
        )
    }

    public func attendeesDidLeave(attendeeInfo p0: [AttendeeInfo]) {
        return cuckoo_manager.call(
            "attendeesDidLeave(attendeeInfo p0: [AttendeeInfo])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.attendeesDidLeave(attendeeInfo: p0)
        )
    }

    public func attendeesDidDrop(attendeeInfo p0: [AttendeeInfo]) {
        return cuckoo_manager.call(
            "attendeesDidDrop(attendeeInfo p0: [AttendeeInfo])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.attendeesDidDrop(attendeeInfo: p0)
        )
    }

    public func attendeesDidMute(attendeeInfo p0: [AttendeeInfo]) {
        return cuckoo_manager.call(
            "attendeesDidMute(attendeeInfo p0: [AttendeeInfo])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.attendeesDidMute(attendeeInfo: p0)
        )
    }

    public func attendeesDidUnmute(attendeeInfo p0: [AttendeeInfo]) {
        return cuckoo_manager.call(
            "attendeesDidUnmute(attendeeInfo p0: [AttendeeInfo])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.attendeesDidUnmute(attendeeInfo: p0)
        )
    }

    public struct __StubbingProxy_RealtimeObserver: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func volumeDidChange<M1: Cuckoo.Matchable>(volumeUpdates p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([VolumeUpdate])> where M1.MatchedType == [VolumeUpdate] {
            let matchers: [Cuckoo.ParameterMatcher<([VolumeUpdate])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeObserver.self,
                method: "volumeDidChange(volumeUpdates p0: [VolumeUpdate])",
                parameterMatchers: matchers
            ))
        }
        
        func signalStrengthDidChange<M1: Cuckoo.Matchable>(signalUpdates p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([SignalUpdate])> where M1.MatchedType == [SignalUpdate] {
            let matchers: [Cuckoo.ParameterMatcher<([SignalUpdate])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeObserver.self,
                method: "signalStrengthDidChange(signalUpdates p0: [SignalUpdate])",
                parameterMatchers: matchers
            ))
        }
        
        func attendeesDidJoin<M1: Cuckoo.Matchable>(attendeeInfo p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([AttendeeInfo])> where M1.MatchedType == [AttendeeInfo] {
            let matchers: [Cuckoo.ParameterMatcher<([AttendeeInfo])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeObserver.self,
                method: "attendeesDidJoin(attendeeInfo p0: [AttendeeInfo])",
                parameterMatchers: matchers
            ))
        }
        
        func attendeesDidLeave<M1: Cuckoo.Matchable>(attendeeInfo p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([AttendeeInfo])> where M1.MatchedType == [AttendeeInfo] {
            let matchers: [Cuckoo.ParameterMatcher<([AttendeeInfo])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeObserver.self,
                method: "attendeesDidLeave(attendeeInfo p0: [AttendeeInfo])",
                parameterMatchers: matchers
            ))
        }
        
        func attendeesDidDrop<M1: Cuckoo.Matchable>(attendeeInfo p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([AttendeeInfo])> where M1.MatchedType == [AttendeeInfo] {
            let matchers: [Cuckoo.ParameterMatcher<([AttendeeInfo])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeObserver.self,
                method: "attendeesDidDrop(attendeeInfo p0: [AttendeeInfo])",
                parameterMatchers: matchers
            ))
        }
        
        func attendeesDidMute<M1: Cuckoo.Matchable>(attendeeInfo p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([AttendeeInfo])> where M1.MatchedType == [AttendeeInfo] {
            let matchers: [Cuckoo.ParameterMatcher<([AttendeeInfo])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeObserver.self,
                method: "attendeesDidMute(attendeeInfo p0: [AttendeeInfo])",
                parameterMatchers: matchers
            ))
        }
        
        func attendeesDidUnmute<M1: Cuckoo.Matchable>(attendeeInfo p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([AttendeeInfo])> where M1.MatchedType == [AttendeeInfo] {
            let matchers: [Cuckoo.ParameterMatcher<([AttendeeInfo])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRealtimeObserver.self,
                method: "attendeesDidUnmute(attendeeInfo p0: [AttendeeInfo])",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_RealtimeObserver: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func volumeDidChange<M1: Cuckoo.Matchable>(volumeUpdates p0: M1) -> Cuckoo.__DoNotUse<([VolumeUpdate]), Void> where M1.MatchedType == [VolumeUpdate] {
            let matchers: [Cuckoo.ParameterMatcher<([VolumeUpdate])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "volumeDidChange(volumeUpdates p0: [VolumeUpdate])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func signalStrengthDidChange<M1: Cuckoo.Matchable>(signalUpdates p0: M1) -> Cuckoo.__DoNotUse<([SignalUpdate]), Void> where M1.MatchedType == [SignalUpdate] {
            let matchers: [Cuckoo.ParameterMatcher<([SignalUpdate])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "signalStrengthDidChange(signalUpdates p0: [SignalUpdate])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func attendeesDidJoin<M1: Cuckoo.Matchable>(attendeeInfo p0: M1) -> Cuckoo.__DoNotUse<([AttendeeInfo]), Void> where M1.MatchedType == [AttendeeInfo] {
            let matchers: [Cuckoo.ParameterMatcher<([AttendeeInfo])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "attendeesDidJoin(attendeeInfo p0: [AttendeeInfo])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func attendeesDidLeave<M1: Cuckoo.Matchable>(attendeeInfo p0: M1) -> Cuckoo.__DoNotUse<([AttendeeInfo]), Void> where M1.MatchedType == [AttendeeInfo] {
            let matchers: [Cuckoo.ParameterMatcher<([AttendeeInfo])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "attendeesDidLeave(attendeeInfo p0: [AttendeeInfo])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func attendeesDidDrop<M1: Cuckoo.Matchable>(attendeeInfo p0: M1) -> Cuckoo.__DoNotUse<([AttendeeInfo]), Void> where M1.MatchedType == [AttendeeInfo] {
            let matchers: [Cuckoo.ParameterMatcher<([AttendeeInfo])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "attendeesDidDrop(attendeeInfo p0: [AttendeeInfo])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func attendeesDidMute<M1: Cuckoo.Matchable>(attendeeInfo p0: M1) -> Cuckoo.__DoNotUse<([AttendeeInfo]), Void> where M1.MatchedType == [AttendeeInfo] {
            let matchers: [Cuckoo.ParameterMatcher<([AttendeeInfo])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "attendeesDidMute(attendeeInfo p0: [AttendeeInfo])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func attendeesDidUnmute<M1: Cuckoo.Matchable>(attendeeInfo p0: M1) -> Cuckoo.__DoNotUse<([AttendeeInfo]), Void> where M1.MatchedType == [AttendeeInfo] {
            let matchers: [Cuckoo.ParameterMatcher<([AttendeeInfo])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "attendeesDidUnmute(attendeeInfo p0: [AttendeeInfo])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class RealtimeObserverStub:RealtimeObserver, @unchecked Sendable {


    
    public func volumeDidChange(volumeUpdates p0: [VolumeUpdate]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func signalStrengthDidChange(signalUpdates p0: [SignalUpdate]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func attendeesDidJoin(attendeeInfo p0: [AttendeeInfo]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func attendeesDidLeave(attendeeInfo p0: [AttendeeInfo]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func attendeesDidDrop(attendeeInfo p0: [AttendeeInfo]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func attendeesDidMute(attendeeInfo p0: [AttendeeInfo]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func attendeesDidUnmute(attendeeInfo p0: [AttendeeInfo]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/realtime/TranscriptEventObserver.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockTranscriptEventObserver: TranscriptEventObserver, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any TranscriptEventObserver
    public typealias Stubbing = __StubbingProxy_TranscriptEventObserver
    public typealias Verification = __VerificationProxy_TranscriptEventObserver

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any TranscriptEventObserver)?

    public func enableDefaultImplementation(_ stub: any TranscriptEventObserver) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func transcriptEventDidReceive(transcriptEvent p0: TranscriptEvent) {
        return cuckoo_manager.call(
            "transcriptEventDidReceive(transcriptEvent p0: TranscriptEvent)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.transcriptEventDidReceive(transcriptEvent: p0)
        )
    }

    public struct __StubbingProxy_TranscriptEventObserver: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func transcriptEventDidReceive<M1: Cuckoo.Matchable>(transcriptEvent p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(TranscriptEvent)> where M1.MatchedType == TranscriptEvent {
            let matchers: [Cuckoo.ParameterMatcher<(TranscriptEvent)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockTranscriptEventObserver.self,
                method: "transcriptEventDidReceive(transcriptEvent p0: TranscriptEvent)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_TranscriptEventObserver: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func transcriptEventDidReceive<M1: Cuckoo.Matchable>(transcriptEvent p0: M1) -> Cuckoo.__DoNotUse<(TranscriptEvent), Void> where M1.MatchedType == TranscriptEvent {
            let matchers: [Cuckoo.ParameterMatcher<(TranscriptEvent)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "transcriptEventDidReceive(transcriptEvent p0: TranscriptEvent)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class TranscriptEventObserverStub:TranscriptEventObserver, @unchecked Sendable {


    
    public func transcriptEventDidReceive(transcriptEvent p0: TranscriptEvent) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/session/CreateAttendeeResponse.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockCreateAttendeeResponse: CreateAttendeeResponse, Cuckoo.ClassMock, @unchecked Sendable {
    public typealias MocksType = CreateAttendeeResponse
    public typealias Stubbing = __StubbingProxy_CreateAttendeeResponse
    public typealias Verification = __VerificationProxy_CreateAttendeeResponse

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: CreateAttendeeResponse?

    public func enableDefaultImplementation(_ stub: CreateAttendeeResponse) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public struct __StubbingProxy_CreateAttendeeResponse: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
    }

    public struct __VerificationProxy_CreateAttendeeResponse: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}

public class CreateAttendeeResponseStub:CreateAttendeeResponse, @unchecked Sendable {


}


public class MockAttendee: Attendee, Cuckoo.ClassMock, @unchecked Sendable {
    public typealias MocksType = Attendee
    public typealias Stubbing = __StubbingProxy_Attendee
    public typealias Verification = __VerificationProxy_Attendee

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: Attendee?

    public func enableDefaultImplementation(_ stub: Attendee) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public struct __StubbingProxy_Attendee: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
    }

    public struct __VerificationProxy_Attendee: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}

public class AttendeeStub:Attendee, @unchecked Sendable {


}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/session/CreateMeetingResponse.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockCreateMeetingResponse: CreateMeetingResponse, Cuckoo.ClassMock, @unchecked Sendable {
    public typealias MocksType = CreateMeetingResponse
    public typealias Stubbing = __StubbingProxy_CreateMeetingResponse
    public typealias Verification = __VerificationProxy_CreateMeetingResponse

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: CreateMeetingResponse?

    public func enableDefaultImplementation(_ stub: CreateMeetingResponse) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public struct __StubbingProxy_CreateMeetingResponse: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
    }

    public struct __VerificationProxy_CreateMeetingResponse: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}

public class CreateMeetingResponseStub:CreateMeetingResponse, @unchecked Sendable {


}


public class MockMeeting: Meeting, Cuckoo.ClassMock, @unchecked Sendable {
    public typealias MocksType = Meeting
    public typealias Stubbing = __StubbingProxy_Meeting
    public typealias Verification = __VerificationProxy_Meeting

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: Meeting?

    public func enableDefaultImplementation(_ stub: Meeting) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public struct __StubbingProxy_Meeting: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
    }

    public struct __VerificationProxy_Meeting: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}

public class MeetingStub:Meeting, @unchecked Sendable {


}


public class MockMediaPlacement: MediaPlacement, Cuckoo.ClassMock, @unchecked Sendable {
    public typealias MocksType = MediaPlacement
    public typealias Stubbing = __StubbingProxy_MediaPlacement
    public typealias Verification = __VerificationProxy_MediaPlacement

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: MediaPlacement?

    public func enableDefaultImplementation(_ stub: MediaPlacement) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public struct __StubbingProxy_MediaPlacement: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
    }

    public struct __VerificationProxy_MediaPlacement: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}

public class MediaPlacementStub:MediaPlacement, @unchecked Sendable {


}


public class MockMeetingFeatures: MeetingFeatures, Cuckoo.ClassMock, @unchecked Sendable {
    public typealias MocksType = MeetingFeatures
    public typealias Stubbing = __StubbingProxy_MeetingFeatures
    public typealias Verification = __VerificationProxy_MeetingFeatures

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: MeetingFeatures?

    public func enableDefaultImplementation(_ stub: MeetingFeatures) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public struct __StubbingProxy_MeetingFeatures: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
    }

    public struct __VerificationProxy_MeetingFeatures: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}

public class MeetingFeaturesStub:MeetingFeatures, @unchecked Sendable {


}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/session/MeetingSessionConfiguration.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockMeetingSessionConfiguration: MeetingSessionConfiguration, Cuckoo.ClassMock, @unchecked Sendable {
    public typealias MocksType = MeetingSessionConfiguration
    public typealias Stubbing = __StubbingProxy_MeetingSessionConfiguration
    public typealias Verification = __VerificationProxy_MeetingSessionConfiguration

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: MeetingSessionConfiguration?

    public func enableDefaultImplementation(_ stub: MeetingSessionConfiguration) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public struct __StubbingProxy_MeetingSessionConfiguration: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
    }

    public struct __VerificationProxy_MeetingSessionConfiguration: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}

public class MeetingSessionConfigurationStub:MeetingSessionConfiguration, @unchecked Sendable {


}




// MARK: - Mocks generated from file: 'AmazonChimeSDK/utils/logger/Logger.swift'

import Cuckoo
import Foundation
import AVFoundation
import UIKit
import AmazonChimeSDKMedia
@testable import AmazonChimeSDK

public class MockLogger: Logger, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any Logger
    public typealias Stubbing = __StubbingProxy_Logger
    public typealias Verification = __VerificationProxy_Logger

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any Logger)?

    public func enableDefaultImplementation(_ stub: any Logger) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func `default`(msg p0: String) {
        return cuckoo_manager.call(
            "`default`(msg p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.`default`(msg: p0)
        )
    }

    public func debug(debugFunction p0: () -> String) {
        
		return withoutActuallyEscaping(p0, do: { (p0: @escaping () -> String) in
return cuckoo_manager.call(
            "debug(debugFunction p0: () -> String)",
            parameters: (p0),
            escapingParameters: ({ () in fatalError("This is a stub! It's not supposed to be called!") }),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.debug(debugFunction: p0)
        )
		})

    }

    public func info(msg p0: String) {
        return cuckoo_manager.call(
            "info(msg p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.info(msg: p0)
        )
    }

    public func fault(msg p0: String) {
        return cuckoo_manager.call(
            "fault(msg p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fault(msg: p0)
        )
    }

    public func error(msg p0: String) {
        return cuckoo_manager.call(
            "error(msg p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.error(msg: p0)
        )
    }

    public func setLogLevel(level p0: LogLevel) {
        return cuckoo_manager.call(
            "setLogLevel(level p0: LogLevel)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setLogLevel(level: p0)
        )
    }

    public func getLogLevel() -> LogLevel {
        return cuckoo_manager.call(
            "getLogLevel() -> LogLevel",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getLogLevel()
        )
    }

    public struct __StubbingProxy_Logger: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func `default`<M1: Cuckoo.Matchable>(msg p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLogger.self,
                method: "`default`(msg p0: String)",
                parameterMatchers: matchers
            ))
        }
        
        func debug<M1: Cuckoo.Matchable>(debugFunction p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> String)> where M1.MatchedType == () -> String {
            let matchers: [Cuckoo.ParameterMatcher<(() -> String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLogger.self,
                method: "debug(debugFunction p0: () -> String)",
                parameterMatchers: matchers
            ))
        }
        
        func info<M1: Cuckoo.Matchable>(msg p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLogger.self,
                method: "info(msg p0: String)",
                parameterMatchers: matchers
            ))
        }
        
        func fault<M1: Cuckoo.Matchable>(msg p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLogger.self,
                method: "fault(msg p0: String)",
                parameterMatchers: matchers
            ))
        }
        
        func error<M1: Cuckoo.Matchable>(msg p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLogger.self,
                method: "error(msg p0: String)",
                parameterMatchers: matchers
            ))
        }
        
        func setLogLevel<M1: Cuckoo.Matchable>(level p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(LogLevel)> where M1.MatchedType == LogLevel {
            let matchers: [Cuckoo.ParameterMatcher<(LogLevel)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLogger.self,
                method: "setLogLevel(level p0: LogLevel)",
                parameterMatchers: matchers
            ))
        }
        
        func getLogLevel() -> Cuckoo.ProtocolStubFunction<(), LogLevel> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockLogger.self,
                method: "getLogLevel() -> LogLevel",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_Logger: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func `default`<M1: Cuckoo.Matchable>(msg p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "`default`(msg p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func debug<M1: Cuckoo.Matchable>(debugFunction p0: M1) -> Cuckoo.__DoNotUse<(() -> String), Void> where M1.MatchedType == () -> String {
            let matchers: [Cuckoo.ParameterMatcher<(() -> String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "debug(debugFunction p0: () -> String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func info<M1: Cuckoo.Matchable>(msg p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "info(msg p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fault<M1: Cuckoo.Matchable>(msg p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fault(msg p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func error<M1: Cuckoo.Matchable>(msg p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "error(msg p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setLogLevel<M1: Cuckoo.Matchable>(level p0: M1) -> Cuckoo.__DoNotUse<(LogLevel), Void> where M1.MatchedType == LogLevel {
            let matchers: [Cuckoo.ParameterMatcher<(LogLevel)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setLogLevel(level p0: LogLevel)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getLogLevel() -> Cuckoo.__DoNotUse<(), LogLevel> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getLogLevel() -> LogLevel",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class LoggerStub:Logger, @unchecked Sendable {


    
    public func `default`(msg p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func debug(debugFunction p0: () -> String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func info(msg p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func fault(msg p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func error(msg p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setLogLevel(level p0: LogLevel) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getLogLevel() -> LogLevel {
        return DefaultValueRegistry.defaultValue(for: (LogLevel).self)
    }
}


