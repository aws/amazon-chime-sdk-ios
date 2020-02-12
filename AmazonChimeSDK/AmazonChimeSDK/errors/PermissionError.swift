//
//  PermissionError.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

// TODO if we want properties like message, we should use struct
public enum PermissionError: Error {
    case audioPermissionError
}
