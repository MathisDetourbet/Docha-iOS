//
//  PreferencesAboutViewController.swift
//  Docha
//
//  Created by Mathis D on 27/06/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import PBWebViewController

class PreferencesAboutConditionsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
}

class PreferencesAboutViewController: RootViewController, UITableViewDataSource, UITableViewDelegate {
    
    let titlesCell = ["Conditions générales d'utilisation", "Charte de confidentialité"]
    let webViewUrls = ["http://www.docha.fr/terms.html", "http://www.docha.fr/privacy.html"]
    var webViewController: CustomWebViewController?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBarWithTitle("À propos")
        heightTableViewConstraint.constant = CGFloat(titlesCell.count) * 44.0
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
//MARK: UITableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesCell.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idAboutConditionsCell", for: indexPath) as! PreferencesAboutConditionsCell
        cell.titleLabel.text = titlesCell[indexPath.row]
        return cell
    }
    
    
//MARK: UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        webViewController = storyboard?.instantiateViewController(withIdentifier: "idCustomWebViewController") as? CustomWebViewController
        let url = URL(string: webViewUrls[indexPath.row])
        webViewController!.url = url
        webViewController?.titleNavBar = titlesCell[indexPath.row]
        
        let activity = UIActivity()
        webViewController?.applicationActivities = [activity]
        self.navigationController?.pushViewController(webViewController!, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
