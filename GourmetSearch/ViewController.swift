        import UIKit

        class ViewController: UIViewController {
            @IBOutlet weak var shopListTable: UITableView!
            
            var shops: Array<Shop> = []
            
            override func viewDidLoad() {
                super.viewDidLoad()
                // Do any additional setup after loading the view.
                self.request()
            }
            
            func request() {
                let url: URL = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=db3b8db8a1dd923b&lat=34.9875216&lng=135.7593744&range=1&count=100&format=json")!
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
