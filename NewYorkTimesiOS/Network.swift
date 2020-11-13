//
//  Network.swift
//  NewYorkTimesiOS
//
//  Created by 許自翔 on 2020/10/27.
//

import Foundation
import UIKit


class Network {
    
    
    let imageCache = NSCache<NSURL, UIImage>()
    static let shared = Network()
    let APIKEY = "yAByAe3JRwDIuwWwPeJN5VeAVQNS7Eru"
    
    //讀取全部資料
    func fetchData(completion:@escaping (Results) -> Void) {
        let url = getURL_Path(APIKEY: APIKEY)
        var req = URLRequest(url: url!)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req) { [self] (data, response, error) in
            if let error = error{
            }else if let response = response, let data = data{
                let decoder = try? JSONDecoder().decode(Results.self, from: data)
                completion(decoder!)
            }
        }.resume()
    }
    
    /*-------------------------------------------------------*/
    
    //String To URL
    func getURL_Path(APIKEY:String) -> URL?{
        //處理中文字串
        let newText = APIKEY.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let urlPath = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json?api-key=\(APIKEY)")
        else {
            return nil
        }
        return urlPath
    }
    /*-------------------------------------------------------*/
    
    //取圖
    func fetchImage(pathUrl:URL , completion: @escaping (UIImage?)->Void) {
        if let image = imageCache.object(forKey: pathUrl as NSURL) {
            print("取出快取的圖片")
            completion(image)
            return
        }
        var req = URLRequest(url: pathUrl)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let error = error {
            }else if let response = response, let data = data,let image = UIImage(data: data){
                self.imageCache.setObject(image, forKey: pathUrl as NSURL)
                print("存入快取的圖片")
                completion(image)
            }
        }.resume()
        
    }
    /*-------------------------------------------------------*/
    
    
    
}
