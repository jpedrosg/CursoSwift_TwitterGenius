//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    
    let apiKey = "API Key"
    let apiSecret = "API Secret"
    let name = "Swifter"
    let type = "plist"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let path = Bundle.main.path(forResource: name, ofType: type) else { return }
        guard let swifterDic = NSDictionary(contentsOfFile: path) else { return }
        guard let swifterKey = swifterDic.value(forKey: apiKey) as? String else { return }
        guard let swifterSecret = swifterDic.value(forKey: apiSecret) as? String else { return }
        
        let swifter = Swifter(consumerKey: swifterKey, consumerSecret: swifterSecret)
        
        
        swifter.searchTweet(using: "@Apple") { (results, metadata) in
            print(results)
        } failure: { (error) in
            print(error.localizedDescription)
        }

        
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

