//
//  ViewController.swift
//  Calculator
//
//  Created by Andrius on 04.01.17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet private weak var display: UILabel!
    private var userIsInTheMiddleOfTyping = false
    
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
            
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    //MARK: Actions
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyDisplay = display!.text!
            if textCurrentlyDisplay.range(of: ".") == nil {
                display!.text = textCurrentlyDisplay + digit
            } else if digit != "." {
                display!.text = textCurrentlyDisplay + digit
            }
        } else {
            if digit == "." {
                display!.text = "0."
            } else {
                display!.text = digit
            }
        }
        
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathSymbol)
        }
        displayValue = brain.result
    }
    
}

