//
//  AutomaticLanguageDetectionViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK
import UIKit

class AutomaticLanguageDetectionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var languageDetectionTableView: UITableView!
    @IBOutlet var preferredLanguagesTextField: UITextField!
    var preferredLanguagesPickerView = UIPickerView()
    public var cancellationHandler: ((Int?) -> Void)?
    public var selectedLanguageOptionsHandler: ((String?) -> Void)?
    public var preferredLanguageOptionHandler: ((String?) -> Void)?
    public var languages: [String] = []
    public var languagesDict: [String: String] = [:]
    
    var preferredLanguages = ["-- Optional --"]
    var selectedLanguages = " "
    var preferredLanguageSelected = " "

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredLanguagesPickerView.delegate = self
        self.preferredLanguagesPickerView.dataSource = self
        self.preferredLanguagesTextField.delegate = self
        self.preferredLanguagesTextField.inputView = preferredLanguagesPickerView
        preferredLanguagesTextField.text = preferredLanguages[0]
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    @IBAction func saveLanguageDetectionOptions(_ sender: Any) {
        if preferredLanguages.count < 3 {
            self.view.makeToast("Must select at least two languages!")
            return
        } else {
            
            let selectedIndexPaths = getSelectedIndexPaths()
            selectedLanguages = ""
            for index in selectedIndexPaths.indices.dropLast() {
                let indexPath = selectedIndexPaths[index]
                selectedLanguages += languages[indexPath.row] + ","
            }
            selectedLanguages += languages[selectedIndexPaths.last!.row]
            selectedLanguageOptionsHandler!(selectedLanguages)
            preferredLanguageOptionHandler!(preferredLanguageSelected)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func cancelLanguageDetectionOptions(_ sender: Any) {
        let selectedIndexPaths = getSelectedIndexPaths()
        for indexPath in selectedIndexPaths {
            preferredLanguages.removeAll(where: { languagesDict[languages[indexPath.row]]!.elementsEqual($0) })
            languageDetectionTableView.deselectRow(at: indexPath, animated: true)
        }
        cancellationHandler!(preferredLanguages.count)
        self.dismiss(animated: true)
    }
    
    private func getSelectedIndexPaths() -> [IndexPath] {
        var selectedIndexPaths: [IndexPath] = []
        if let indexes = languageDetectionTableView.indexPathsForSelectedRows {
            for iPath in indexes {
                selectedIndexPaths.append(iPath)
            }
        }
        return selectedIndexPaths
    }
}

extension AutomaticLanguageDetectionViewController: UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        preferredLanguages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return preferredLanguages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        preferredLanguagesTextField.text = preferredLanguages[row]
        preferredLanguageSelected = ((languagesDict as NSDictionary).allKeys(for: preferredLanguages[row]).first as? String)!
        preferredLanguagesTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = languageDetectionTableView.dequeueReusableCell(withIdentifier: "languageDetectionCell", for: indexPath)
        cell.textLabel?.text = languagesDict[languages[indexPath.row]]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        preferredLanguages.append(languagesDict[languages[indexPath.row]]!)
        preferredLanguageSelected = ""
        preferredLanguagesTextField.text = preferredLanguages[0]
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        preferredLanguages.removeAll(where: { languagesDict[languages[indexPath.row]]!.elementsEqual($0) })
        preferredLanguageSelected = ""
        preferredLanguagesTextField.text = preferredLanguages[0]
    }
    
}
