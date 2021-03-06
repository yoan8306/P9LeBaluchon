//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import UIKit

class TranslateViewController: UIViewController {

    // MARK: - Properties
    var translateManager = TranslationManager()

    // MARK: - IBOutlet
    @IBOutlet weak var sourceActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var translatedActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sourceUIView: UIView!
    @IBOutlet weak var inverseButton: UIButton!
    @IBOutlet weak var targetUIViewTable: UIView!
    @IBOutlet weak var targetTableView: UITableView!
    @IBOutlet weak var sourceUIViewTableView: UIView!
    @IBOutlet weak var sourceTableView: UITableView!
    @IBOutlet weak var langSourceButton: UIButton!
    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var langTargetButton: UIButton!
    @IBOutlet weak var translatedTexView: UITextView!
    @IBOutlet weak var translatedUIView: UIView!
    @IBOutlet weak var dissmissKeyboardTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var translatedButton: UIButton!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getSupportedLanguages()
        initializeView()
    }

    // MARK: - IBOAction
    @IBAction func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        sourceTextView.resignFirstResponder()
        translatedTexView.resignFirstResponder()
    }

    /// Show tableView language supported
    @IBAction func sourceLanguageAction() {
        sourceUIViewTableView.isHidden = false
        targetUIViewTable.isHidden = true
        dissmissKeyboardTapGesture.isEnabled = false
    }

    /// Show tableView language supported
    @IBAction func targetLanguageAction() {
        targetUIViewTable.isHidden = false
        sourceUIViewTableView.isHidden  = true
        dissmissKeyboardTapGesture.isEnabled = false
    }

    /// Inverse the meaning of the translation
    @IBAction func inverseButtonAction() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn) {
            if self.translateManager.inverseTranslate {
                self.inverseButton.transform = .identity
            } else {
                self.inverseButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            self.translateManager.inverseTranslation()
        }
    }

    /// Call translate service
    @IBAction func translateAction() {
        var text = ""
        if translateManager.inverseTranslate {
            text = translatedTexView.text
            showSourceActivity(shown: true)
            getTranslation(source: translateManager.secondLanguageSelected,
                           target: translateManager.firstLanguageSelected, text: text)
        } else {
            text = sourceTextView.text
            showTranslatedActivity(shown: true)
            getTranslation(source: translateManager.firstLanguageSelected,
                           target: translateManager.secondLanguageSelected, text: text)
        }
    }

    // MARK: - private func

    /// Call service for get translation
    /// - Parameters:
    ///   - source: Origine write texte
    ///   - target: What language user get translate
    ///   - text: the texte to be translated
    private func getTranslation(source: String, target: String, text: String?) {
        TranslateService.shared.getTranslation(text: text,
                                               langSource: source,
                                               langTarget: target) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let translatedText):

                let translation = translatedText.data.translations.first?.translatedText
                if self.translateManager.inverseTranslate {
                    self.showSourceActivity(shown: false)
                    self.sourceTextView.text = translation
                } else {
                    self.showTranslatedActivity(shown: false)
                    self.translatedTexView.text = translation
                }

            case .failure(let error):
                self.presentAlert(alertMessage: error.localizedDescription)
            }
        }
    }

    private func getSupportedLanguages() {
        TranslateService.shared.getSupportedLanguages {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let supportedLangList):
                self.translateManager.listSupportLanguages = supportedLangList.data.languages
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
        sourceUIView.layer.cornerRadius = 8
        translatedUIView.layer.cornerRadius = 8
        langSourceButton.layer.cornerRadius = 8
        langTargetButton.layer.cornerRadius = 8
        translatedButton.layer.cornerRadius = 8
    }

    /// Hide sourceTextView texte view and show activity indicator
    /// - Parameter shown: show or hide activity indicator
    private func showSourceActivity(shown: Bool) {
        if translateManager.inverseTranslate {
            sourceActivityIndicator.isHidden = !shown
            sourceTextView.isHidden = shown
        }
    }
    /// Hide translatedTextView texte view and show activity indicator
    /// - Parameter shown: show or hide activity indicator
    private func showTranslatedActivity(shown: Bool) {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut) {
            self.translatedUIView.isHidden = false
        }
        if !translateManager.inverseTranslate {
            translatedActivityIndicator.isHidden = !shown
            translatedTexView.isHidden = shown
        }

    }

    /// Hide all tablesView
    private func hideUIViewTableView() {
        sourceUIViewTableView.isHidden = true
        targetUIViewTable.isHidden = true
    }
}

// MARK: - TableView DataSource
extension TranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        translateManager.listSupportLanguages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let supportLang = translateManager.listSupportLanguages[indexPath.row]
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
        let langSelected = translateManager.listSupportLanguages[indexPath.row]
        dissmissKeyboardTapGesture.isEnabled = true

        switch tableView {
        case sourceTableView:
            translateManager.firstLanguageSelected = langSelected.language
            langSourceButton.setTitle(langSelected.name, for: .normal)
            sourceUIViewTableView.isHidden = true
        case targetTableView:
            translateManager.secondLanguageSelected = langSelected.language
            langTargetButton.setTitle(langSelected.name, for: .normal)
            targetUIViewTable.isHidden = true
        default:
            return
        }
    }
}
