//
//  VideoParent.swift
//  DigitalGameday
//
//  Created by Priyesh Pilapally on 15/02/17.
//  Copyright © 2017 Gist Digital. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class VideoParent: Mappable {
    var status = VideoStatus()
    var clip = VideoClip()
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        status <- map["status"]
        clip <- map["clip"]
    }
}

