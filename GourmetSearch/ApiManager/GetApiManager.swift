//
//  GetApiManager.swift
//  GourmetSearch
//
//  Created by moritarikuto on 2022/06/13.
//

import Foundation

class GetApiManager {
    // ソースコードに置くべきではないが、今回は実装の優先度から判断して、直接置くことにする
    private let key = "db3b8db8a1dd923b"
    
    var delegate: GetApiManagerDelegate?
    
    // API通信
    func onGetResponse(latitude: Double, longitude: Double ,range: Int) {
        var baseUrl = URLComponents(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/")
        baseUrl?.queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lng", value: String(longitude)),
            URLQueryItem(name: "range", value: String(range)),
            URLQueryItem(name: "count", value: "100"),
            URLQueryItem(name: "format", value: "json"),
        ]
        
        guard let url = baseUrl?.url else { return}
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: { [self](data, response, error) in
            
            guard let data = data,
                  let response = response as? HTTPURLResponse, error == nil
            else {
                print("データもしくはレスポンスがnilの状態です")
                self.delegate?.onError(error!)
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            do {
                let ResponseModel =  try JSONDecoder().decode(Gourmet.self, from: data)
                let shops = ResponseModel.results.shop
                delegate?.onGetResponse(self, responseModel: shops, resultsCount: ResponseModel.results.resultsReturned)
            }
            catch {
                delegate?.onError(error)
            }
        })
        task.resume()
    }
}
