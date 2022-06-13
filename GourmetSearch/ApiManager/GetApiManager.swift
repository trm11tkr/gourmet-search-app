//
//  GetApiManager.swift
//  GourmetSearch
//
//  Created by moritarikuto on 2022/06/13.
//

import Foundation

class GetApiManager {
    var delegate: GetApiManagerDelegate?
    func onGetResponse(lat: Double, lng: Double ,range: Int) {
        let url = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=db3b8db8a1dd923b&lat=\(lat)&lng=\(lng)&range=\(range)&count=100&format=json")
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: url!, completionHandler: { [self](data, response, error) in
            
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
                let decoder = JSONDecoder()
                let ResponseModel =  try decoder.decode(Gourmet.self, from: data)
                let shops = ResponseModel.results.shop
                delegate?.onGetResponse(self, responseModel: shops, resultsCount: ResponseModel.results.results_returned)
            }
            catch {
                delegate?.onError(error)
            }
        })
        task.resume()
    }
}
