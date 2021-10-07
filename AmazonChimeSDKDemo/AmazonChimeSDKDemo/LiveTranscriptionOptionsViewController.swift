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

class LiveTranscriptionOptionsViewController: UIViewController, UITextFieldDelegate {
    var model: MeetingModel?
    var meetingId = ""
    var engineSelected = ""
    var languageSelected = ""
    var regionSelected = ""
    
    @IBOutlet var startTranscriptionButton: UIButton!
    @IBOutlet var engineTextField: UITextField!
    @IBOutlet var languageTextField: UITextField!
    @IBOutlet var regionTextField: UITextField!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    var engines: [String] = []
    var languages: [String] = []
    var regions: [String] = []
    
    let transcribeLanguages = [
                                "en-US",
                                "es-US",
                                "en-GB",
                                "en-AU",
                                "fr-CA",
                                "fr-FR",
                                "it-IT",
                                "de-DE",
                                "pt-BR",
                                "ja-JP",
                                "ko-KR",
                                "zh-CN"
                               ]
    let transcribeRegions = [
                                "auto",
                                "",
                                "ap-northeast-1",
                                "ap-northeast-2",
                                "ap-southeast-2",
                                "ca-central-1",
                                "eu-central-1",
                                "eu-west-1",
                                "eu-west-2",
                                "sa-east-1",
                                "us-east-1",
                                "us-east-2",
                                "us-west-2"
                            ]
    
    let transcribeMedicalLanguages = ["en-US"]
    let transcribeMedicalRegions = [
                                        "auto",
                                        "",
                                        "ap-southeast-2",
                                        "ca-central-1",
                                        "eu-west-1",
                                        "us-east-1",
                                        "us-east-2",
                                        "us-west-2"
                                    ]
    
    var enginesDict = [
        "transcribe": "Amazon Transcribe",
        "transcribe_medical": "Amazon Transcribe Medical"
    ]
    
    var languagesDict = [
        "en-US": "US English (en-US)",
        "es-US": "US Spanish (es-US)",
        "en-GB": "British English (en-GB)",
        "en-AU": "Australian English (en-AU)",
        "fr-CA": "Canadian French (fr-CA)",
        "fr-FR": "French (fr-FR)",
        "it-IT": "Italian (it-IT)",
        "de-DE": "German (de-DE)",
        "pt-BR": "Brazilian Portuguese (pt-BR)",
        "ja-JP": "Japanese (ja-JP)",
        "ko-KR": "Korean (ko-KR)",
        "zh-CN": "Mandarin Chinese - Mainland (zh-CN)"
    ]
    
    let regionsDict = [
        "auto": "Auto",
        "": "Not specified"
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
            self.view?.makeToast(msg, duration: 2.0, position: .top)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.engines = Array(enginesDict.keys)
        self.languages = Array(languagesDict.keys)
        self.regions = Array(regionsDict.keys)

        
        self.engineTextField.delegate = self
        self.languageTextField.delegate = self
        self.regionTextField.delegate = self
        
        guard let meetingId = self.model?.meetingId else {
            return MeetingModule.shared().dismissTranscription(self)
        }
        self.meetingId = meetingId
        engineTextField.inputView = enginePickerView
        languageTextField.inputView = languagePickerView
        regionTextField.inputView = regionPickerView
        
        engineSelected = "transcribe"
        languageSelected = "en-US"
        regionSelected = "auto"
        
        engineTextField.text = enginesDict[engineSelected]
        languageTextField.text = languagesDict[languageSelected]
        regionTextField.text = regionsDict[regionSelected]
        
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
        let engineSelectedBefore = engineSelected
        switch pickerView.tag {
        case 1:
            engineTextField.text = enginesDict[engines[row]]
            engineSelected = engines[row]
            engineTextField.resignFirstResponder()
        case 2:
            languageTextField.text = languagesDict[languages[row]]
            languageSelected = languages[row]
            languageTextField.resignFirstResponder()
        case 3:
            regionTextField.text = regionsDict[regions[row]]
            regionSelected = regions[row]
            regionTextField.resignFirstResponder()
        default:
            return
        }
        
        if engineSelected == "transcribe_medical" && engineSelectedBefore == "transcribe" {
            languages = transcribeMedicalLanguages
            regions = transcribeMedicalRegions
            languageSelected = "en-US"
            languageTextField.text = languagesDict[languageSelected]
            regionSelected = "us-east-1"
            regionTextField.text = regionsDict[regionSelected]
        }
        if engineSelected == "transcribe" {
            languages = transcribeLanguages
            regions = transcribeRegions
        }
    }
}
