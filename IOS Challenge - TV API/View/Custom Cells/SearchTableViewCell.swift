//
//  SearchTableViewCell.swift
//  IOS Challenge - TV API
//
//  Created by Kelvin Javorski Soares on 31/01/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
