//
//  ImageExtensions.swift
//  DigitalGameDayTest
//
//  Created by Priyesh Pilapally on 06/03/17.
//  Copyright © 2017 qburst. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
    //-- Returns cropped image w.r.t rect
    func cropImage(_ rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(rect.size)
        // Create the bitmap context
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        // Sets the clipping path to the intersection of the current clipping path with the area defined by the specified rectangle.
        context.clip(to: CGRect(origin: .zero, size: rect.size))
        self.draw(in: CGRect(origin: CGPoint(x: -rect.origin.x, y: -rect.origin.y), size: self.size))
        // Returns an image based on the contents of the current bitmap-based graphics context.
        let contextImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return contextImage
    }
}
