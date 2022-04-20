//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import UIKit

class TranslateViewController: UIViewController {

    // MARK: - Properties
    var listSupportLanguages = TranslateLanguagesSupport()
    var langSourceSelected = "fr"
    var langTargetSelected = "en"
    var reverseTranslate = false

    // MARK: - IBOutlet
    @IBOutlet weak var sourceActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var translatedActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reverseButton: UIButton!
    @IBOutlet weak var targetUIViewTable: UIView!
    @IBOutlet weak var targetTableView: UITableView!
    @IBOutlet weak var sourceUIViewTableView: UIView!
    @IBOutlet weak var sourceTableView: UITableView!
    @IBOutlet weak var langSourceButton: UIButton!
    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var langTargetButton: UIButton!
    @IBOutlet weak var translatedTexView: UITextView!
    @IBOutlet weak var translatedUIView: UIView!
    @IBOutlet weak var translatedButton: UIButton!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        callGetSupportedLanguages()
        initializeView()
    }

    // MARK: - IBOAction
    @IBAction func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        hideUIViewTableView()
        sourceTextView.resignFirstResponder()
        translatedTexView.resignFirstResponder()
    }

    @IBAction func sourceLangActionButton() {
        sourceUIViewTableView.isHidden = false
    }

    @IBAction func changeTargetLangAction() {
        targetUIViewTable.isHidden = false
    }
    @IBAction func reverseButtonAction() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn) {
            if self.reverseTranslate {
                self.reverseTranslate = false
                self.reverseButton.transform = .identity
            } else {
                self.reverseTranslate = true
                self.reverseButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        }
    }

    @IBAction func translateAction() {
        var text = ""
        if reverseTranslate {
            text = translatedTexView.text
            showSourceActivity(shown: true)
            callGetTranslation(langSource: langTargetSelected, langTarget: langSourceSelected, text: text)
        } else {
            text = sourceTextView.text
            showTranslateActivity(shown: true)
            callGetTranslation(langSource: langSourceSelected, langTarget: langTargetSelected, text: text)
        }
    }

    // MARK: - private func
    private func callGetTranslation(langSource: String, langTarget: String, text: String?) {

        TranslateService.shared.getTranslation(text: text,
                                               langSource: langSource,
                                               langTarget: langTarget) { result in

            switch result {
            case .success(let translatedText):

                let translation = translatedText.data.translations.first?.translatedText
                if self.reverseTranslate {
                    self.showSourceActivity(shown: false)
                    self.sourceTextView.text = translation
                } else {
                    self.showTranslateActivity(shown: false)
                    self.translatedTexView.text = translation
                }

            case .failure(let error):
                self.presentAlert(alertMessage: error.localizedDescription)
            }
        }
    }

    private func callGetSupportedLanguages() {
        TranslateService.shared.getSupportedLanguage { result in
            switch result {
            case .success(let supportedLangList):
                self.listSupportLanguages.listSupportLanguages = supportedLangList.data.languages
                self.sourceTableView.reloadData()
                self.targetTableView.reloadData()
            case .failure(let error):
                self.presentAlert(alertMessage: error.localizedDescription)
            }
        }
    }

    private func initializeView() {
        hideUIViewTableView()
        translatedUIView.isHidden = true
    }

    private func showSourceActivity(shown: Bool) {
        if reverseTranslate {
            sourceActivityIndicator.isHidden = !shown
            sourceTextView.isHidden = shown
        }
    }

    private func showTranslateActivity(shown: Bool) {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut) {
            self.translatedUIView.isHidden = false
        }
        if !reverseTranslate {
            translatedActivityIndicator.isHidden = !shown
            translatedTexView.isHidden = shown
        }

    }

    private func hideUIViewTableView() {
        sourceUIViewTableView.isHidden = true
        targetUIViewTable.isHidden = true
    }

    private func presentAlert (alertTitle title: String = "Error", alertMessage message: String,
                               buttonTitle titleButton: String = "Ok",
                               alertStyle style: UIAlertAction.Style = .cancel ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - TableView DataSource
extension TranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listSupportLanguages.listSupportLanguages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let supportLang = listSupportLanguages.listSupportLanguages[indexPath.row]
        var  cell = UITableViewCell()
        switch tableView {
        case sourceTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath)
        case targetTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "TargetCell", for: indexPath)
        default:
            return cell
        }

        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = supportLang.name
            content.secondaryText = supportLang.language
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = supportLang.name
            cell.detailTextLabel?.text = supportLang.language
        }
        return cell
    }
}

// MARK: - TableView Delegate
extension TranslateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let langSelected = listSupportLanguages.listSupportLanguages[indexPath.row]
        switch tableView {
        case sourceTableView:
            langSourceSelected = langSelected.language
            langSourceButton.setTitle(langSelected.name, for: .normal)
            sourceUIViewTableView.isHidden = true
        case targetTableView:
            langTargetSelected = langSelected.language
            langTargetButton.setTitle(langSelected.name, for: .normal)
            targetUIViewTable.isHidden = true
        default:
            return
        }
    }
}
