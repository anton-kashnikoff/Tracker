//
//  UIColorMarshalling.swift
//  Tracker
//
//  Created by Антон Кашников on 22.08.2023.
//

import UIKit

final class UIColorMarshalling {
    func getHEXString(from color: UIColor) -> String {
        let components = color.cgColor.components
        let (r, g, b) = (components?[0] ?? .zero, components?[1] ?? .zero, components?[2] ?? .zero)
        return String(format: "%02lX%02lX%02lX", lroundf(Float(r) * 255), lroundf(Float(g) * 255), lroundf(Float(b) * 255))
    }
    
    func getColor(from hexString: String) -> UIColor {
        var rgbValue = UInt64.zero
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: 1)
    }
}
