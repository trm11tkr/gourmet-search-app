        import UIKit

        class ViewController: UIViewController {
            @IBOutlet weak var range: UISegmentedControl!
            @IBOutlet weak var shopListTable: UITableView!
            
            var shops: Array<Shop> = []
            
            override func viewDidLoad() {
                super.viewDidLoad()
                // Do any additional setup after loading the view.
                self.request(range: 3)
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
                self.request(range: range)
            }
            
            
            func request(range: Int) {
                let lat = 34.9875216;
                let lng = 135.7203744;
                let url: URL = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=db3b8db8a1dd923b&lat=\(lat)&lng=\(lng)&range=\(range)&count=100&format=json")!
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
