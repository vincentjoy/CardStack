//
//  ViewEmbedder.swift
//  CardStack
//
//  Created by Rehlat Online Services Pvt Ltd on 27/12/20.
//

import UIKit

protocol ViewEmbedder {
    func embed(withIdentifier id:String, parent:UIViewController, storyboard: UIStoryboard, container:UIView, completion:((UIViewController)->Void))
    func embed(parent:UIViewController, container:UIView, child:UIViewController)
    func removeFromParent(vc:UIViewController)
}

extension ViewEmbedder {

    func embed(withIdentifier id:String, parent:UIViewController, storyboard: UIStoryboard, container:UIView, completion:((UIViewController)->Void)) {
        
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        embed(
            parent: parent,
            container: container,
            child: vc
        )
        completion(vc)
    }
    
    func embed(parent:UIViewController, container:UIView, child:UIViewController) {

        child.willMove(toParent: parent)
        parent.addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: parent)
        let w = container.frame.size.width
        let h = container.frame.size.height
        child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }

    func removeFromParent(vc:UIViewController) {
        
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}

