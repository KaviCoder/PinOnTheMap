//
//  KBUIViewController.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 8/7/21.
//

import Foundation
import UIKit

class KBUIViewController: UIViewController {
    
    //Constraint of UIView(Holder) bottom with the original View
@IBOutlet var bottomConstraintForKeyboard: NSLayoutConstraint!

@objc func keyboardWillShow(sender: NSNotification) {
    let keyBoardInfo = sender.userInfo!
    let s: TimeInterval = (keyBoardInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
    let k = (keyBoardInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
    bottomConstraintForKeyboard.constant = k
   
    UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
}

@objc func keyboardWillHide(sender: NSNotification) {
    let info = sender.userInfo!
    let s: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
    bottomConstraintForKeyboard.constant = 0
    UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
}

@objc func clearKeyboard() {
    view.endEditing(true)
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
          self.view.endEditing(true)
    }}

func keyboardNotifications() {
    NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification,
        object: nil)
    NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardWillHide),
        name: UIResponder.keyboardWillHideNotification,
        object: nil)
}

override func viewDidLoad() {
    super.viewDidLoad()
    keyboardNotifications()
    let t = UITapGestureRecognizer(target: self, action: #selector(clearKeyboard))
    view.addGestureRecognizer(t)
    t.cancelsTouchesInView = false
}
}
