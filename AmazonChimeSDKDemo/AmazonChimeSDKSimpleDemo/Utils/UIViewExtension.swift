//
//  UIViewExtension.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

extension UIViewController {
    
    var newMeetingNavController: UINavigationController {
        return UINavigationController(rootViewController: newMeetingViewController)
    }
    
    var newMeetingViewController: MeetingViewController {
        return newMainStoryboard.instantiateViewController(withIdentifier: "MeetingViewController") as! MeetingViewController
    }
    
    var newMainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}
