import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var range: UISegmentedControl!
    @IBOutlet weak var shopListTable: UITableView!
    
    var nowLat: Double = 0.0;
    var nowLng: Double = 0.0;
    
    var shops: Array<Shop> = []
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        self.request(range: 3, lat: nowLat, lng: nowLng)
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
        self.request(range: range, lat: nowLat, lng: nowLng)
    }
    
    
    // 位置情報が取得できた場合
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
                
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            
            if let error = error {
                print("reverseGeocodeLocation Failed: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?[0] {
                
                var locInfo = ""
                locInfo = locInfo + "Latitude: \(loc.coordinate.latitude)\n"
                locInfo = locInfo + "Longitude: \(loc.coordinate.longitude)\n\n"
                
                locInfo = locInfo + "Country: \(placemark.country ?? "")\n"
                locInfo = locInfo + "State/Province: \(placemark.administrativeArea ?? "")\n"
                locInfo = locInfo + "City: \(placemark.locality ?? "")\n"
                locInfo = locInfo + "PostalCode: \(placemark.postalCode ?? "")\n"
                locInfo = locInfo + "Name: \(placemark.name ?? "")"
                
                self.nowLat = loc.coordinate.latitude
                self.nowLng = loc.coordinate.longitude
            }
        })
    }

    // 現在地情報が取得できなかった場合
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func request(range: Int, lat: Double, lng: Double) {
        let url: URL = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=db3b8db8a1dd923b&lat=\(lat)&lng=\(lng)&range=\(range)&count=100&format=json")!
        print(lat)
        print(lng)
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                print("通信が失敗しました")
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse else {
                print("データもしくはレスポンスがnilの状態です")
                return
            }
            
            if response.statusCode == 200 {
                do {
                    let gourmet = try JSONDecoder().decode(Gourmet.self, from: data)
                    let shops = gourmet.results.shop
                    self.shops = shops
                    print(gourmet.results.results_returned)
                    
                    DispatchQueue.main.async {
                        self.shopListTable.reloadData()
                    }
                } catch let error {
                    print(":エラー:\(error)")
                }
            } else {
                print("statusCode:\(response.statusCode)")
            }
        })
        task.resume()
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
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        nameLabel.text = shop.name
        accessLabel.text = shop.access
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
