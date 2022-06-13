import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var range: UISegmentedControl!
    @IBOutlet weak var shopListTable: UITableView!
    @IBOutlet weak var results_count: UILabel!
    
    private var apiManager = GetApiManager()
    private var shops : [Shop] = []
    
    var nowLat: Double = 0.0;
    var nowLng: Double = 0.0;
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        apiManager.onGetResponse(lat: nowLat, lng: nowLng, range: 3)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToShopDetailViewController" {
            if let nextVC = segue.destination as? ShopDetailViewController {
                let index = sender as! Int
                nextVC.shop = shops[index]
            }
        }
    }
    
    @IBAction func rangeSelect(_ sender: UISegmentedControl) {
        let range = sender.selectedSegmentIndex + 1
        locationManager.requestLocation()
        results_count.text =  "検索結果：\(shops.count)件"
        apiManager.onGetResponse(lat: nowLat, lng: nowLng, range: range)
    }
    
    
    // 位置情報が取得できた場合
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            
            if let error = error {
                print("reverseGeocodeLocation Failed: \(error.localizedDescription)")
                return
            }
            
                
                self.nowLat = loc.coordinate.latitude
                self.nowLng = loc.coordinate.longitude
        })
    }
    
    // 現在地情報が取得できなかった場合
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}

extension ViewController: UITableViewDelegate {
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        shopListTable.rowHeight = 120
        
        let shop = shops[indexPath.row]
        
        let nameLabel = cell.viewWithTag(2) as! UILabel
        
        let accessLabel = cell.viewWithTag(3) as! UILabel
        
        let genre = cell.viewWithTag(4) as! UILabel
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        nameLabel.text = shop.name
        accessLabel.text = shop.access
        genre.text = shop.genre.name
        imageView.image = UIImage(url: shop.logo_image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(shops[indexPath.row].name)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "ToShopDetailViewController", sender: indexPath.row)
    }
}

extension UIImage {
    public convenience init(url: String) {
        if (url == "https://imgfp.hotp.jp/SYS/cmn/images/common/diary/custom/m30_img_noimage.gif") {
            self.init(named: "tableware")!
            return
        }
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}

extension ViewController : GetApiManagerDelegate {
    func onError(_ error: Error) {
        print(error)
    }
    
    func onGetResponse(_ apiManager: GetApiManager, responseModel: [Shop], resultsCount: String) {
        shops = responseModel
        DispatchQueue.main.async {
            self.results_count.text = "検索結果：\(resultsCount)件"
            self.shopListTable.reloadData()
        }
    }
}
