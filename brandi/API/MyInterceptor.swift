//
//  Interceptor.swift
//  brandi
//
//  Created by dev.geeyong on 2021/01/28.
//

import Foundation
import Alamofire

class MyInterceptor: RequestInterceptor{
    //카카오api key - accessToken
    let accessToken: String = API.API_ID
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void){
        print("Interceptor adapt")
        var urlRequest = urlRequest
      
        urlRequest.headers.add(.authorization(accessToken))
        completion(.success(urlRequest))
        //공통 파라매터 추가가능부분
        //헤더에 카카오api key 추가
    }
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("Interceptor retry")
        completion(.doNotRetry)
    }
}
