//
//  Extensions.swift
//  Helpful
//
//  Created by Jeroen Leenarts on 05-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

import UIKit

let blueLinkColorConst = UIColor.colorWithHexString("00B3ED")
let blackBackgroundColorConst = UIColor.colorWithHexString("333333")
let mutedTextColorConst = UIColor.colorWithHexString("555555")
let lightBlueBackgroundConst = UIColor.colorWithHexString("f1f9fb")
let logoRedColorConst = UIColor.colorWithHexString("ff4b4b")
let timeLabelColorConst = UIColor.colorWithHexString("e5e5e5")
let separatorColorConst = timeLabelColorConst

extension UIColor {
    
    public class var blueLinkColor : UIColor {
        return blueLinkColorConst
    }
    
    public class var blackBackgroundColor : UIColor {
        return blackBackgroundColorConst
    }
    
    public class var mutedTextColor : UIColor {
        return mutedTextColorConst
    }

    public class var lightBlueBackground : UIColor {
        return lightBlueBackgroundConst
    }

    public class var logoRedColor : UIColor {
        return logoRedColorConst
    }
    
    public class var timeLabelColor : UIColor {
        return timeLabelColorConst
    }
    
    public class var separatorColor : UIColor {
        return separatorColorConst
    }

    public class func colorWithHexString(var hexString: String, alpha: Float = 1.0) -> UIColor {
        // Check for hash and add the missing hash
        if hexString.hasPrefix("#") {
            hexString = hexString.substringFromIndex(advance(hexString.startIndex, 1))
        }
        // check for string length
        assert (6 == hexString.utf16Count)
        let redRange = Range(start: advance(hexString.startIndex, 0), end: advance(hexString.startIndex, 2))
        let redHex = hexString.substringWithRange( redRange )

        let greenRange = Range(start: advance(hexString.startIndex, 2), end: advance(hexString.startIndex, 4))
        let greenHex = hexString.substringWithRange( greenRange )

        let blueRange = Range(start: advance(hexString.startIndex, 4), end: advance(hexString.startIndex, 6))
        let blueHex = hexString.substringWithRange( blueRange )
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: redHex).scanHexInt(&r)
        NSScanner(string: greenHex).scanHexInt(&g)
        NSScanner(string: blueHex).scanHexInt(&b)

        return UIColor(red: CGFloat(Float(r)/255.0), green: CGFloat(Float(g)/255.0), blue: CGFloat(Float(b)/255.0), alpha: CGFloat(alpha))
    }
}

extension UIImage {
    public func roundImageFor(rect: CGRect) -> UIImage {
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