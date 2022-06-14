//
//  ShopListTableViewCell.swift
//  GourmetSearch
//
//  Created by moritarikuto on 2022/06/14.
//

import UIKit

class ShopListTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ShopListTableViewCell"
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: ShopListTableViewCell.reuseIdentifier, bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
