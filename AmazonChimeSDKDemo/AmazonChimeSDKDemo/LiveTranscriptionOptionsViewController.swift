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
    
    var enginesDict = [
        "transcribe": "Trancribe",
        "transcribe_medical": "Transcribe Medical"
    ]
    
    var languagesDict = [
        "en-US": "US English",
        "es-US": "US Spanish",
        "en-GB": "British English",
        "en-AU": "Australian English",
        "fr-CA": "Canadian French",
        "fr-FR": "French",
        "it-IT": "Italian",
        "de-DE": "German",
        "pt-BR": "Brazilian Portuguese",
        "ja-JP": "Japanese",
        "ko-KR": "Korean",
        "zh-CN": "Mandarin Chinese"
    ]
    
    var regionsDict = [
        "ap-northeast-1": "Japan (Tokyo)",
        "ap-northeast-2": "South Korea (Seoul)",
        "ap-southeast-2": "Australia (Sydney)",
        "ca-central-1": "Canada",
        "eu-central-1": "Germany (Frankfurt)",
        "eu-west-1": "Ireland",
        "eu-west-2": "United Kingdom (London)",
        "sa-east-1": "Brazil (São Paulo)",
        "us-east-1": "United States (N. Virginia)",
        "us-east-2": "United States (Ohio)",
        "us-west-2": "United States (Oregon)"
    ]
    
    var enginePickerView = UIPickerView()
    var languagePickerView = UIPickerView()
    var regionPickerView = UIPickerView()
    
    private func notify(msg: String) {
        DispatchQueue.main.async {
            self.view?.makeToast("Transcription failed", duration: 2.0, position: .top)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let meetingId = self.model?.meetingId else {return MeetingModule.shared().dismissTranscription(self)}
        self.meetingId = meetingId
        engineTextField.inputView = enginePickerView
        languageTextField.inputView = languagePickerView
        regionTextField.inputView = regionPickerView
        
        engineSelected = "transcribe"
        languageSelected = "en-US"
        regionSelected = "us-east-1"
        
        engineTextField.text = "transcribe"
        languageTextField.text = "en-US"
        regionTextField.text = "us-east-1"
        
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
        HttpUtils.postRequest(url: encodedURL, jsonData: nil) {_, error in
            DispatchQueue.main.async {
                if error == nil {
                    MeetingModule.shared().dismissTranscription(self)
                } else {
                    self.notify(msg: "Transcription call failed, please try again")
                }
            }
        }
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
            return enginesDict[engines[row]]
        case 2:
            return languagesDict[languages[row]]
        case 3:
            return regionsDict[regions[row]]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var engineSelectedBefore = engineSelected
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
        
        if engineTextField.text == "transcribe_medical" && engineSelectedBefore == "transcribe" {
            languages = ["en-US"]
            regions = ["ap-southeast-2", "ca-central-1", "eu-west-1", "us-east-1", "us-east-2", "us-west-2"]
            languageTextField.text = "en-US"
            languageSelected = "en-US"
            regionTextField.text = "us-east-1"
            regionSelected = "us-east-1"
        }
        if engineTextField.text == "transcribe" {
            languages = ["es-US", "en-US", "en-GB", "en-AU", "fr-CA", "fr-FR", "it-IT", "de-DE", "pt-BR", "ja-JP", "ko-KR", "zh-CN"]
            regions = ["us-west-2", "us-east-1", "us-east-2", "sa-east-1", "eu-west-2", "eu-west-1", "eu-central-1", "ca-central-1", "ap-southeast-2", "ap-northeast-2", "ap-northeast-1"]
        }
    }
}
