//
//  VideoStatus.swift
//  DigitalGameday
//
//  Created by Priyesh Pilapally on 15/02/17.
//  Copyright © 2017 Gist Digital. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

//Video Parent class
class VideoStatus: Mappable {
    
    var code: Int?
    var message: String?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        code  <- map["code"]
        message <- map["message"]
    }
}

