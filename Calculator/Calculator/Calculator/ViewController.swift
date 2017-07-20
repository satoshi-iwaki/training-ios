//
//  ViewController.swift
//  Calculator
//
//  Created by Iwaki Satoshi on 2017/07/18.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    var operation: CalculatorOperation = .none
    let calculator = Calculator()
    let formatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayLabel.text = "0"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBAction func number0ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "0")
        displayLabel.text = calculator.display();
    }
    @IBAction func number1ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "1")
        displayLabel.text = calculator.display();
    }
    @IBAction func number2ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "2")
        displayLabel.text = calculator.display();
    }
    
    @IBAction func operatorEqualButtonClicked(_ sender: Any) {
        calculator.caluculate()
        displayLabel.text = calculator.display();
    }
    @IBAction func operatorPlusButtonClicked(_ sender: Any) {
        calculator.inputOperation(.adding)
        displayLabel.text = calculator.display();
    }
}

