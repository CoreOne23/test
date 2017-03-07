//
//  VideoComment.swift
//  DigitalGameday
//
//  Created by Priyesh Pilapally on 15/02/17.
//  Copyright © 2017 Gist Digital. All rights reserved.
//

import Foundation
import ObjectMapper
//Telestration Comment class
class VideoComment: Mappable {
    
    var id: Int?
    var clip_id: Int?
    var comment: String?
    var user_id: Int?
    var parent_id: Int?
    var active: String?

    convenience required init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
         id <- map["id"]
         clip_id <- map["clip_id"]
         comment <- map["comment"]
         user_id <- map["user_id"]
         parent_id <- map["parent_id"]
         active <- map["active"]
    }
}
