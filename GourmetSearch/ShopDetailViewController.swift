import UIKit

class ShopDetailViewController: UIViewController {
    
    @IBOutlet weak var shopTitle: UINavigationItem!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var access: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var open: UILabel!
    @IBOutlet weak var catchPhrase: UILabel!
    
    
    
    @IBOutlet weak var shopImage: UIImageView!
    
    var shop: Shop?
    var shopLatitude: Double?
    var shopLongitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopTitle.title = shop?.name
        shopName.text = shop?.name
        access.text = shop?.access
        address.text = shop?.address
        open.text = shop?.open
        catchPhrase.text = shop?.genre.`catch`
        if let url = shop?.photo.mobile.mobileImage {
            shopImage.image = UIImage(url: url)
        }
        if let latitude = shop?.latitude,
           let longitude = shop?.longitude {
            shopLatitude = latitude
            shopLongitude = longitude
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMapViewController" {
            if let nextViewController = segue.destination as? MapViewController,
               let shopLatitude = shopLatitude,
               let shopLongitude = shopLongitude {
                nextViewController.shopLatitude = shopLatitude
                nextViewController.shopLongitude = shopLongitude
                nextViewController.shopName = shop?.name
                nextViewController.shopAddress = shop?.address
            }
        }
    }
    
    @IBAction func mapButton(_ sender: Any) {
        performSegue(withIdentifier: "ToMapViewController", sender: nil)
    }
    
}
