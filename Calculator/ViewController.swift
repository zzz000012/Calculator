//
//  ViewController.swift
//  Calculator
//
//  Created by Min Zheng on 3/23/15.
//  Copyright (c) 2015 Min Zheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingNumber: Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        // println("digit = \(digit)")
        
        if userIsInTheMiddleOfTypingNumber{
            display.text = display.text! + digit
        } else{
            display.text = digit
            
            userIsInTheMiddleOfTypingNumber = true
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        /*
        let operation = sender.currentTitle!

        switch operation {
        case "✖️":
            // performOperation(multiply)
            performOperation { $0 * $1 }
        case "➗":
            performOperation { $1 / $0 }
        case "➕":
            performOperation { $0 + $1 }
        case "➖":
            performOperation { $1 - $0 }
        case "√":
            performOperation{sqrt($0)}
        default: break
        }*/
        
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
        
        
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation( operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    /*
    func performOperation(operation: (Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation( operandStack.removeLast())
            enter()
        }
    }*/
    
    func multiply (op1: Double, op2: Double) -> Double {
        return op1 * op2
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        
        userIsInTheMiddleOfTypingNumber = false
        /*
        operandStack.append(displayValue)
        
        println("operandStack = \(operandStack)")*/
        
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            // userIsInTheMiddleOfTypingNumber = false
        }
    }
    
    
}

