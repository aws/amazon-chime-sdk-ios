//
//  AutomaticLanguageOptionViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK
import UIKit

class AutomaticLanguageOptionsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var languageOptionsTableView: UITableView!
    @IBOutlet var preferredLanguageTextField: UITextField!
    var preferredLanguagePickerView = UIPickerView()
    public var cancellationHandler: ((Int?) -> Void)?
    public var selectedLanguageOptionsHandler: ((String?) -> Void)?
    public var preferredLanguageOptionHandler: ((String?) -> Void)?
    public var languages: [String] = []
    public var languagesDict: [String: String] = [:]
    
    var preferredLanguageDropDown = ["-- Optional --"]
    var selectedLanguageOptions = ""
    var preferredLanguageSelected = ""
    var duplicatedLocaleSelected = ""
    var languageGroups: Set<String> = ["English", "Spanish", "French", "Italian", "German", "Portuguese", "Japanese", "Korean", "Chinese"]
    var duplicatedLocales: [String: Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredLanguagePickerView.delegate = self
        self.preferredLanguagePickerView.dataSource = self
        self.preferredLanguageTextField.delegate = self
        self.preferredLanguageTextField.inputView = preferredLanguagePickerView
        preferredLanguageTextField.text = preferredLanguageDropDown[0]
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    @IBAction func saveLanguageOptions(_ sender: Any) {
        if !validateLanguageOptions() {
            self.view.makeToast("Multiple language variant selected for locale: \(duplicatedLocaleSelected).\nPlease select one language locale per variant.")
            return
        }
        if preferredLanguageDropDown.count < 3 {
            self.view.makeToast("Select a minimum of 2 Language Options")
            return
        } else {
            
            let selectedIndexPaths = getSelectedIndexPaths()
            selectedLanguageOptions = ""
            for index in selectedIndexPaths.indices.dropLast() {
                let indexPath = selectedIndexPaths[index]
                selectedLanguageOptions += languages[indexPath.row] + ","
            }
            selectedLanguageOptions += languages[selectedIndexPaths.last!.row]
            selectedLanguageOptionsHandler?(selectedLanguageOptions)
            preferredLanguageOptionHandler?(preferredLanguageSelected)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func cancelLanguageOptions(_ sender: Any) {
        let selectedIndexPaths = getSelectedIndexPaths()
        for indexPath in selectedIndexPaths {
            preferredLanguageDropDown.removeAll(where: { languagesDict[languages[indexPath.row]]?.elementsEqual($0) ?? false})
            languageOptionsTableView.deselectRow(at: indexPath, animated: true)
        }
        cancellationHandler?(preferredLanguageDropDown.count)
        self.dismiss(animated: true)
    }
    
    private func getSelectedIndexPaths() -> [IndexPath] {
        var selectedIndexPaths: [IndexPath] = []
        if let indexes = languageOptionsTableView.indexPathsForSelectedRows {
            for iPath in indexes {
                selectedIndexPaths.append(iPath)
            }
        }
        return selectedIndexPaths
    }
    
    private func validateLanguageOptions() -> Bool {
        for languageGroup in duplicatedLocales.keys {
            if duplicatedLocales[languageGroup]! > 1 {
                duplicatedLocaleSelected = languageGroup
                return false
            }
        }
        return true
    }
}

extension AutomaticLanguageOptionsViewController: UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        preferredLanguageDropDown.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return preferredLanguageDropDown[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        preferredLanguageTextField.text = preferredLanguageDropDown[row]
        preferredLanguageSelected =
            ((languagesDict as NSDictionary).allKeys(for: preferredLanguageDropDown[row]).first as? String) ?? "-- Optional --"
        preferredLanguageTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        languageOptionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "languageOptionsCell")
        let cell = languageOptionsTableView.dequeueReusableCell(withIdentifier: "languageOptionsCell", for: indexPath)
        cell.textLabel?.text = languagesDict[languages[indexPath.row]]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage = languagesDict[languages[indexPath.row]]!
        preferredLanguageDropDown.append(selectedLanguage)
        preferredLanguageSelected = ""
        preferredLanguageTextField.text = preferredLanguageDropDown[0]
        updateDuplicatedLocales(selectedLanguage: selectedLanguage, count: 1)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        preferredLanguageDropDown.removeAll(where: { languagesDict[languages[indexPath.row]]?.elementsEqual($0) ?? false})
        preferredLanguageSelected = ""
        preferredLanguageTextField.text = preferredLanguageDropDown[0]
        updateDuplicatedLocales(selectedLanguage: languagesDict[languages[indexPath.row]]!, count: -1)
    }
    
    private func updateDuplicatedLocales(selectedLanguage: String, count: Int) {
        for languageGroup in languageGroups {
            if selectedLanguage.contains(languageGroup) {
                duplicatedLocales[languageGroup, default: 0] += count
            }
        }
    }
    
}
