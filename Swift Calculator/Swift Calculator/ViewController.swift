//
//  ViewController.swift
//  Swift Calculator
//
//  Created by Gan Chau on 9/30/15.
//  Copyright © 2015 GC App. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            if display.text!.rangeOfString(".") == nil {
                display.text = display.text! + digit
            } else if digit != "." {
                display.text = display.text! + digit
            }
        } else {
            if digit == "." {
                display.text = "0" + digit
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
        }
        
//        print("digit = \(digit)")
    }
    
    @IBAction func operate(sender: UIButton)
    {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        switch operation {
        case "×": performDoubleDigitOperation { $1 * $0 }
        case "÷": performDoubleDigitOperation { $1 / $0 }
        case "+": performDoubleDigitOperation { $1 + $0 }
        case "−": performDoubleDigitOperation { $1 - $0 }
        case "sin": performSingleDigitOperation { sin($0 * M_PI / 180) }
        case "cos": performSingleDigitOperation { cos($0 * M_PI / 180) }
        case "√": performSingleDigitOperation { sqrt($0) }
        default: break
        }
    }
    
    @IBAction func clear()
    {
        display.text = "0"
        history.text = "0"
        userIsInTheMiddleOfTypingANumber = false
        operandStack = []
        print("operandStack = \(operandStack)")
    }
    
    func performDoubleDigitOperation(operation: (Double, Double) -> Double)
    {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performSingleDigitOperation(operation: Double -> Double)
    {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter()
    {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

