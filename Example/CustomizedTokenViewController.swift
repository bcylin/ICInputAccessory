//
//  CustomizedTokenViewController.swift
//  Example
//
//  Created by Ben on 11/03/2016.
//  Copyright © 2016 Polydice, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import ICInputAccessory

class CustomizedTokenViewController: UIViewController, TokenFieldDelegate {

  private let tokenField = CustomizedTokenField()
  private let textView = UITextView()

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    view.backgroundColor = UIColor.white
    textView.isEditable = false
    textView.isSelectable = false
    textView.text = "[\n\n]"
    textView.font = UIFont.preferredFont(forTextStyle: .subheadline)
    textView.frame = view.bounds.insetBy(dx: 10, dy: 10)
    textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(textView)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.barTintColor = UIColor(red: 0.96, green: 0.48, blue: 0.4, alpha: 1)
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barStyle = .black

    let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: .dismiss)
    cancelBarButton.tintColor = UIColor.white
    navigationItem.rightBarButtonItem = cancelBarButton

    navigationItem.titleView = {
      if #available(iOS 11, *) {
        tokenField.translatesAutoresizingMaskIntoConstraints = false
        let views = ["field": tokenField]
        let metrics = ["padding": 7]
        let containerView = UIView()
        containerView.addSubview(tokenField)
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[field]-padding-|", options: [], metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[field]-padding-|", options: [], metrics: metrics, views: views))
        return containerView
      } else {
        return tokenField
      }
    }()
    tokenField.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    _ = tokenField.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    _ = tokenField.resignFirstResponder()
    textView.endEditing(true)
  }

  // MARK: - TokenFieldDelegate

  func tokenFieldDidBeginEditing(_ tokenField: TokenField) {
    print(#function)
  }

  func tokenFieldDidEndEditing(_ tokenField: TokenField) {
    print(#function)
  }

  func tokenFieldWillReturn(_ tokenField: TokenField) {
    print(#function)
  }

  func tokenField(_ tokenField: TokenField, didChangeInputText text: String) {
    print("Typing \"\(text)\"")
  }

  func tokenField(_ tokenField: TokenField, shouldCompleteText text: String) -> Bool {
    print("Should add \"\(text)\"?")
    return text != "42"
  }

  func tokenField(_ tokenField: TokenField, didCompleteText text: String) {
    print("Added \"\(text)\"")
    updateTexts()
  }

  func tokenField(_ tokenField: TokenField, didDeleteText text: String, atIndex index: Int) {
    print("Deleted \"\(text)\"")
    updateTexts()
  }

  func tokenField(_ tokenField: TokenField, subsequentDelimiterForCompletedText text: String) -> String {
    return " ,"
  }

  // MARK: - UIResponder Callbacks

  @objc fileprivate func dismiss(_ sender: UIBarButtonItem) {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }

  // MARK: - Private Methods

  private func updateTexts() {
    let tokens = tokenField.texts.map { "\"" + $0 + "\"" } .joined(separator: ",\n  ")
    textView.text = "[\n  " + tokens + "\n]"
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let dismiss = #selector(CustomizedTokenViewController.dismiss(_:))
}
