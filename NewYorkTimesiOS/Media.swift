//
//  Media.swift
//  NewYorkTimesiOS
//
//  Created by 許自翔 on 2020/10/27.
//

import Foundation

struct Media:Codable {
    let type:String
    let subtype:String
    let caption:String
    let copyright:String
    let metadata:[Metadata]
    
    enum CodingKeys: String, CodingKey {
            case type
            case subtype
            case caption
            case copyright
            case metadata = "media-metadata"
        }
    
    
}
