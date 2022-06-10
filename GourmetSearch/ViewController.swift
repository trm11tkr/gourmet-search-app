//
//  ViewController.swift
//  GourmetSearch
//
//  Created by moritarikuto on 2022/06/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.request()
    }
    
    func request() {
        let url: URL = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=db3b8db8a1dd923b&lat=34.9875216&lng=135.7593744&range=1&count=3&format=json")!
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
                       for s in gourmet.results.shop {
                           print(s.photo.mobile.mobileImage)
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
