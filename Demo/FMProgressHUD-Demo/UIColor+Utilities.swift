//
//  UIColor+Utilities.swift
//  fmHUDApp
//
//  Created by Matchima Ditthawibun on 15/5/21.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
