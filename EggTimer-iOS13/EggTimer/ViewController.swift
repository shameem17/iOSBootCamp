//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let eggTimer = ["Soft": 5, "Medium": 8, "Hard": 12]
    var timer = Timer()
    var timeLeft: Int = 0
    var timeNeeded: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressBar.progress = 0.0
        self.progressBar.progressTintColor = .red
    }

    @IBAction func hardnessSelection(_ sender: UIButton) {
        progressBar.progressTintColor = .red
        progressBar.progress = 0.0
        timer.invalidate()
        self.timeLeft = self.eggTimer[sender.currentTitle!] ?? 0
        self.timeNeeded = self.timeLeft
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        let progress = Float(self.timeNeeded - self.timeLeft)/Float(self.timeNeeded)
        if progress >= 0.75{
            progressBar.progressTintColor = .green
        }else if progress >= 0.5 && progress < 0.75{
            progressBar.progressTintColor = .yellow
        }else if progress >= 0.33 && progress < 0.5{
            progressBar.progressTintColor = .brown
        }
        self.progressBar.progress = Float(progress)
        if timeLeft > 0{
            self.titleLabel.text = "\(self.timeLeft) mins Left."
            timeLeft -= 1
           
        }else{
            timer.invalidate()
            self.titleLabel.text = "All Done!"
        }
    }
}
