//
//  ViewController.swift
//  Calculator
//
//  Created by Iwaki Satoshi on 2017/07/18.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CalculatorDelegate {
    private let calculator = Calculator()
    private let formatter = NumberFormatter()
    private var operation :CalculatorOperator = .none
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var displayOperatorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayLabel.text = "0"
        displayOperatorLabel.text = nil;
        calculator.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Handler
    @IBAction func number0ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "0")
    }
    @IBAction func number1ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "1")
    }
    @IBAction func number2ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "2")
    }
    @IBAction func number3ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "3")
    }
    @IBAction func number4ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "4")
    }
    @IBAction func number5ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "5")
    }
    @IBAction func number6ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "6")
    }
    @IBAction func number7ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "7")
    }
    @IBAction func number8ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "8")
    }
    @IBAction func number9ButtonClicked(_ sender: Any) {
        calculator.inputDigit(by: "9")
    }
    
    @IBAction func operatorAddingButtonClicked(_ sender: Any) {
        calculator.inputOperator(.adding)
    }
    @IBAction func operatorSubtractingButtonClicked(_ sender: Any) {
        calculator.inputOperator(.subtracting)
    }
    @IBAction func operatorMultiplyingButtonClicked(_ sender: Any) {
        calculator.inputOperator(.multiplying)
    }
    @IBAction func operatorDividingButtonClicked(_ sender: Any) {
        calculator.inputOperator(.dividing)
    }

    @IBAction func operatorEqualButtonClicked(_ sender: Any) {
        calculator.caluculate()
    }
    @IBAction func clearButtonClicked(_ sender: Any) {
        calculator.clear()
    }
    @IBAction func reverseSignButtonClicked(_ sender: Any) {
        calculator.reverseSign()
    }
    @IBAction func percentButtonClicked(_ sender: Any) {
        calculator.percent()
    }
    

    func calculator(_ calculator: Calculator, didChangeDisplay display: String) {
        displayLabel.text = display;
        switch calculator.operator {
        case .adding:
            displayOperatorLabel.text = "+"
        case .subtracting:
            displayOperatorLabel.text = "-"
        case .multiplying:
            displayOperatorLabel.text = "×"
        case .dividing:
            displayOperatorLabel.text = "÷"
        default:
            displayOperatorLabel.text = nil
        }
    }
}

