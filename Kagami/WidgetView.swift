//
//  WidgetView.swift
//  Kagami
//
//  Created by Eric Chang on 3/13/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol WidgetViewable: class {
    var panRecognizer: UIPanGestureRecognizer { get set }
    var tapRecognizer: UITapGestureRecognizer { get set }
    var propertyAnimator: UIViewPropertyAnimator? { get set }
    var userDefaults: UserDefaults { get set }
    
    var mirrorIcon: UIImage { get set }
    var dockIcon: UIImage { get set }
    
    func addSettings()
}

protocol WidgetViewProtocol: class {
    func layoutWidgetView(widgetView: WidgetView)
}

class WidgetView: UIView {
    
    // MARK: - Properties
    internal var userDefaults = UserDefaults.standard
    internal var propertyAnimator: UIViewPropertyAnimator?
    internal var tapRecognizer = UITapGestureRecognizer()
    internal var panRecognizer = UIPanGestureRecognizer()
    var ref: FIRDatabaseReference!

    var widget: Widgetable
    var mirrorView = UIImageView()
    var dockView = UIImageView()
    weak var viewDelegate: WidgetViewProtocol?
    
    
    init(widget: Widgetable) {
        self.widget = widget
        ref = FIRDatabase.database().reference()
        propertyAnimator = UIViewPropertyAnimator(duration: 0.75, dampingRatio: 0.77, animations: nil)
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    // below init is for storyboard, however this will cause no widget init. 
    // user programmatic only
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Settings Animations
    func setupAnimationConstraint() {
        self.snp.remakeConstraints({ (make) in
            make.height.width.equalToSuperview().multipliedBy(0.8)
            make.center.equalToSuperview()
        })
        
        self.layer.opacity = 1.0
        
        self.layoutIfNeeded()
    }
    
    // MARK: - Drag and Drop
    func setPanGestureRecognizer() -> UIPanGestureRecognizer {
        panRecognizer = UIPanGestureRecognizer (target: self, action: #selector(wasDragged(_:)))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.cancelsTouchesInView = false
        return panRecognizer
    }
    
    func setTapRecognizer() -> UITapGestureRecognizer {
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(wasTapped(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.require(toFail: panRecognizer)
        return tapRecognizer
    }

    func wasTapped(_ gesture: UITapGestureRecognizer) {
        
        let widgetView = gesture.view as! WidgetViewable

        widgetView.addSettings()
        if gesture.state == .ended {
            
            propertyAnimator?.addAnimations ({
                self.setupAnimationConstraint()
            })
            
            propertyAnimator?.startAnimation()
        }
    }
    
    func wasDragged(_ gesture: UIPanGestureRecognizer) {

        let translation = gesture.translation(in: self)
        
        self.center = CGPoint(x: self.center.x + translation.x , y: self.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self)
        
        if gesture.state == .began {
            dump("Parent View \(self.subviews.count)")
        }
        
        if gesture.state == .changed {
            dump("Label Center \(self.center) Translation: \(translation)")
        }
        
        if gesture.state == .ended {
            self.viewDelegate?.layoutWidgetView(widgetView: self)
        }
    }

}