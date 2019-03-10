//
//  SearchCell.swift
//  AutoAddress
//
//  Created by Mike Jones on 3/7/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configureCellForDisplay(titleText:String, detailText:String) {
        self.titleLabel.text = titleText
        self.detailLabel.text = detailText
    }
}
