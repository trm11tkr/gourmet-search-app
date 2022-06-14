import UIKit
import CoreLocation


class ViewController: UIViewController {
    @IBOutlet weak var range: UISegmentedControl!
    @IBOutlet weak var shopListTable: UITableView!
    @IBOutlet weak var resultsCount: UILabel!
    
    
    private var apiManager = GetApiManager()
    private var shops : [Shop] = []
    
    private var selectedRange: Int = 3
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        requestLocationAuthorization(status: locationManager.authorizationStatus)
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
        selectedRange = sender.selectedSegmentIndex + 1
        locationManager.requestLocation()
    }
}

// MARK: - Location

extension ViewController: CLLocationManagerDelegate {
    // 位置情報が取得できた場合
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        apiManager.onGetResponse(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, range: selectedRange)
    }
    
    // 現在地情報が取得できなかった場合
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // アラート処理
    }
    
    // 位置情報権限が変更された場合
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestLocationAuthorization(status: manager.authorizationStatus)
    }
    
    
    private func requestLocationAuthorization(status: CLAuthorizationStatus) {
            switch status {
            case .notDetermined:
                print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
                // 許可を求めるコードを記述する（後述）
                break
            case .denied:
                print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
                // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
                break
            case .restricted:
                print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
                // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
                break
            case .authorizedAlways:
                print("常時、位置情報の取得が許可されています。")
                // 位置情報取得の開始処理
                break
            case .authorizedWhenInUse:
                print("起動時のみ、位置情報の取得が許可されています。")
                // 位置情報取得の開始処理
                locationManager.requestLocation()
                break
            @unknown default:
                break
            }
        }
}

// MARK: - TableView

extension ViewController: UITableViewDataSource, UITableViewDelegate {
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
        imageView.image = UIImage(url: shop.logoImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(shops[indexPath.row].name)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "ToShopDetailViewController", sender: indexPath.row)
    }
}

extension UIImage {
    convenience init(url: String) {
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


// MARK: - GetApiManager

extension ViewController : GetApiManagerDelegate {
    func onError(_ error: Error) {
        print(error)
    }
    
    func onGetResponse(_ apiManager: GetApiManager, responseModel: [Shop], resultsCount: String) {
        shops = responseModel
        DispatchQueue.main.async {
            self.resultsCount.text = "検索結果：\(resultsCount)件"
            self.shopListTable.reloadData()
        }
    }
}
