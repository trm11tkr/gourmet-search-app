    //
    //  ViewController.swift
    //  GourmetSearch
    //
    //  Created by moritarikuto on 2022/06/10.
    //

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
            let shop = shops[indexPath.row]
            cell.textLabel!.text = shop.name
            return cell
        }
    }
