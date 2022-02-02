//
//  HomeTableViewCell.swift
//  IOS Challenge - TV API
//
//  Created by Kelvin Javorski Soares on 01/02/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var outsideView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outsideView.layer.cornerRadius = 15
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
