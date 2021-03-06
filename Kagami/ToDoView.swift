//
//  ToDoView.swift
//  Kagami
//
//  Created by Annie Tung on 3/7/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import FirebaseDatabase

class ToDoView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    var database: FIRDatabaseReference!
    var activeTextField: UITextField?
    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: nil)
    var gradientLayer: CAGradientLayer!
    let userDefault = UserDefaults.standard
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createGradientLayer()
        self.layer.cornerRadius = 9
        self.database = FIRDatabase.database().reference().child("toDos").child("lastest")
        textFieldOne.delegate = self
        textFieldTwo.delegate = self
        textFieldThree.delegate = self
        setupViewHierarchy()
        configureConstraints()
        loadUserDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View Hierarchy & constraints
    func setupViewHierarchy() {
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        self.addSubview(textFieldOne)
        self.addSubview(textFieldTwo)
        self.addSubview(textFieldThree)
        self.addSubview(headerImage)
        self.addSubview(checkBoxOne)
        self.addSubview(checkBoxTwo)
        self.addSubview(checkBoxThree)
        
        checkBoxOne.addTarget(self, action: #selector(checkOffItemOne), for: .touchUpInside)
        checkBoxTwo.addTarget(self, action: #selector(checkOffItemTwo), for: .touchUpInside)
        checkBoxThree.addTarget(self, action: #selector(checkOffItemThree), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(addToMirror), for: .touchUpInside)
    }
    
    func configureConstraints() {
        doneButton.snp.makeConstraints { (view) in
            view.right.equalTo(self.snp.right).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        
        cancelButton.snp.makeConstraints { (view) in
            view.left.equalTo(self.snp.left).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        
        headerImage.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(self.snp.top).inset(50)
        }
        
        textFieldOne.snp.makeConstraints { (field) in
            field.top.equalTo(headerImage.snp.bottom).offset(40)
            field.right.equalTo(self.snp.right)
            field.height.equalTo(self.snp.height).multipliedBy(0.1)
            field.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
        
        textFieldTwo.snp.makeConstraints { (field) in
            field.top.equalTo(textFieldOne.snp.bottom).offset(40)
            field.right.equalTo(self.snp.right)
            field.height.equalTo(self.snp.height).multipliedBy(0.1)
            field.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
        
        textFieldThree.snp.makeConstraints { (field) in
            field.top.equalTo(textFieldTwo.snp.bottom).offset(40)
            field.right.equalTo(self.snp.right)
            field.height.equalTo(self.snp.height).multipliedBy(0.1)
            field.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
        
        checkBoxOne.snp.makeConstraints { (make) in
            make.right.equalTo(textFieldOne.snp.left)
            make.left.equalTo(self.snp.left)
            make.top.equalTo(textFieldOne.snp.top)
            make.bottom.equalTo(textFieldOne.snp.bottom)
        }
        
        checkBoxTwo.snp.makeConstraints { (make) in
            make.right.equalTo(textFieldTwo.snp.left)
            make.left.equalTo(self.snp.left)
            make.top.equalTo(textFieldTwo.snp.top)
            make.bottom.equalTo(textFieldTwo.snp.bottom)
        }
        
        checkBoxThree.snp.makeConstraints { (make) in
            make.right.equalTo(textFieldThree.snp.left)
            make.left.equalTo(self.snp.left)
            make.top.equalTo(textFieldThree.snp.top)
            make.bottom.equalTo(textFieldThree.snp.bottom)
        }
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 650))
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red:0.56, green:0.62, blue:0.67, alpha:1.0).cgColor, UIColor(red:0.93, green:0.95, blue:0.95, alpha:1.0).cgColor]
        gradientLayer.locations = [0.0 , 1.0]
        self.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Settings Methods
    func addToMirror() {
        // item 1
        let item1 = ToDo(title: textFieldOne.text!, completed: false)
        let itemDict1 = item1.asDictionary
        let itemOneDatabaseRef = self.database.child("1")
        itemOneDatabaseRef.setValue(itemDict1)
        userDefault.setValue(textFieldOne.text, forKey: "item one")
        
        if checkBoxOne.image(for: .normal) == UIImage(named:"Ok-checked") {
            let item = ToDo(title: textFieldOne.text!, completed: true)
            let itemDict = item.asDictionary
            itemOneDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item one completed")
        }
        else {
            let item = ToDo(title: textFieldOne.text!, completed: false)
            let itemDict = item.asDictionary
            itemOneDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item one completed")
        }
        
        // item 2
        let item2 = ToDo(title: textFieldTwo.text!, completed: false)
        let itemDict2 = item2.asDictionary
        let itemTwoDatabaseRef = self.database.child("2")
        itemTwoDatabaseRef.setValue(itemDict2)
        userDefault.setValue(textFieldTwo.text, forKey: "item two")
        
        if checkBoxTwo.image(for: .normal) == UIImage(named:"Ok-checked") {
            let item = ToDo(title: textFieldTwo.text!, completed: true)
            let itemDict = item.asDictionary
            itemTwoDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item two completed")
        }
        else {
            let item = ToDo(title: textFieldTwo.text!, completed: false)
            let itemDict = item.asDictionary
            itemTwoDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item two completed")
        }
        
        // item 3
        let item3 = ToDo(title: textFieldThree.text!, completed: false)
        let itemDict3 = item3.asDictionary
        let itemThreeDatabaseRef = self.database.child("3")
        itemThreeDatabaseRef.setValue(itemDict3)
        userDefault.setValue(textFieldThree.text, forKey: "item three")
        
        if checkBoxThree.image(for: .normal) == UIImage(named:"Ok-checked") {
            let item = ToDo(title: textFieldThree.text!, completed: true)
            let itemDict = item.asDictionary
            itemThreeDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item three completed")
        } else {
            let item = ToDo(title: textFieldThree.text!, completed: false)
            let itemDict = item.asDictionary
            itemThreeDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item three completed")
        }
    }
    
    func checkOffItemOne() {
        if checkBoxOne.image(for: .normal) == UIImage(named: "Ok-checked") {
            checkBoxOne.setImage(UIImage(named: "Ok-unchecked"), for: .normal)
        }
        else {
            checkBoxOne.setImage(UIImage(named: "Ok-checked"), for: .normal)
        }
    }
    
    func checkOffItemTwo() {
        if checkBoxTwo.image(for: .normal) == UIImage(named: "Ok-checked") {
            checkBoxTwo.setImage(UIImage(named: "Ok-unchecked"), for: .normal)
        }
        else {
            checkBoxTwo.setImage(UIImage(named: "Ok-checked"), for: .normal)
        }
    }
    
    func checkOffItemThree() {
        if checkBoxThree.image(for: .normal) == UIImage(named: "Ok-checked") {
            checkBoxThree.setImage(UIImage(named: "Ok-unchecked"), for: .normal)
        }
        else {
            checkBoxThree.setImage(UIImage(named: "Ok-checked"), for: .normal)
        }
    }
    
    func loadUserDefaults() {
        if userDefault.object(forKey: "item one") != nil {
            textFieldOne.text = userDefault.object(forKey: "item one") as? String
        }
        if userDefault.object(forKey: "item one completed") != nil {
            let isCompleted = userDefault.object(forKey: "item one completed") as! Bool
            
            if isCompleted {
                checkBoxOne.setImage(UIImage(named:"Ok-checked"), for: .normal)
            }
            else {
                checkBoxOne.setImage(UIImage(named:"Ok-unchecked"), for: .normal)
            }
        }
        
        if userDefault.object(forKey: "item two") != nil {
            textFieldTwo.text = userDefault.object(forKey: "item two") as? String
        }
        if userDefault.object(forKey: "item two completed") != nil {
            let isCompleted = userDefault.object(forKey: "item two completed") as! Bool
            
            if isCompleted {
                checkBoxTwo.setImage(UIImage(named:"Ok-checked"), for: .normal)
            }
            else {
                checkBoxTwo.setImage(UIImage(named:"Ok-unchecked"), for: .normal)
            }
        }
        
        if userDefault.object(forKey: "item three") != nil {
            textFieldThree.text = userDefault.object(forKey: "item three") as? String
        }
        
        if userDefault.object(forKey: "item three completed") != nil {
            let isCompleted = userDefault.object(forKey: "item three completed") as! Bool
            
            if isCompleted {
                checkBoxThree.setImage(UIImage(named:"Ok-checked"), for: .normal)
            }
            else {
                checkBoxThree.setImage(UIImage(named:"Ok-unchecked"), for: .normal)
            }
        }
    }
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard activeTextField == textField, activeTextField?.text != "" else {
            textField.resignFirstResponder()
            return false
        }
        
        self.endEditing(true)
        return true
    }
    
    // MARK: - Lazy Instantiates
    lazy var doneButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Ok-50")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Cancel-50")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var textFieldOne: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = .clear
        field.textColor = ColorPalette.whiteColor
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        field.layer.cornerRadius = 9
        field.tag = 1
        field.font = UIFont(name: "Code-Pro-Demo", size: 22)
        field.placeholder = "To Do"
        return field
    }()
    
    lazy var textFieldTwo: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = .clear
        field.textColor = ColorPalette.whiteColor
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        field.layer.cornerRadius = 9
        field.tag = 2
        field.font = UIFont(name: "Code-Pro-Demo", size: 22)
        field.placeholder = "To Do"
        return field
    }()
    
    lazy var textFieldThree: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = .clear
        field.textColor = ColorPalette.whiteColor
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        field.layer.cornerRadius = 9
        field.tag = 3
        field.font = UIFont(name: "Code-Pro-Demo", size: 22)
        field.placeholder = "To Do"
        return field
    }()
    
    lazy var checkBoxOne: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"Ok-unchecked"), for: .normal)
        return button
    }()
    
    lazy var checkBoxTwo: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"Ok-unchecked"), for: .normal)
        return button
    }()
    
    lazy var checkBoxThree: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"Ok-unchecked"), for: .normal)
        return button
    }()
    
    lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "todoheader")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}
