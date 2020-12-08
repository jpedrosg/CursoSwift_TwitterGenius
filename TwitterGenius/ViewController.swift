//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS


// MARK: - Classifications

class Classification {
    static let veryPositive = 20...100
    static let middlePositive = 10...19
    static let littlePositive = 1...9
    static let neutral = 0...0
    static let littleNegative = -10...(-1)
    static let middleNegative = -19...(-11)
    static let veryNegative = -100...(-20)
}


// MARK: - ViewController

class ViewController: UIViewController {
    
    
    // MARK: IBOutlet
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    
    // MARK: Global Constants
    
    let twitterGeniusClassifier = TwitterGeniusClassifier()
    let apiKey = "API Key"
    let apiSecret = "API Secret"
    let name = "Swifter"
    let type = "plist"
    let count = 100
    let language = "en"
    let fullText = "full_text"
    
    
    // MARK: Life Cicle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: IBActions
    
    @IBAction func predictPressed(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else { return }
        guard let swifterDic = NSDictionary(contentsOfFile: path) else { return }
        guard let swifterKey = swifterDic.value(forKey: apiKey) as? String else { return }
        guard let swifterSecret = swifterDic.value(forKey: apiSecret) as? String else { return }
        guard let searchText = textField.text else { return }
        let swifter = Swifter(consumerKey: swifterKey, consumerSecret: swifterSecret)
        
        fetchTweets(swifter, searchText)
    }
    
    
    // MARK: Private Functions
    
    private func fetchTweets(_ swifter: Swifter, _ searchText: String) {
        swifter.searchTweet(using: searchText, lang: language, count: count, tweetMode: .extended) { (results, metadata) in
            let tweets = self.getTweets(from: results)
            guard let predictions = try? self.twitterGeniusClassifier.predictions(inputs: tweets) else { return }
            let sentimentScore = self.getScore(from: predictions)
            self.sentimentLabel.text = self.getSentimentText(sentimentScore)
            print("TWEET COUNT: \(tweets.count) ------ SCORE: \(sentimentScore)")
        } failure: { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func getScore(from predictions: [TwitterGeniusClassifierOutput]) -> Int {
        var sentimentScore = 0
        for prediction in predictions {
            let sentiment = prediction.label
            switch sentiment {
            case "Pos":
                sentimentScore += 1
            case "Neg":
                sentimentScore -= 1
            default: break
            }
        }
        return sentimentScore
    }
    
    private func getTweets(from results: JSON) -> [TwitterGeniusClassifierInput] {
        var tweets = [TwitterGeniusClassifierInput]()
        for i in 0..<count {
            if let tweet = results[i][self.fullText].string {
                tweets.append(TwitterGeniusClassifierInput(text: tweet))
            }
        }
        return tweets
    }
    
    private func getSentimentText(_ sentimentScore: Int) -> String {
        if Classification.veryPositive.contains(sentimentScore) {
            return "🥰"
        } else if Classification.middlePositive.contains(sentimentScore) {
            return "😊"
        } else if Classification.littlePositive.contains(sentimentScore) {
            return "🙂"
        } else if Classification.neutral.contains(sentimentScore) {
            return "😐"
        } else if Classification.littleNegative.contains(sentimentScore) {
            return "😕"
        } else if Classification.middleNegative.contains(sentimentScore) {
            return "😤"
        } else if Classification.veryNegative.contains(sentimentScore) {
            return "🤬"
        } else {
            return "😐"
        }
    }
}

