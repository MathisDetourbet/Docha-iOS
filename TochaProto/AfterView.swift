//
//  AfterView.swift
//  Docha
//
//  Created by Mathis D on 15/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class AfterView: UIView {
    
    var counterViewTypeArray: [CounterViewAfterType]?
    var estimationResult: EstimationResult? {
        didSet {
            switch estimationResult! {
            case .perfect:
                self.wordImageView.image = UIImage(named: "perfect_word")
                self.sentenceLabel.text = "Vous avez deviné le prix exact"
                break
            case .amazing:
                self.wordImageView.image = UIImage(named: "amazing_word")
                self.sentenceLabel.text = "Super estimation"
                break
            case .great:
                self.wordImageView.image = UIImage(named: "great_word")
                self.sentenceLabel.text = "Bien joué"
                break
            default:
                self.wordImageView.image = UIImage(named: "oups_word")
                self.sentenceLabel.text = "Vite, le prochain produit..."
                break
            }
        }
    }
    
    @IBOutlet weak var blueLayerView: UIView!
    @IBOutlet weak var wordImageView: UIImageView!
    @IBOutlet weak var sentenceLabel: UILabel!
    
    func displayEstimationResults(_ results: [CounterViewAfterType]) {
        var greenPerfectCounter: Int = 0
        
        for resultType in results {
            if (resultType == CounterViewAfterType.perfect || resultType == CounterViewAfterType.green) {
                greenPerfectCounter += 1
            }
        }
        
        if results.count == 2 {
            switch greenPerfectCounter {
            case 0:
                estimationResult = EstimationResult.oups
                break
            case 1:
                estimationResult = EstimationResult.great
                break
            default:
                estimationResult = EstimationResult.perfect
                break
            }
            
        } else if results.count == 3 {
            switch greenPerfectCounter {
            case 0:
                estimationResult = EstimationResult.oups
                break
            case 1:
                estimationResult = EstimationResult.great
                break
            case 2:
                estimationResult = EstimationResult.amazing
                break
            default:
                estimationResult = EstimationResult.perfect
                break
            }
        }
    }
}
