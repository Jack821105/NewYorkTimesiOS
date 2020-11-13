//
//  News.swift
//  NewYorkTimesiOS
//
//  Created by 許自翔 on 2020/10/27.
//

import Foundation

struct News:Codable {
    let id:Int
    let source:String
    let published_date:String
    let section:String
    let adx_keywords:String
    let byline:String
    let type:String
    let title:String
    let abstract:String
    let media:[Media]
}
