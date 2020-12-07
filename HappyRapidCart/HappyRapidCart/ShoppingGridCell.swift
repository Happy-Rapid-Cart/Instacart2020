//
//  ShoppingGridCell.swift
//  HappyRapidCart
//
//  Created by Maria Shehata on 12/4/20.
//

import UIKit

protocol ProductCellDelegate {
    func productClicked(_ tag: Int)
}

class ShoppingGridCell: UICollectionViewCell {
    var delegate: ProductCellDelegate?
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var productSizer: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addCartButtonAction(_ sender: UIButton) {
        print("clicked")
        self.delegate?.productClicked(sender.tag)
    }
}
