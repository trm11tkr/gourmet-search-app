//
//  GetApiMangagerDelegate.swift
//  GourmetSearch
//
//  Created by moritarikuto on 2022/06/13.
//

import Foundation
protocol GetApiManagerDelegate {
    func onGetResponse(_ apiManager: GetApiManager, responseModel: [Shop], resultsCount: String)
    func onError(_ error: Error)
}
