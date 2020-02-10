//
//  PermissionError.swift
//  AmazonChimeSDK
//
//  Created by Hwang, Hokyung on 1/29/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

// TODO if we want properties like message, we should use struct
public enum PermissionError: Error {
    case audioPermissionError
}
