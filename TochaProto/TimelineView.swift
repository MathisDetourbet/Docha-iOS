//
//  TimelineView.swift
//  Docha
//
//  Created by Mathis D on 16/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

enum StepState {
    case perfect
    case success
    case fail
    case current
    case none
}

class TimelineView: UIView {
    var stepStateArray: [StepState]?
    var cursor: Int! = 0
    
    @IBOutlet var stepsImagesViews: [UIImageView]!
    
    func initTimeline() {
        stepStateArray = []
        stepStateArray?.append(.current)
        
        for _ in 1...stepsImagesViews.count-1 {
            stepStateArray?.append(.none)
        }
        cursor = stepStateArray?.index(of: .current)
    }
    
    func initTimelineWithCounterViewAfterType(_ counterViewAfterType: [CounterViewAfterType]!) {
        self.initTimeline()
        var cursor = 0
        for type in counterViewAfterType {
            type
            cursor += 1
        }
    }
    
    func nextStepWithCounterViewAfterTypeArray(_ counterViewArray: [CounterViewAfterType]!) {
        let state = getStateWithCounterViewAfterType(counterViewArray)
        if cursor == stepsImagesViews.count {
            return
        }
        stepStateArray![cursor] = state
        stepStateArray![cursor+1] = .current
        updateImageItem(stepsImagesViews![cursor], withState: state)
        
        cursor = stepStateArray?.index(of: .current)
        updateImageItem(stepsImagesViews![cursor], withState: .current)
    }
    
    func getStateWithCounterViewAfterType(_ counterViewAfterTypeArray: [CounterViewAfterType]!) -> StepState {
        var perfectCpt = 0
        var greenCpt = 0
        var redCpt = 0
        
        for type in counterViewAfterTypeArray {
            switch type {
            case .perfect:
                perfectCpt += 1
                break
            case .green:
                greenCpt += 1
                break
            default:
                redCpt += 1
                break
            }
        }
        if perfectCpt == counterViewAfterTypeArray.count {
            return StepState.perfect
        } else if redCpt == counterViewAfterTypeArray.count {
            return StepState.fail
        } else {
            return StepState.success
        }
    }
    
    func updateImageItem(_ item: UIImageView, withState state: StepState) {
        switch state {
        case .perfect:
            item.image = UIImage(named: "timeline_icon_perfect")
            break
        case .success:
            item.image = UIImage(named: "timeline_icon_right")
            break
        case .fail:
            item.image = UIImage(named: "timeline_icon_wrong")
            break
        case .current:
            item.image = UIImage(named: "timeline_icon_selected")
            break
        default:
            item.image = UIImage(named: "timeline_icon_none_small")
            break
        }
    }
    
    func resizeItem(_ item: UIImageView, withSize size: CGFloat, OfIndex index: Int) {
        item.removeConstraints(item.constraints)
        addSizeConstraintToItem(item, andSize: size)
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        if index == 0 {
            self.addConstraint(NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 3.0))
        } else {
            self.addConstraint(NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: stepsImagesViews[index-1], attribute: .trailing, multiplier: 1.0, constant: 3.0))
        }
    }
    
    func addSizeConstraintToItem(_ item: UIImageView, andSize size: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size))
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size))
    }
}
