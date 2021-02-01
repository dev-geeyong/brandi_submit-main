//
//  MyLogger.swift
//  brandi
//
//  Created by dev.geeyong on 2021/01/28.
//

import Foundation
import Alamofire

final class MyLogger: EventMonitor{
    let queue = DispatchQueue(label: "ApiLog")
    
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume")
       // debugPrint(request)
    }
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger - didParseResponse")
       // debugPrint(response)
    }

}
