//
//  Interceptor.swift
//  brandi
//
//  Created by dev.geeyong on 2021/01/28.
//

import Foundation
import Alamofire

class MyInterceptor: RequestInterceptor{
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void){
        print("Interceptor adapt")
        var request = urlRequest
        
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        completion(.success(urlRequest))
    }
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("Interceptor retry")

        completion(.doNotRetry)
    }
}
