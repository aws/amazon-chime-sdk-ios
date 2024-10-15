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

let transcribeContentIdetificationType = "PII"
let transcribeMedicalContentIdentificationType = "PHI"
let transcribeMedicalEngine = "transcribe_medical"

class LiveTranscriptionOptionsViewController: UIViewController, UITextFieldDelegate {
    var model: MeetingModel?
    var storyBoard: UIStoryboard?
    var languageOptionsViewController: AutomaticLanguageOptionsViewController?
    var meetingId = ""
    var engineSelected = ""
    var languageSelected = ""
    var regionSelected = ""
    var partialResultsStabilizationOption = 0
    var piiContentIdentificationSelected = ""
    var piiContentRedactionSelected = ""
    var selectedLanguageOptions = ""
    var preferredLanguageOptions = ""
    var meetingEndpointUrl = ""
    
    @IBOutlet var startTranscriptionButton: UIButton!
    @IBOutlet var engineTextField: UITextField!
    @IBOutlet var languageTextField: UITextField!
    @IBOutlet var regionTextField: UITextField!
    @IBOutlet var partialResultsStabilizationTextField: UITextField!
    @IBOutlet var piiContentIdentificationTextField: UITextField!
    @IBOutlet var piiContentRedactionTextField: UITextField!
    @IBOutlet var customLanguageModelTextField: UITextField!
    @IBOutlet var enableCustomLangugeModelTextFieldSwitch: UISwitch!
    @IBOutlet var enableCustomLangugeModelLabel: UILabel!
    @IBOutlet var enablePHIIdentificaitonSwitch: UISwitch!
    @IBOutlet var enablePHIIdentificationLabel: UILabel!
    @IBOutlet var enableAutomaticLanguageIdentificationLabel: UILabel!
    @IBOutlet var enableAutomaticLanguageIdentificationSwitch: UISwitch!
    @IBOutlet var liveTranscriptionScrollView: UIScrollView!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    var engines: [String] = []
    var languages: [String] = []
    var regions: [String] = []
    var partialResultsStabilizations: [String] = []
    var piiContentIdentifications: [String] = []
    var piiContentRedactions: [String] = []
    public var languageHandler: (([String]?) -> Void)?
    public var languagesDictHandler: (([String:String]?)->Void)?
    
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
    
    let transcribePiiContents = [
                                    "",
                                    "ALL",
                                    "BANK_ROUTING",
                                    "CREDIT_DEBIT_NUMBER",
                                    "CREDIT_DEBIT_CVV",
                                    "CREDIT_DEBIT_EXPIRY",
                                    "PIN",
                                    "EMAIL",
                                    "ADDRESS",
                                    "NAME",
                                    "PHONE",
                                    "SSN"
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
        "": "Not specified",
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
    
    let partialResultsStabilizationsList = [
        "Partial Results Stabilization",
        "-- DEFAULT (HIGH) --",
        "Low",
        "Medium",
        "High"
    ]
    
    var piiContentIdentificationDict = [
        "": "PII Content Identification",
        "ALL": "ALL",
        "BANK_ROUTING": "BANK ROUTING",
        "CREDIT_DEBIT_NUMBER": "CREDIT/DEBIT NUMBER",
        "CREDIT_DEBIT_CVV": "CREDIT/DEBIT CVV",
        "CREDIT_DEBIT_EXPIRY": "CREDIT/DEBIT EXPIRY",
        "PIN": "PIN",
        "EMAIL": "EMAIL",
        "ADDRESS": "ADDRESS",
        "NAME": "NAME",
        "PHONE": "PHONE NUMBER",
        "SSN": "SSN"
    ]
    
    var piiContentRedactionDict = [
        "": "PII Content Redaction",
        "ALL": "ALL",
        "BANK_ROUTING": "BANK ROUTING",
        "CREDIT_DEBIT_NUMBER": "CREDIT/DEBIT NUMBER",
        "CREDIT_DEBIT_CVV": "CREDIT/DEBIT CVV",
        "CREDIT_DEBIT_EXPIRY": "CREDIT/DEBIT EXPIRY",
        "PIN": "PIN",
        "EMAIL": "EMAIL",
        "ADDRESS": "ADDRESS",
        "NAME": "NAME",
        "PHONE": "PHONE NUMBER",
        "SSN": "SSN"
    ]
    
    var enginePickerView = UIPickerView()
    var languagePickerView = UIPickerView()
    var regionPickerView = UIPickerView()
    var partialResultsStabilizationPickerView = UIPickerView()
    var piiContentIdentificationPickerView = UIPickerView()
    var piiContentRedactionPickerView = UIPickerView()
    
    private func notify(msg: String) {
        DispatchQueue.main.async {
            self.view?.makeToast(msg, duration: 2.0, position: .top)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liveTranscriptionScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        
        self.engines = Array(enginesDict.keys)
        self.languages = Array(languagesDict.keys)
        self.regions = Array(regionsDict.keys)
        self.partialResultsStabilizations = Array(partialResultsStabilizationsList)
        self.piiContentIdentifications = transcribePiiContents
        self.piiContentRedactions = transcribePiiContents

        
        self.engineTextField.delegate = self
        self.languageTextField.delegate = self
        self.regionTextField.delegate = self
        self.partialResultsStabilizationTextField.delegate = self
        self.piiContentIdentificationTextField.delegate = self
        self.piiContentRedactionTextField.delegate = self
        
        guard let meetingId = self.model?.meetingId, let meetingEndpointUrl = self.model?.meetingEndpointUrl else {
            return MeetingModule.shared().dismissTranscription(self)
        }
        self.meetingId = meetingId
        self.meetingEndpointUrl = meetingEndpointUrl
        engineTextField.inputView = enginePickerView
        languageTextField.inputView = languagePickerView
        regionTextField.inputView = regionPickerView
        partialResultsStabilizationTextField.inputView = partialResultsStabilizationPickerView
        piiContentIdentificationTextField.inputView = piiContentIdentificationPickerView
        piiContentRedactionTextField.inputView = piiContentRedactionPickerView
        
        engineSelected = "transcribe"
        languageSelected = "en-US"
        regionSelected = "auto"
        partialResultsStabilizationOption = 0
        piiContentIdentificationSelected = ""
        piiContentRedactionSelected = ""
        
        engineTextField.text = enginesDict[engineSelected]
        languageTextField.text = languagesDict[languageSelected]
        regionTextField.text = regionsDict[regionSelected]
        partialResultsStabilizationTextField.text = partialResultsStabilizationsList[partialResultsStabilizationOption]
        piiContentIdentificationTextField.text = piiContentIdentificationDict[piiContentIdentificationSelected]
        piiContentRedactionTextField.text = piiContentRedactionDict[piiContentRedactionSelected]
    
        enginePickerView.delegate = self
        languagePickerView.delegate = self
        regionPickerView.delegate = self
        enginePickerView.dataSource = self
        languagePickerView.dataSource = self
        regionPickerView.dataSource = self
        partialResultsStabilizationPickerView.delegate = self
        partialResultsStabilizationPickerView.dataSource = self
        piiContentIdentificationPickerView.delegate = self
        piiContentIdentificationPickerView.dataSource = self
        piiContentRedactionPickerView.delegate = self
        piiContentRedactionPickerView.dataSource = self
        
        enginePickerView.tag = 1
        languagePickerView.tag = 2
        regionPickerView.tag = 3
        partialResultsStabilizationPickerView.tag = 4
        piiContentIdentificationPickerView.tag = 5
        piiContentRedactionPickerView.tag = 6
        
        storyBoard = UIStoryboard(name: "Main", bundle: nil)

        guard let languageOptionsViewController =
                storyBoard?.instantiateViewController(withIdentifier: "languageOptions")
                as? AutomaticLanguageOptionsViewController else { return }
        self.languageOptionsViewController = languageOptionsViewController
        
        languageOptionsViewController.cancellationHandler = { [weak self] numberOfselectedLanguages in
            self?.enableAutomaticLanguageIdentificationSwitch.isOn = numberOfselectedLanguages ?? 0 > 1
        }
        
        languageOptionsViewController.selectedLanguageOptionsHandler = { [weak self] selectedLanguages in
            self?.selectedLanguageOptions = selectedLanguages ?? ""
        }
        
        languageOptionsViewController.preferredLanguageOptionHandler = { [weak self] preferredLanguage in
            self?.preferredLanguageOptions = preferredLanguage ?? ""
        }
        
        self.languageHandler = { [weak self] languageList in
            self?.languageOptionsViewController?.languages = languageList ?? [String]()
        }
        
        self.languagesDictHandler = { [weak self] mappings in
            self?.languageOptionsViewController?.languagesDict = mappings ?? [String:String]()
        }
    }
    
    @IBAction func startTranscriptionButton(_ sender: UIButton) {
        let url = self.meetingEndpointUrl.hasSuffix("/") ? self.meetingEndpointUrl : "\(self.meetingEndpointUrl)/"
        
        let contentIdentificationEnabled = !piiContentIdentificationSelected.isEmpty
        let contentRedactionEnabled = !piiContentRedactionSelected.isEmpty
        
        var identifyLanguage: Bool?
        var enablePartialResultsStabilization: Bool?
        var contentIdentificationType: String?
        var contentRedactionType: String?
        var partialResultsStabilty: String?
        var piiEntityTypes: String?
        var languageModelName: String?
        var languageOptions: String?
        var preferredLanguage: String?
        
        if contentIdentificationEnabled {
            if engineSelected == transcribeMedicalEngine {
                contentIdentificationType = transcribeMedicalContentIdentificationType
            } else {
                piiEntityTypes = piiContentIdentificationSelected
                contentIdentificationType = transcribeContentIdetificationType
            }
        }
        
        if contentRedactionEnabled {
            if engineSelected == transcribeMedicalEngine {
                contentRedactionType = nil
            } else {
                piiEntityTypes = piiContentRedactionSelected
                contentRedactionType = transcribeContentIdetificationType
            }
        }
        
        if partialResultsStabilizationOption > 0 {
            enablePartialResultsStabilization = true
            if partialResultsStabilizationOption == 1 {
                partialResultsStabilty = partialResultsStabilizationsList.last?.lowercased()
            } else {
                partialResultsStabilty = partialResultsStabilizationsList[partialResultsStabilizationOption].lowercased()
            }
        }
        
        if enableCustomLangugeModelTextFieldSwitch.isOn {
            if (customLanguageModelTextField.text?.isEmpty) == true {
                self.view.makeToast("Custom language model name cannot be empty!")
                return
            } else {
                languageModelName = customLanguageModelTextField.text
            }
        }
        
        if enableAutomaticLanguageIdentificationSwitch.isOn {
            if !preferredLanguageOptions.isEmpty {
                preferredLanguage = preferredLanguageOptions
            }
            languageOptions = selectedLanguageOptions
            identifyLanguage = true
            languageSelected = ""
        }
        
        let transcriptionStreamParams = TranscriptionStreamParams(
            contentIdentificationType: contentIdentificationType,
            contentRedactionType: contentRedactionType,
            enablePartialResultsStabilization: enablePartialResultsStabilization,
            partialResultsStability: partialResultsStabilty,
            piiEntityTypes: piiEntityTypes,
            languageModelName: languageModelName,
            identifyLanguage: identifyLanguage,
            languageOptions: languageOptions,
            preferredLanguage: preferredLanguage)

        let encodedData = try? JSONEncoder().encode(transcriptionStreamParams)
        var transcriptionStreamParamsEncoded = "{}"
        if let data = encodedData {
            transcriptionStreamParamsEncoded = String(data: data, encoding: .utf8) ?? "{}"
        }

        let encodedURL = HttpUtils.encodeStrForURL(
            str: "\(url)start_transcription?title=\(meetingId)" +
            "&language=\(languageSelected)" +
            "&region=\(regionSelected)" +
            "&engine=\(engineSelected)" +
            "&transcriptionStreamParams=\(transcriptionStreamParamsEncoded)")
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

    @IBAction func toggleCustomLanguageTextField(_ enableCustomLangugeModelTextFieldSwitch: UISwitch) {
        customLanguageModelTextField.isHidden = !enableCustomLangugeModelTextFieldSwitch.isOn
    }

    @IBAction func enablePHIIdentificaiton(_ enablePHIIdentificaitonSwitch: UISwitch) {
        piiContentIdentificationSelected = enablePHIIdentificaitonSwitch.isOn ? "ALL" : ""
    }

    @IBAction func showLanguageOptionsView(_ sender: UISwitch) {

        guard let languageOptionsViewController = languageOptionsViewController else {
            return
        }

        if sender.isOn {
            languageHandler?(transcribeLanguages)
            languagesDictHandler?(languagesDict)
            languageOptionsViewController.modalPresentationStyle = .pageSheet
            self.present(languageOptionsViewController, animated: true, completion: nil)
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
        case 4:
            return partialResultsStabilizations.count
        case 5:
            return piiContentIdentifications.count
        case 6:
            return piiContentRedactions.count
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
        case 4:
            return partialResultsStabilizationsList[row]
        case 5:
            return piiContentIdentificationDict[piiContentIdentifications[row]]
        case 6:
            return piiContentRedactionDict[piiContentRedactions[row]]
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
        case 4:
            partialResultsStabilizationTextField.text = partialResultsStabilizationsList[row]
            partialResultsStabilizationOption = row
            partialResultsStabilizationTextField.resignFirstResponder()
        case 5:
            piiContentIdentificationTextField.text = piiContentIdentificationDict[piiContentIdentifications[row]]
            piiContentIdentificationSelected = piiContentIdentifications[row]
            piiContentIdentificationTextField.resignFirstResponder()

            piiContentRedactionTextField.text = piiContentRedactionDict[piiContentRedactions[0]]
            piiContentRedactionSelected = piiContentRedactions[0]
            piiContentRedactionTextField.resignFirstResponder()

        case 6:
            piiContentRedactionTextField.text = piiContentRedactionDict[piiContentRedactions[row]]
            piiContentRedactionSelected = piiContentRedactions[row]
            piiContentRedactionTextField.resignFirstResponder()

            piiContentIdentificationTextField.text = piiContentIdentificationDict[piiContentIdentifications[0]]
            piiContentIdentificationSelected = piiContentIdentifications[0]
            piiContentIdentificationTextField.resignFirstResponder()
        default:
            return
        }

        if engineSelected == "transcribe_medical" && engineSelectedBefore == "transcribe" {
            languages = transcribeMedicalLanguages
            regions = transcribeMedicalRegions
            languageSelected = "en-US"
            languageTextField.text = languagesDict[languageSelected]
            regionSelected = "auto"
            regionTextField.text = regionsDict[regionSelected]

            partialResultsStabilizationOption = 0
            partialResultsStabilizationTextField.text = partialResultsStabilizationsList[partialResultsStabilizationOption]
            piiContentIdentificationSelected = ""
            piiContentIdentificationTextField.text = piiContentIdentificationDict[piiContentIdentificationSelected]
            piiContentRedactionSelected = ""
            piiContentIdentificationTextField.text = piiContentRedactionDict[piiContentRedactionSelected]
            customLanguageModelTextField.text = ""
            selectedLanguageOptions = ""
            preferredLanguageOptions = ""

            partialResultsStabilizationTextField.isHidden = true
            piiContentIdentificationTextField.isHidden = true
            piiContentRedactionTextField.isHidden = true
            enableCustomLangugeModelTextFieldSwitch.isOn = false
            enableCustomLangugeModelTextFieldSwitch.isHidden = true
            enableCustomLangugeModelLabel.isHidden = true
            customLanguageModelTextField.isHidden = true
            enablePHIIdentificaitonSwitch.isHidden = false
            enablePHIIdentificationLabel.isHidden = false
            enableAutomaticLanguageIdentificationLabel.isHidden = true
            enableAutomaticLanguageIdentificationSwitch.isHidden = true
            enableAutomaticLanguageIdentificationSwitch.isOn = false

        }
        if engineSelected == "transcribe" {
            languages = transcribeLanguages
            regions = transcribeRegions
            piiContentIdentifications = transcribePiiContents
            piiContentRedactions = transcribePiiContents
            if enablePHIIdentificaitonSwitch.isOn {
                piiContentIdentificationSelected = ""
            }
            partialResultsStabilizationTextField.isHidden = false
            piiContentIdentificationTextField.isHidden = false
            piiContentRedactionTextField.isHidden = false
            enableCustomLangugeModelTextFieldSwitch.isHidden = false
            enableCustomLangugeModelLabel.isHidden = false
            enableAutomaticLanguageIdentificationLabel.isHidden = false
            enableAutomaticLanguageIdentificationSwitch.isHidden = false
            enablePHIIdentificaitonSwitch.isHidden = true
            enablePHIIdentificaitonSwitch.isOn = false
            enablePHIIdentificationLabel.isHidden = true
        }
    }
}
