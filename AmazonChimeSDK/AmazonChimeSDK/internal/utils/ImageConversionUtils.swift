//
//  ImageConversionUtils.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CoreImage
import UIKit

/// Utils to help converting image byte array to CGImage and CGImage to byte array.
public class ImageConversionUtils {

    /// A utility function that converts a byte array to a CGImage.
    ///
    /// - Parameters:
    ///   - raw: Pointer to the byte array of the image.
    ///   - frameWidth: Image width.
    ///   - frameHeight: Image height.
    ///   - bytesPerPixel: Total bytes per pixel (color space).
    ///   - bitsPerComponent: Total bits per component.
    ///
    /// - Returns: A CGImage of the input byte array.
    public class func byteArrayToCGImage(raw: UnsafeMutablePointer<UInt8>,
                                         frameWidth: Int,
                                         frameHeight: Int,
                                         bytesPerPixel: Int,
                                         bitsPerComponent: Int) -> CGImage? {

        let bytesPerRow = frameWidth * bytesPerPixel
        let size = frameWidth * frameHeight * bytesPerPixel

        guard let imageCfData = CFDataCreate(nil, raw, size) else {
            return nil
        }

        guard let cgProvider = CGDataProvider.init(data: imageCfData) else {
            return nil
        }

        guard let cgImage: CGImage = CGImage.init(width: frameWidth,
                                                  height: frameHeight,
                                                  bitsPerComponent: bitsPerComponent,
                                                  bitsPerPixel: bytesPerPixel * bitsPerComponent,
                                                  bytesPerRow: bytesPerRow,
                                                  space: CGColorSpaceCreateDeviceRGB(),
                                                  bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue),
                                                  provider: cgProvider,
                                                  decode: nil,
                                                  shouldInterpolate: true,
                                                  intent: CGColorRenderingIntent.defaultIntent)
        else {
            return nil
        }

        return cgImage
    }

    /// A utility function that converts a CGImage to a byte array.
    ///
    /// - Parameters:
    ///   - cgImage: The CGImage to convert.
    ///
    /// - Returns: A UInt8 byte array of the CGImage.
    public class func cgImageToByteArray(cgImage: CGImage) -> [UInt8]? {
        let height = cgImage.height
        let width = cgImage.width

        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let size = height * bytesPerRow

        var byteArray: [UInt8] = [UInt8](repeating: 0, count: size)
        guard let contextRef = CGContext(data: &byteArray,
                                   width: width,
                                   height: height,
                                   bitsPerComponent: bitsPerComponent,
                                   bytesPerRow: bytesPerRow,
                                   space: CGColorSpaceCreateDeviceRGB(),
                                   bitmapInfo: cgImage.bitmapInfo.rawValue)
        else {
            return nil
        }
        contextRef.draw(cgImage, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))

        return byteArray
    }
}
