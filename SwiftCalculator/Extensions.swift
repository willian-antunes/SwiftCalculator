//
//  Extensions.swift
//  DrawingBoard
//
//  Created by Willian Antunes on 07/05/20.
//  Copyright © 2020 Willian Antunes. All rights reserved.
//

import UIKit

extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
