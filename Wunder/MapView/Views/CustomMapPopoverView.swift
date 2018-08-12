//
//  CustomMapPopoverView.swift
//  Wunder
//
//  Created by Soham Bhowmik on 11/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import UIKit

protocol CustomMapPopoverDelegate: class {
    func didTapCustomMapPopover(_ popover: CustomMapPopoverView?)
}

class CustomMapPopoverView: UIView {

    @IBOutlet weak var carNameLabel: UILabel!
    weak var delegate: CustomMapPopoverDelegate? = nil
    
    @IBAction func popoverTapped(_ sender: UITapGestureRecognizer) {
        delegate?.didTapCustomMapPopover(self)
    }
    
}
