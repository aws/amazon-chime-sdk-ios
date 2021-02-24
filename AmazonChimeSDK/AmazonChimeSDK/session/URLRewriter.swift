//
//  URLRewriter.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `URLRewriter` Function to transform URLs.
/// Use this to rewrite URLs to traverse proxies.
/// - Parameter url: Url string
/// - Returns: A new url string manipulated
public typealias URLRewriter = (_ url: String) -> String

/// `URLRewriterUtils` is class that defines default Url rewrite behavior
@objcMembers public class URLRewriterUtils: NSObject {
    /// The default implementation returns the original URL unchanged.
    public static let defaultUrlRewriter: URLRewriter = { url in
        url
    }
}
