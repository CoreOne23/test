//
//  VideoClip.swift
//  DigitalGameday
//
//  Created by Priyesh Pilapally on 15/02/17.
//  Copyright © 2017 Gist Digital. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

//Telestration Video Clip class
class VideoClip: Mappable {
    
    var id: Int?
    var start: Float?
    var length: Float?
    var size: String?
    var format: String?
    var thumbnail_url: String?
    var clip_url: String?
    var description: String?
    var comments: [VideoComment] = []
    var properties: [VideoProperty] = []
    
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
         id <- map["id"]
         start <- map["start"]
         length <- map["length"]
         size <- map["size"]
         format <- map["format"]
         thumbnail_url <- map["thumbnail_url"]
         clip_url <- map["clip_url"]
         description <- map["description"]
         comments <- map["comments"]
        properties <- map["properties"]
    }
}
