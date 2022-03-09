//
//  TranscriptionStreamParams.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

public struct TranscriptionStreamParams: Codable {
    let contentIdentificationType: String?
    let contentRedactionType: String?
    let enablePartialResultsStabilization: Bool?
    let partialResultsStability: String?
    let piiEntityTypes: String?
    let languageModelName: String?
    let identifyLanguage: Bool?
    let languageOptions: String?
    let preferredLanguage: String?

    init(contentIdentificationType: String?, contentRedactionType: String?, enablePartialResultsStabilization: Bool?, partialResultsStability: String?,
         piiEntityTypes: String?, languageModelName: String?, identifyLanguage: Bool?, languageOptions: String?, preferredLanguage: String?) {
            
        self.contentIdentificationType = contentIdentificationType
        self.contentRedactionType = contentRedactionType
        self.enablePartialResultsStabilization = enablePartialResultsStabilization
        self.partialResultsStability = partialResultsStability
        self.piiEntityTypes = piiEntityTypes
        self.languageModelName = languageModelName
        self.identifyLanguage = identifyLanguage
        self.languageOptions = languageOptions
        self.preferredLanguage = preferredLanguage
    }
}
