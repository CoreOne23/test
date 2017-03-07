//
//  TelestrationVideo.swift
//  asdasdsadasd
//
//  Created by Priyesh Pilapally on 20/02/17.
//  Copyright © 2017 qburst. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class  TelestrationVideo {
    //API call
    func playVideo(sourceUrl: String, jsonObject: VideoParent) {
        //Initiate telestration storyboard
        let storyboard = UIStoryboard.init(name: "TelestrationStoryboard", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "telestrationViewController")  as? TelestrationViewController else {
            print("Error")
            return
        }
        controller.parentClass = jsonObject
        controller.videoSuorce = sourceUrl
        //Get the top view controller so that the telestration view can be presented
        if let topController = UIApplication.topViewController() {
            topController.present(controller, animated: true, completion: nil)
        }
    }
}
