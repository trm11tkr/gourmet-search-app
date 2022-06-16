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
    
    // ロゴイメージが店舗ごとに設定されていない場合に置換する処理
    func convertImage(shop: Shop) {
        shopNameLabel.text = shop.name
        accessLabel.text = shop.access
        genreLabel.text = shop.genre.name
        if shop.logoImage ==
            "https://imgfp.hotp.jp/SYS/cmn/images/common/diary/custom/m30_img_noimage.gif" {
            logoImageView.image = UIImage(named: "tableware")
        } else {
            logoImageView.image = UIImage(url: shop.logoImage)
        }
    }
}
