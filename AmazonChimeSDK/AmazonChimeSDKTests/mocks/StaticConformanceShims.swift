//
//  StaticConformanceShims.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//
//  Cuckoo does not generate static protocol members. These extensions satisfy
//  the static requirements of mocked protocols. Static members cannot be
//  stubbed or verified; no test relies on them.
//

import Cuckoo
@testable import AmazonChimeSDK

extension MockVideoClientProtocol {
    public static func globalInitialize() {}
}

extension VideoClientProtocolStub {
    public static func globalInitialize() {}
}
