//
//  PurchaseDetailDataLineTableViewCell.swift
//  Q6IosClient
//
//  Created by yang wulong on 11/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseDetailDataLineTableViewCell: UITableViewCell {

  
    @IBOutlet weak var lblTaxCodeName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}