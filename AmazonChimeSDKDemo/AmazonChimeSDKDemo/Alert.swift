//
//  Alert.swift
//  AmazonChimeSDKDemo
//
//  Created by Hwang, Hokyung on 1/21/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

// TODO Temporary alert replace with Proper Alert
import Foundation
import UIKit

// excerpted from https://medium.com/@rushikeshT/displaying-simple-toast-in-ios-swift-57014cbb9ffa
// https://stackoverflow.com/questions/52808945/dispatchqueue-cannot-be-called-with-ascopy-no-on-non-main-thread
func showAlert(controller: UIViewController, message: String, seconds: Double = 2) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 10
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }

}
