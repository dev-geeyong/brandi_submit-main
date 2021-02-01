//
//  MySearchRouter.swift
//  brandi
//
//  Created by dev.geeyong on 2021/01/28.
//

import Foundation
import Alamofire

enum MySearchRouter: URLRequestConvertible {
    case searchPhotos(term: String, pageNumber: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "/search/")!
    }
    
    var method: HTTPMethod {
        
        return .get
//        switch self {
//        case .searchPhotos:
//            return .get
//        }
    }
    
    var path: String {
        switch self {
        case .searchPhotos: return "image"
        }
    }
    //let queryParam = ["query" : "코카콜라"]
    var parameters: [String:String]{
        switch self {
        case let .searchPhotos(term,pageNumber): //검색어, 결과 페이지 번호, 1~50 사이의 값, 기본 값 1
            return [
                "query" : term,
                "page"  : pageNumber,
                "size"  : "30"
            ]
        }
    }
    func asURLRequest() throws -> URLRequest {
    
        let url = baseURL.appendingPathComponent(path)
        print("asURLRequest- / image 처리 url: \(url)")
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
//        switch self {
//        case let .get(parameters):
//            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
//        case let .post(parameters):
//            request = try JSONParameterEncoder().encode(parameters, into: request)
//        }
        
        return request
        
        //https://dapi.kakao.com/v2/search/image?query=
    }
}
