//
//  ViewController.swift
//  Calculator
//
//  Created by Iwaki Satoshi on 2017/07/18.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var value1 = Decimal(0)
    var value2 = Decimal(0)
    var operation: CalculatorOperation = .none
    
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
    }
    @IBAction func number1ButtonClicked(_ sender: Any) {
    }
    @IBAction func number2ButtonClicked(_ sender: Any) {
    }
    
    @IBAction func operatorEqualButtonClicked(_ sender: Any) {
    }
    @IBAction func operatorPlusButtonClicked(_ sender: Any) {
    }
}

