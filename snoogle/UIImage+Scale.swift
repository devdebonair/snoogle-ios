//
//  UIImage+Scale.swift
//  snoogle
//
//  Created by Vincent Moore on 9/10/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import UIKit

extension UIImage {
    func scaleToSize(newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
