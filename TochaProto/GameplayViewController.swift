//
//  ViewController.swift
//  TochaProto
//
//  Created by Mathis D on 03/12/2015.
//  Copyright © 2015 LaTV. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CNPPopupController

class GameplayViewController: UIViewController {
    
    // Constants
    let NUMBER_DIGIT_MAX = 3
    let TIMER_IN_SECOND_MAX = 10.0
    
    // Instances variables
    var productList: [Product?] = []
    private var rightPriceArray: [Int?] = []
    
    private var cursor: Int = 0 {
        didSet {
            if cursor == NUMBER_DIGIT_MAX {
                cursor = 0
            }
        }
    }
    private var numberProductDisplayed: Int = 0
    private var counterTimer: Double = 0.0 {
        didSet {
            self.timerInSecondeLabel.text = String(Int(counterTimer))
        }
    }
    private var timer: NSTimer?
    
    // Outlets
    @IBOutlet weak var timerInSecondeLabel: UILabel!
    @IBOutlet weak var titleViewNavBarItem: UINavigationItem!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ballsLabel: UILabel!
    @IBOutlet private var padButtonCollection : [UIButton]!
    @IBOutlet private weak var nameProductLabel: UILabel!
    @IBOutlet private weak var brandNameProductLabel: UILabel!
    @IBOutlet private weak var productImageView: UIImageView!
    
    @IBOutlet var counterViewArray: [CounterView]!
    @IBOutlet weak var centsLabel: UILabel!
    @IBOutlet weak var widthTimerConstraint: NSLayoutConstraint!
    
//# MARK: Life view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let request = RequestGamePlayProducts()
        //let productsListRequest = request.getGamePlayProducts()
        // Do any additional setup after loading the view, typically from a nib.
        self.hidesBottomBarWhenPushed = true
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navbar_background")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .Stretch), forBarMetrics: .Default)
        
        fillDatabase()
        startGameWithProduct(productList[numberProductDisplayed]!)
    }
    
    override func viewWillAppear(animated: Bool) {
        restartTimer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        pauseTimer()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//# MARK: Game controller
    func startGameWithProduct(product: Product) {
        // Counter image init
        if numberProductDisplayed == 0 {
            for counterView in self.counterViewArray {
                counterView.counterImage = JDFlipImageView(frame: CGRectMake(0, 0, counterView.bounds.width, counterView.bounds.height))
                counterView.counterImage.image = UIImage(named: "counter_number_start")
                counterView.counterImage.contentMode = .ScaleAspectFit
            }
        } else {
            self.resetAllCounters()
        }
        
        // Pad init
        for i in 0...padButtonCollection.count-1 {
            padButtonCollection[i].setImage(UIImage(named: String("digitalpad_selected_\(padButtonCollection[i].tag)")), forState: .Highlighted)
        }
        
        // Product informations
        let product = product
        nameProductLabel.text = product.model
        productImageView.downloadedFrom(link: product.imageURL, contentMode: .ScaleAspectFit)
        //brandNameProductLabel.text = product.brand
        
        // Price int to an array of int
        self.rightPriceArray = self.convertPrice(product.price, ToArrayWithCapacity: self.counterViewArray.count)
        
        counterTimer = TIMER_IN_SECOND_MAX
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(GameplayViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
//# MARK: Timer methods
    func updateTimer() {
        if counterTimer <= 0.0 {
            timer?.invalidate()
            let alertView = UIAlertController(title: "Perdu !", message: "Le temps imparti est écoulé", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Essayer à nouveau", style: .Cancel, handler: { (action) -> Void in
                self.counterTimer = self.TIMER_IN_SECOND_MAX
                //self.widthTimerConstraint.constant = self.view.frame.width
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(GameplayViewController.updateTimer), userInfo: nil, repeats: true)
            })
            alertView.addAction(cancelAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        } else {
            //widthTimerConstraint.constant = counterTimer * self.view.frame.width / 5.0
            counterTimer -= 0.01
        }
    }
    
    func restartTimer() {
        if let timerUnwraped = timer {
            timerUnwraped.fire()
        }
    }
    
    func pauseTimer() {
        self.timer?.invalidate()
    }
    
//# MARK: Database methods
    func fillDatabase() {
        let arrayProducts = ProductManager.sharedInstance.products
        
        for product in arrayProducts {
            self.productList.append(product)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                let downloader = ImageDownloader()
                let URLRequest = NSURLRequest(URL: NSURL(string: product.imageURL)!)
                downloader.downloadImage(URLRequest: URLRequest) { response in
                    if let image = response.result.value {
                        print(image)
                    }
                }
            }
        }
    }
    
    private func resetAllCounters() {
        for counterView in self.counterViewArray {
            counterView.counterImage.setImageAnimated(UIImage(named: "counter_number_start"), duration: 0.5, completion: { (finished) -> Void in
                counterView.currentNumber = -1
            })
        }
        moveCursorToIndexLabel(0)
    }
    
    private func displayCentsPrice() {
        centsLabel.text = String(rightPriceArray[rightPriceArray.count-1]! + rightPriceArray[rightPriceArray.count-2]!)
    }
    
    private func convertPrice(price: Double, ToArrayWithCapacity capacity: Int) -> Array<Int?> {
        let priceStringArray = String(price).characters.map { String($0) } as Array
        var priceIntArray: [Int?] = []
        
        for numbers in priceStringArray {
            if let intNumber = Int(numbers) {
                priceIntArray.append(intNumber)
            }
        }
        
        if priceIntArray.count < (counterViewArray.count + 2) {
            priceIntArray.append(0)
        }
        
        return priceIntArray
    }
    
    private func isPricing() -> Bool {
        for counterView in self.counterViewArray {
            if counterView.currentNumber == -1 {
                return false
            }
        }
        return true
    }
    
    private func moveCursorToIndexLabel(index: Int) {
        var indexVar = index
        if indexVar >= NUMBER_DIGIT_MAX {
            indexVar = 0
        }
        counterViewArray[cursor].isSelected = false
        counterViewArray[indexVar].isSelected = true
        cursor = indexVar
    }
    
//# MARK: IBAction mehtods
    @IBAction func digitClicked(sender: UIButton) {
        let numberClicked = sender.tag
        self.counterViewArray[cursor].startCounterAnimation(WithNumber: numberClicked) { (finished) -> Void in
            if finished {
                self.moveCursorToIndexLabel(self.cursor+1)
            }
        }
    }
    
    @IBAction func eraseAllCounters(sender: UIButton) {
        resetAllCounters()
    }
    
    @IBAction func validatePricing(sender: UIButton) {
        if isPricing() {
            var win: Bool = true
            for i in 0 ..< counterViewArray.count {
                if counterViewArray[i].currentNumber != rightPriceArray[i]! {
                    win = false
                }
            }
            
            let titleAlertView = win ? "Gagné !" : "Perdu !"
            let messageAlertView = win ? "Bravo ! Tu as trouvé le juste prix !" : "Ce n'est pas le bon prix !"
            let alertView = UIAlertController(title: titleAlertView, message: messageAlertView, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Produit suivant", style: .Cancel, handler: { (action) -> Void in
                self.counterTimer = 6
                self.timer?.invalidate()
                self.timer? = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:#selector(GameplayViewController.updateTimer), userInfo: nil, repeats: true)
                
                if self.numberProductDisplayed < self.productList.count-1 {
                    self.numberProductDisplayed += 1
                } else {
                    self.numberProductDisplayed = 0
                }
                self.startGameWithProduct(self.productList[self.numberProductDisplayed]!)
            })
            alertView.addAction(cancelAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            
            
        } else {
            print("You didn't have pricing the product!")
        }
    }
}

