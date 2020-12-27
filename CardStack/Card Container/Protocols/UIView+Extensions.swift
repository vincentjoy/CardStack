//
//  UIView+Extensions.swift
//  CardStack
//
//  Created by Rehlat Online Services Pvt Ltd on 27/12/20.
//

import UIKit

extension UIView {
    
    func topRoundCorners(with radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func dropShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: -4)
        self.layer.shadowRadius = 5
    }
    
    func setY(y:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
}
