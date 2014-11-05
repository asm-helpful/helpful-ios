//
//  ImageExtensions.swift
//  Helpful
//
//  Created by Jeroen Leenarts on 05-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

import UIKit

extension UIImage {
    func roundImageFor(rect: CGRect) -> UIImage {
        let scale = UIScreen.mainScreen().scale
        let rect = CGRect(x: 0.0, y: 0.0, width: rect.size.width * scale, height: rect.size.height * scale)
        
        UIGraphicsBeginImageContext(rect.size)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        CGContextTranslateCTM(ctx, 0, rect.size.height)
        CGContextScaleCTM(ctx, 1.0, -1.0)
        
        CGContextAddEllipseInRect(ctx, rect);
        CGContextClip(ctx);
        CGContextDrawImage(ctx, rect, self.CGImage);
        
        // Draw border
        CGContextSetLineWidth(ctx, scale);
        CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor);
        CGContextStrokeEllipseInRect(ctx, rect);
        CGContextRestoreGState(ctx);
        let roundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return roundImage
    }
}