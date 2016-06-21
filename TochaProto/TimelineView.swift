//
//  TimelineView.swift
//  Docha
//
//  Created by Mathis D on 16/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

enum StepState {
    case Perfect
    case Success
    case Fail
    case Current
    case None
}

class TimelineView: UIView {
    var stepStateArray: [StepState]?
    var cursor: Int! = 0
    
    @IBOutlet var stepsImagesViews: [UIImageView]!
    
    func initTimeline() {
        stepStateArray = []
        stepStateArray?.append(.Current)
        
        for _ in 1...stepsImagesViews.count-1 {
            stepStateArray?.append(.None)
        }
        cursor = stepStateArray?.indexOf(.Current)
        
//        for index in 0...stepsImagesViews.count-1 {
//            let stepImage = stepsImagesViews[index]
//            stepImage.translatesAutoresizingMaskIntoConstraints = false
//            
//            // Center Y
//            self.addConstraint(NSLayoutConstraint(item: stepImage, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
//            
//            // Leading
//            if index == 0 {
//                self.addConstraint(NSLayoutConstraint(item: stepImage, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 3.0))
//            } else {
//                self.addConstraint(NSLayoutConstraint(item: stepImage, attribute: .Leading, relatedBy: .Equal, toItem: stepsImagesViews[index-1], attribute: .Trailing, multiplier: 1.0, constant: 3.0))
//            }
//            
//            // Height & Width
//            stepStateArray![index] == .Current ? addSizeConstraintToItem(stepImage, andSize: 25.0) : addSizeConstraintToItem(stepImage, andSize: 20.0)
//        }
    }
    
    func nextStepWithState(state: StepState) {
        if cursor == stepsImagesViews.count {
            return
        }
        stepStateArray![cursor] = state
        stepStateArray![cursor+1] = .Current
        //resizeItem(stepsImagesViews![cursor!], withSize: 20.0, OfIndex: cursor!)
        updateImageItem(stepsImagesViews![cursor], withState: state)
        
        cursor = stepStateArray?.indexOf(.Current)
        //resizeItem(stepsImagesViews![cursor], withSize: 25.0, OfIndex: cursor!)
    }
    
    func updateImageItem(item: UIImageView, withState state: StepState) {
        switch state {
        case .Perfect:
            item.image = UIImage(named: "timeline_icon_perfect")
            break
        case .Success:
            item.image = UIImage(named: "timeline_icon_right")
            break
        case .Fail:
            item.image = UIImage(named: "timeline_icon_wrong")
            break
        case .Current:
            item.image = UIImage(named: "timeline_icon_selected")
            break
        default:
            item.image = UIImage(named: "timeline_icon_none_small")
            break
        }
    }
    
    func resizeItem(item: UIImageView, withSize size: CGFloat, OfIndex index: Int) {
        item.removeConstraints(item.constraints)
        addSizeConstraintToItem(item, andSize: size)
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        if index == 0 {
            self.addConstraint(NSLayoutConstraint(item: item, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 3.0))
        } else {
            self.addConstraint(NSLayoutConstraint(item: item, attribute: .Leading, relatedBy: .Equal, toItem: stepsImagesViews[index-1], attribute: .Trailing, multiplier: 1.0, constant: 3.0))
        }
    }
    
    func addSizeConstraintToItem(item: UIImageView, andSize size: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: size))
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: size))
    }
}