//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 28/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    
    var player: AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func keyPressed(_ sender: UIButton) {
        let key = sender.currentTitle
        self.playSound(key: key ?? "")
    }
    
    private func playSound(key: String){
        print("sound playing")
        guard let url = Bundle.main.url(forResource: key, withExtension: "wav") else{
            print("error in resource")
            return
        }
        player = try! AVAudioPlayer(contentsOf: url)
        player.play()
        
    }

}

