//
//  CounterContainerView.swift
//  Docha
//
//  Created by Mathis D on 08/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

protocol CounterContainerViewDelegate {
    func infosButtonTouched()
}

class CounterContainerView: UIView {
    
    var numberOfCounterDisplayed: Int = 3 {
        didSet {
            if numberOfCounterDisplayed == 2 {
                counterViewArray.first?.isHidden = true
                counterViewArray.removeFirst()
            }
        }
    }
    
    var delegate: CounterContainerViewDelegate?
    
    @IBOutlet var counterViewArray: [CounterView]!
    @IBOutlet weak var centsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        initCountersViews()
    }
    
    func initCountersViews() {
        
        for counterView in counterViewArray {
            counterView.counterImage = JDFlipImageView(frame: CGRect(x: 0, y: 0, width: counterView.frame.width, height: counterView.frame.height))
            counterView.counterImage.image = UIImage(named: "counter_base")
            counterView.counterImage.contentMode = .scaleAspectFit
        }
    }
    
    func updateCountersViewsWithPrice(_ priceArray: [Int]) {
        var index = 0
        for price in priceArray {
            counterViewArray[index].startCounterAnimationWithNumber(number: price, completion: nil)
            index += 1
        }
    }
    
    func resetCountersViews() {
        
        for counterView in counterViewArray {
            counterView.counterImage.setImageAnimated(UIImage(named: "counter_base"), duration: 0.1, completion: { (_) in
                counterView.currentNumber = -1
            })
        }
    }
    
    func runAfterDelay(_ delay: TimeInterval, block: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
    
    @IBAction func infosButtonTouched(_ sender: UIButton) {
        self.delegate?.infosButtonTouched()
    }
}
