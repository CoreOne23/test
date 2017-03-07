//
//  APIManagerDG.swift
//  DigitalGameday
//
//  Created by Priyesh Pilapally on 15/02/17.
//  Copyright © 2017 Gist Digital. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class  APIManagerDG{
    //API call
    func getResponse( URL: String , callBack:@escaping (VideoParent) -> ()) {
        Alamofire.request(URL).responseObject { (response: DataResponse<VideoParent>) in
            let apiResponse = response.result.value
            if let apiResponse = apiResponse {
                callBack(apiResponse)
            }
        }
    }
}
extension AppDelegate {
    public class func applicationObject() -> (AppDelegate) {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
//Extension to get the top view controller
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}





