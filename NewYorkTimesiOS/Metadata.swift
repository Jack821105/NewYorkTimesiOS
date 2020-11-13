//
//  Metadata.swift
//  NewYorkTimesiOS
//
//  Created by 許自翔 on 2020/10/27.
//

import Foundation

struct Metadata:Codable {
    let format:String
    let url:String
    var imageUrl:URL{
        return URL(string: url)!
    }
}
