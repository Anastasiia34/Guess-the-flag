//
//  ViewController.swift
//  Project2
//
//  Created by Анастасия Стрекалова on 24.02.2020.
//  Copyright © 2020 Анастасия Стрекалова. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var contries = [String]()
    var score = 0
    var highestScore = 0
    var correctAnswer = 0
    var questionsNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedScore = UserDefaults.standard.object(forKey: "highest score") as? Data {
            do {
                highestScore = try JSONDecoder().decode(Int.self, from: savedScore)
            } catch {
                print("Failed to decode score.")
            }
        }
        
        print("Highest score: \(highestScore)")
        
        contries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(showScore))
        
        button1.layer.borderWidth = 1.0
        button2.layer.borderWidth = 1.0
        button3.layer.borderWidth = 1.0
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    private func askQuestion(action: UIAlertAction! = nil) {
        contries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: contries[0]), for: .normal)
        button2.setImage(UIImage(named: contries[1]), for: .normal)
        button3.setImage(UIImage(named: contries[2]), for: .normal)
        
        title = "\(contries[correctAnswer].uppercased()) \(score)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var alert: UIAlertController
        var title: String
        var mistakeMessage: String?
        questionsNumber += 1
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            mistakeMessage = "That's the flag of \(contries[sender.tag].uppercased()). "
            score -= 1
        }
        
        if questionsNumber != 10 {
            alert = UIAlertController(title: title, message: "\(mistakeMessage ?? "")Your score is \(score)", preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "You answered 10 questions", message: "And your score is \(score)", preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
            if self!.score > self!.highestScore {
                let jsonEncoder = JSONEncoder()
                
                if let savedData = try? jsonEncoder.encode(self?.score) {
                    let defaults = UserDefaults.standard
                    defaults.set(savedData, forKey: "highest score")
                } else {
                    print("Failed to save.")
                }
                
                let ac = UIAlertController(title: "Congrats!", message: "You beat the highest score.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: self?.askQuestion(action:)))
                self?.present(ac, animated: true)
            } else {
                self?.askQuestion()
            }
        })
        present(alert, animated: true)
    }

    @objc private func showScore() {
        let alert = UIAlertController(title: String(score), message: "It's your score", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

