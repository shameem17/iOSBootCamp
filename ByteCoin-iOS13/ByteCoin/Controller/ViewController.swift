//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var manager = CoinManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupPicker()
        self.manager.delegate = self
    }

}

// MARK: - UIPicker Delegate
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
  
    func setupPicker(){
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.manager.currencyArray.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.manager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = self.manager.currencyArray[row]
        print("selected =\(selected)")
        self.manager.fetchExchange(for: selected)
        DispatchQueue.main.async{[weak self] in
            self?.currencyLabel.text = selected
        }
    }
    
}

// MARK: - Manager Delegate

extension ViewController: CoinManagerDelegate{
    func showError(error: any Error) {
        print("error=\(error)")
    }
    
    func showExchange(data: CoinData) {
        print("exchange=\(data)")
        DispatchQueue.main.async{[weak self] in
            self?.rateLabel.text = String(format: "%0.2f", data.rate)
        }
    }
    
    
}
