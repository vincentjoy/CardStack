//
//  CardContainer.swift
//  CardStack
//
//  Created by Rehlat Online Services Pvt Ltd on 27/12/20.
//

import UIKit

public protocol CardContainerDelegate {
    func cardAdded(at index:Int)
    func cardSelected(at index:Int)
}

public class CardContainer: UIViewController, ViewEmbedder {

    @IBOutlet var outlets: CardContainerOutlets!
    
    public var delegate: CardContainerDelegate?
    public var gap: CGFloat // This value speecifies how much gap is needed between each card
    public var childVC: [ChildVCInfo]
    public var presentingStoryboard: UIStoryboard /* Storyboard where the view controllers coming under the card is specified */

    private var cardCount = 0
    private var intialLoad = true
    
    public init(with childVC:[ChildVCInfo], gap:CGFloat, storyboard:UIStoryboard) {
        self.childVC = childVC
        self.gap = gap
        self.presentingStoryboard = storyboard
        super.init(nibName: "CardContainer", bundle: Bundle(for: CardContainer.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if intialLoad {
            outlets.initialiseUI(with: childVC[0].title)
            setupCard(at:cardCount)
            intialLoad = false
        }
    }
    
    func setupCard(at index:Int) {
        
        let cardFrameDetails = outlets.getCardFrameDetails(at: index, with: gap)
        
        /// This will be the card and it has the viiew controller inside it
        /// To enable the animation of appearing the card from the bottom, the 'y' position is initially set as same as the height
        /// The variable 'gap' is used to ddetermine the origin of each card. It will be y position of previous card + gap
        let vcContainer = UIView(frame: CGRect(x: 0, y: cardFrameDetails.height, width: cardFrameDetails.width, height: cardFrameDetails.height))
        vcContainer.dropShadow()
        outlets.containerView.addSubview(vcContainer)
        self.childVC[index].vcContainer = vcContainer
        
        /// A semi transparent layer is added to each view
        /// It will be hidden initially, but will be active once this card goes to the background (ie, when a new card is added on top of this)
        /// This overlay view has a touch also. Since this view is hidden when this card is on the focus, this gesture recogonizer wont interfere with the touch actions inside the view controller. But once the card goes to the background and the sei transparent overlay appears, this touch will be active and will be usedd to dismiss the cards infront
        let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: cardFrameDetails.width, height: cardFrameDetails.height))
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        overlayView.tag = index /* To determine from which cardd the touch originated*/
        self.childVC[index].overlayView = overlayView
        
        /// The gesture to dismiss the cards in front of this card, oncce this card is touched
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tapAction))
        overlayView.addGestureRecognizer(gesture)
        
        self.embed(withIdentifier: childVC[index].identifier, parent: self, storyboard: self.presentingStoryboard, container: vcContainer) { (vc) in
            vc.view?.topRoundCorners(with: 40)
            self.childVC[index].vc = vc
            vc.view.addSubview(overlayView)
            overlayView.isHidden = true /* Overlay is hidden intially. Because right now this card is on the top */
        }
        
        UIView.animate(withDuration: 0.25) {
            vcContainer.setY(y:cardFrameDetails.top)
            self.outlets.actionTitleLabel.text = self.childVC[index].title
            if index>0 {
                self.childVC[index-1].overlayView?.isHidden = false /* Overlay addedd for the previous card. So a semi transparent layer will appear for that card and user can touch to dismiss the card there */
            }
        }
        
        self.delegate?.cardAdded(at: index)
    }
    
    @objc func tapAction(sender : UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            selectedCard(at: tag)
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if cardCount < (childVC.count-1) {
            cardCount += 1
            setupCard(at:cardCount)
        }
    }
    
    func selectedCard(at index: Int) {
        
        guard (index<cardCount) else {
            return
        }
        
        /// Removing all the cards infront of this touched card
        for i in ((index+1)...cardCount).reversed() {
            let cardFrameDetails = outlets.getCardFrameDetails(at: index, with: gap)
            UIView.animate(withDuration: 0.10) {
                self.childVC[i].vcContainer?.setY(y: cardFrameDetails.height)
            } completion: { (_) in
                if let vc = self.childVC[i].vc {
                    self.removeFromParent(vc: vc)
                }
                self.childVC[i].vcContainer?.removeFromSuperview()
            }
        }
        outlets.actionTitleLabel.text = self.childVC[index].title
        cardCount = index
        childVC[index].overlayView?.isHidden = true /* Hiding the overlay, sinc now this one is the card at the front */
        self.delegate?.cardSelected(at: index)
    }
}
