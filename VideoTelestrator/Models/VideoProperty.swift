//
//  VideoProperty.swift
//  DigitalGameday
//
//  Created by Priyesh Pilapally on 15/02/17.
//  Copyright © 2017 Gist Digital. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

//Telestration property class
class VideoProperty: Mappable {
    
    var telestration_id : Int?
    var telestration_clip_id : Int?
    var telration_created_at : String?
    var telestration_container_width : Float?
    var telestration_container_height : Float?
    var telestration_ui_rotate : Float?
    var telestration_ui_resize : String?
    var telestration_element : String?
    var telestration_element_id : String?
    var telestration_element_color : String?
    var telestration_element_direction : String?
    var telestration_element_top : Float?
    var telestration_element_left : Float?
    var telestration_element_width : Float?
    var telestration_element_height : Float?
    var telestration_element_zindex : Float?
    var telestration_element_begin : Float?
    var telestration_element_begin_pause : Float?
    var telestration_element_end : Float?
    var telestration_element_end_pause : Float?
    var telestration_element_title : String?
    var telestration_element_text : String?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        telestration_id  <- map["telestration-id"]
        telestration_clip_id <- map["telestration-clip-id"]
        telration_created_at <- map["telration-created-at"]
        telestration_container_width <- map["telestration-container-width"]
        telestration_container_height <- map["telestration-container-height"]
        telestration_ui_rotate <- map["telestration-ui-rotate"]
        telestration_ui_resize <- map["telestration-ui-resize"]
        telestration_element <- map["telestration-element"]
        telestration_element_id <- map["telestration-element-id"]
        telestration_element_color <- map["telestration-element-color"]
        telestration_element_direction <- map["telestration-element-direction"]
        telestration_element_top <- map["telestration-element-top"]
        telestration_element_left <- map["telestration-element-left"]
        telestration_element_width <- map["telestration-element-width"]
        telestration_element_height <- map["telestration-element-height"]
        telestration_element_zindex <- map["telestration-element-zindex"]
        telestration_element_begin <- map["telestration-element-begin"]
        telestration_element_begin_pause <- map["telestration-element-begin-pause"]
        telestration_element_end <- map["telestration-element-end"]
        telestration_element_end_pause <- map["telestration-element-end-pause"]
        telestration_element_title <- map["telestration-element-title"]
        telestration_element_text <- map["telestration-element-text"]
    }

}





