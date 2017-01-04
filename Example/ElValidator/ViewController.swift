//
//  ViewController.swift
//  ElValidator
//
//  Created by Victor Carmouze on 11/30/2015.
//  Copyright (c) 2015 Victor Carmouze. All rights reserved.
//

import UIKit
import ElValidator

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldDate: TextFieldValidator!
    @IBOutlet weak var textFieldNumeric: TextFieldValidator!
    @IBOutlet weak var textFieldMax: TextFieldValidator!
    @IBOutlet weak var textFieldList: TextFieldValidator!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var activeTextField: TextFieldValidator?
    
    var validationBlock:((_: [Error]) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        validationBlock = { (errors: [Error]) -> Void in
            if let error = errors.first {
                print(error)
                self.activeTextField?.textColor = .red;
            } else {
                self.activeTextField?.textColor = .green
            }
        }

        configureDateTextField()
        configureNumericTextField()
        configureMaxTextField()
        configureListTextField()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.alwaysBounceVertical = true
        registerForKeyboardNotifications()
    }

    func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
            selector: #selector(keyboardWillBeShown),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        notificationCenter.addObserver(self,
            selector: #selector(keyboardWillBeHidden),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField as? TextFieldValidator
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        activeTextField = nil;
        
        return true
    }
    
    func configureDateTextField() {
        textFieldDate.delegate = self
        let df = DateFormatter()
        df.dateStyle = .short
        textFieldDate.addValidator(DateValidator( validationEvent: .ValidationPerCharacter, dateFormatter: df))
        textFieldDate.validationBlock = validationBlock
    }
    
    func configureNumericTextField()
    {
        textFieldNumeric.delegate = self;
        textFieldNumeric.addValidator(PatternValidator(validationEvent: [.ValidationPerCharacter, .ValidationAllowBadCharacters], pattern: .Numeric))
        textFieldNumeric.validationBlock = validationBlock
    }
    
    func configureMaxTextField() {
        textFieldMax.delegate = self
        textFieldMax.addValidator(LenghtValidator(validationEvent: .ValidationPerCharacter, max: 10))
        textFieldMax.validationBlock = validationBlock
    }
    
    func configureListTextField() {
        textFieldList.delegate = self
        textFieldList.addValidator(ListValidator(validationEvent: .ValidationPerCharacter, correctValues: ["Swift", "ObjectiveC"]))
        textFieldList.validationBlock = validationBlock
    }

    func keyboardWillBeShown(sender: NSNotification) {
        if let info = sender.userInfo,
            let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardSize = value.cgRectValue.size
            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

