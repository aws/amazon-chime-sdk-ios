//
//  LiveTranscriptionOptionsViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK
import UIKit

class LiveTranscriptionOptionsViewController: UIViewController {
    var model: MeetingModel?
    var meetingId = ""
    var engineSelected = ""
    var languageSelected = ""
    var regionSelected = ""
    
    @IBOutlet var startTranscriptionButton: UIButton!
    @IBOutlet var engineTextField: UITextField!
    @IBOutlet var languageTextField: UITextField!
    @IBOutlet var regionTextField: UITextField!
    
    var engines = ["transcribe_medical", "transcribe"]
    var languages = ["es-US", "en-US", "en-GB", "en-AU", "fr-CA", "fr-FR", "it-IT", "de-DE", "pt-BR", "ja-JP", "ko-KR", "zh-CN"]
    var regions = ["us-west-2", "us-east-1", "us-east-2", "sa-east-1", "eu-west-2", "eu-west-1", "eu-central-1", "ca-central-1", "ap-southeast-2", "ap-northeast-2", "ap-northeast-1"]
    
    var enginePickerView = UIPickerView()
    var languagePickerView = UIPickerView()
    var regionPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetingId = self.model!.meetingId
        engineTextField.inputView = enginePickerView
        languageTextField.inputView = languagePickerView
        regionTextField.inputView = regionPickerView
        
//        engineTextField.placeholder = "Select Engine"
//        languageTextField.placeholder = "Select Language"
//        regionTextField.placeholder = "Select Region"
        
        engineSelected = "transcribe"
        languageSelected = "en-US"
        regionSelected = "us-east-1"
        
        engineTextField.text = "transcribe"
        languageTextField.text = "en-US"
        regionTextField.text = "us-east-1"
        
        engineTextField.textAlignment = .center
        languageTextField.textAlignment = .center
        regionTextField.textAlignment = .center
        
        enginePickerView.delegate = self
        languagePickerView.delegate = self
        regionPickerView.delegate = self
        enginePickerView.dataSource = self
        languagePickerView.dataSource = self
        regionPickerView.dataSource = self
        
        enginePickerView.tag = 1
        languagePickerView.tag = 2
        regionPickerView.tag = 3
    }
    @IBAction func startTranscriptionButton(_ sender: UIButton) {
        var url = AppConfiguration.url
        url = url.hasSuffix("/") ? url : "\(url)/"
        let encodedURL = HttpUtils.encodeStrForURL(
            str: "\(url)start_transcription?title=\(meetingId)&language=\(languageSelected)&region=\(regionSelected)&engine=\(engineSelected)")
        HttpUtils.postRequest(url: encodedURL, jsonData: nil) {_,_ in

            }
        MeetingModule.shared().dismissTranscription(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override  func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LiveTranscriptionOptionsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return engines.count
        case 2:
            return languages.count
        case 3:
            return regions.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return engines[row]
        case 2:
            return languages[row]
        case 3:
            return regions[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            engineTextField.text = engines[row]
            engineSelected = engines[row]
            engineTextField.resignFirstResponder()
        case 2:
            languageTextField.text = languages[row]
            languageSelected = languages[row]
            languageTextField.resignFirstResponder()
        case 3:
            regionTextField.text = regions[row]
            regionSelected = regions[row]
            regionTextField.resignFirstResponder()
        default:
            return
        }
        
        if engineTextField.text == "transcribe_medical" {
            languages = ["en-US"]
            regions = ["ap-southeast-2", "ca-central-1", "eu-west-1", "us-east-1", "us-east-2", "us-west-2"]
        }
    }
}
