//
//  SearchListTableViewCell.swift
//  VortoSearch
//
//  Created by Boyanapalli, Uday (Proagrica) on 5/21/21.
//  Copyright © 2021 Uday Boyanapalli. All rights reserved.
//

import UIKit

class SearchListTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
