//
//  GetApiMangagerDelegate.swift
//  GourmetSearch
//
//  Created by moritarikuto on 2022/06/13.
//

import Foundation
protocol GetApiManagerDelegate {
    
    /// API通信を行う処理
    /// - Parameters:
    ///   - apiManager: 通信ロジック
    ///   - responseModel: 返り値（Shopのリスト）
    ///   - resultsCount: 検索結果数
    func onGetResponse(_ apiManager: GetApiManager, responseModel: [Shop], resultsCount: String)
    func onError(_ error: Error)
}
