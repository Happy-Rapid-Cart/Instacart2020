//
//  StoreCell.swift
//  HappyRapidCart
//
//  Created by Maria Shehata on 11/26/20.
//

import UIKit

class StoreCell: UITableViewCell {


    @IBOutlet weak var storeView: UIView!
    
    @IBOutlet weak var storeImage: UIImageView!
    
    @IBOutlet weak var storeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
