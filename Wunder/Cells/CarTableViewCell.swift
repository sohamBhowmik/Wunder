//
//  CarTableViewCell.swift
//  Wunder
//
//  Created by Soham Bhowmik on 10/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var vinLabel: UILabel!
    @IBOutlet weak var engineLabel: UILabel!
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var exteriorLabel: UILabel!
    @IBOutlet weak var interiorLabel: UILabel!
    @IBOutlet weak var fuelPercentHolderVoew: UIView!
    @IBOutlet weak var fuelPecentageView: UIView!
    @IBOutlet weak var fuelPercentageViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupUI()
    {
        bgView.layer.cornerRadius = 3.0
        bgView.layer.borderWidth = 1.0
        bgView.layer.borderColor = UIColor.darkGray.cgColor
        
        self.selectionStyle = .none
        
        self.fuelPercentHolderVoew.layer.borderColor = UIColor(red: 55.0/255.0, green: 137.0/255.0, blue: 247.0/255.0, alpha: 1.0).cgColor
        self.fuelPercentHolderVoew.layer.borderWidth = 1.0
        self.fuelPecentageView.layer.cornerRadius = 3.0
    }
}
