import UIKit

class ShopDetailViewController: UIViewController {
    
    @IBOutlet weak var shopTitle: UINavigationItem!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var access: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var open: UILabel!
    @IBOutlet weak var catchPhrase: UILabel!
    
    
    
    @IBOutlet weak var shopImage: UIImageView!
    
    var shop: Shop!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopTitle.title = shop.name
        shopName.text = shop.name
        access.text = shop.access
        address.text = shop.address
        open.text = shop.open
        catchPhrase.text = shop.genre.`catch`
        shopImage.image = UIImage(url: shop.photo.mobile.mobileImage)
    }
}
