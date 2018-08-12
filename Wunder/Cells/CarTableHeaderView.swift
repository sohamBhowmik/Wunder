//
//  CarTableHeaderView.swift
//  Wunder
//
//  Created by Soham Bhowmik on 11/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import UIKit

protocol CarTableHeaderDelegate: class {
    func textFieldDidBeginEditing(_ textField: UITextField, inCarTableHeaderView headerView: CarTableHeaderView)
    func textFieldDidEndEditing(_ textField: UITextField, inCarTableHeaderView headerView: CarTableHeaderView)
    func textFieldShouldReturn(_ textField: UITextField, inCarTableHeaderView headerView: CarTableHeaderView)
    func changeCharactersInRange(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, inCarTableHeaderView headerView: CarTableHeaderView)
}

class CarTableHeaderView: UIView {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelSearchButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: CarTableHeaderDelegate? = nil
    
    override func awakeFromNib() {
        cancelSearchButtonWidthConstraint.constant = 0
        searchTextField.delegate = self
    }
    
   
    
    @IBAction func cancelSearch(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        searchTextField.text = ""
        hideSearchCancelButton()
    }
    
}

extension CarTableHeaderView: UITextFieldDelegate
{
    //Text Field Delegates
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
        delegate?.textFieldDidBeginEditing(textField, inCarTableHeaderView: self)
        displaySearchCancelButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldReturn(textField, inCarTableHeaderView: self)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField, inCarTableHeaderView: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.changeCharactersInRange(textField, shouldChangeCharactersIn: range, replacementString: string, inCarTableHeaderView: self)
        
        return true
    }
    
    //Search Cancel Button Methods
    func displaySearchCancelButton()
    {
        self.cancelSearchButtonWidthConstraint.constant = 60
        UIView.animate(withDuration: 0.3) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    func hideSearchCancelButton()
    {
        self.cancelSearchButtonWidthConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}
