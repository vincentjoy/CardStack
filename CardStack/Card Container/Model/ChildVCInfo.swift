//
//  ChildVCInfo.swift
//  CardStack
//
//  Created by Rehlat Online Services Pvt Ltd on 27/12/20.
//

import UIKit

/// This class carries information about each card
/// Using "vc", we can get the reference of the view controller inside each card to call any method or manipulate any object in that

public class ChildVCInfo {
    
    public var vc: UIViewController?
    
    var title:String /* The button title when each card is presented */
    var identifier:String /* StoryBoard ID of eacch view controller to be addedd to the corresponding card */
    var vcContainer: UIView?
    var overlayView: UIView? /* A black semi transparent view which appears when this card is out of focus */
    
    public init(title: String, identifier: String) {
        self.title = title
        self.identifier = identifier
    }
}
