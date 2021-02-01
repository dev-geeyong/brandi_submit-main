//
//  AlamofireManager.swift
//  brandi
//
//  Created by dev.geeyong on 2021/01/28.
//

import Foundation
import Alamofire
import SwiftyJSON

final class AlamofireManager{
    
    //싱글톤 적용
    static let shared = AlamofireManager()
    
    let interceptors = Interceptor(interceptors:
        [
            MyInterceptor() //headers 값 관리
        ])
    let monitors = [MyLogger()]
    
    var sesstion: Session
    
    private init(){
        sesstion = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func getPhotos(searcTerm userInput: String, pageNumber: String, completion: @escaping(Result<[Photo],MyError>)->Void){
        
        print("Manager - getphotos")
        
        self.sesstion
            .request(MySearchRouter.searchPhotos(term: userInput, pageNumber: pageNumber))
            .validate(statusCode: 200..<401)
            .responseJSON(completionHandler: {response in
                
                guard let reponseValue = response.value else { return }
                
                let responseJson = JSON(reponseValue)
                
                let jsonArray = responseJson["documents"]
          
                var photos = [Photo]()
                
                for (index, subJson): (String, JSON) in jsonArray{
                    
                    //print("index: \(index) , subJson: \(subJson)")
                    
                    let thumbnail = subJson["thumbnail_url"].string ?? ""
                    let datetime = subJson["datetime"].string ?? ""
                    let displaySite = subJson["display_sitename"].string ?? ""
                    let imageURL = subJson["image_url"].string ?? ""
                    
                    let photoItem = Photo(thumbnailURL: thumbnail, datetime: datetime, displaySiteName: displaySite, imageURL: imageURL)
                    
                    photos.append(photoItem)
                    
                }
      
                //값 전송
                if photos.count > 0{
                    completion(.success(photos))
                }else{
                    completion(.failure(.noContent))
                }
                
                let jsonMetaData = responseJson["meta"]["is_end"]
                if jsonMetaData == true{ //"is_end" 현재 페이지가 마지막 페이지인지 여부
                    return
                }
                
            })
    }
    
}
