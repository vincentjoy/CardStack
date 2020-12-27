//
//  CardContainerOutlets.swift
//  CardStack
//
//  Created by Rehlat Online Services Pvt Ltd on 27/12/20.
//

import UIKit

/// This class holds all the outlets of the CardContainer view controller. By seperating the outlets to this class, we can reduce the number of lines of codes in CardContainer and also write some UI update logics here
class CardContainerOutlets: NSObject {

    @IBOutlet weak var bottomContiner: UIView!
    @IBOutlet weak var actionTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    typealias CardDetails = (top:CGFloat, height:CGFloat, width:CGFloat)
    
    func initialiseUI(with titleLabel:String) {
        bottomContiner.topRoundCorners(with: 40)
        actionTitleLabel.text = titleLabel
    }
    
    func getCardFrameDetails(at index: Int, with gap: CGFloat) -> CardDetails {
        
        let containerBounds = containerView.bounds
        let top = gap * CGFloat(index)
        let height = containerBounds.height - top
        let width = containerBounds.width
        
        return (top,height,width)
    }
}
