import UIKit
import CoreLocation


class ViewController: UIViewController {
    @IBOutlet weak var range: UISegmentedControl!
    @IBOutlet weak var shopListTable: UITableView!
    
    // 検索結果の数
    @IBOutlet weak var resultsCount: UILabel!
    
    // 検索結果が0件だった際に表示するラベル
    @IBOutlet weak var nothingLabel: UILabel!
    
    private var apiManager = GetApiManager()
    private var shops: [Shop] = []
    
    // 検索範囲（初期値はクエリのデフォルト値である1kmに設定）
    private var selectedRange: Int = 3
    
    // 位置情報を扱う「Core Location」サービスを使用するためのインスタンス
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        apiManager.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationAuthorization(status: locationManager.authorizationStatus)
    }
    
    // ShopListTableのセットアップ
    private func setupTableView() {
        shopListTable.dataSource = self
        shopListTable.register(ShopListTableViewCell.nib(), forCellReuseIdentifier: ShopListTableViewCell.reuseIdentifier)
    }
    
    // TableViewCellタップ時の遷移処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToShopDetailViewController" {
            if let nextViewController = segue.destination as? ShopDetailViewController {
                let index = sender as! Int
                nextViewController.shop = shops[index]
            }
        }
    }
    // 検索範囲の選択
    @IBAction func rangeSelect(_ sender: UISegmentedControl) {
        selectedRange = sender.selectedSegmentIndex + 1
        requestLocationAuthorization(status: locationManager.authorizationStatus)
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
    
    // 位置情報利用許可の催促アラート
    private func alertLocationPermission(_ animated: Bool) {
        let alertController = UIAlertController (title: "位置情報の使用を許可してください", message: "アプリをご利用いただくために必要です", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "設定", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // 位置情報ステータスに基づいた処理
    private func requestLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            alertLocationPermission(true)
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            locationManager.requestLocation()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopListTableViewCell", for: indexPath) as! ShopListTableViewCell
        
        let shop = shops[indexPath.row]
        cell.convertImage(shop: shop)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(shops[indexPath.row].name)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "ToShopDetailViewController", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// ロゴイメージが未設定用の画像の場合に、適した画像に置換
extension UIImage {
    convenience init?(url: String) {
        guard let url = URL(string: url),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        self.init(data: data)
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
            // 検索結果が0件の場合に表示
            if(self.shops.count == 0) {
                self.nothingLabel.isHidden = false
            } else {
                self.nothingLabel.isHidden = true
            }
            self.resultsCount.text = "検索結果：\(resultsCount)件"
            self.shopListTable.reloadData()
        }
    }
}
