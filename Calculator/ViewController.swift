//
//  ViewController.swift
//  Calculator
//
//  Created by azarateo on 8/2/15.
//  Copyright (c) 2015 COOL4CODE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //Instance variables
    //Outlets
    @IBOutlet weak var display: UILabel!//Early unwrapping
    @IBOutlet weak var display2: UILabel!
    //Normal instance variables
    var userIsTypingANumber = false
    var operandStack = Array<Double>()//Array, similar to ArrayList in Java specifiying the type

    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!//Constant for this method
                                        //Unwraping the optional returned by a method
        if userIsTypingANumber{
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsTypingANumber = true
            print("\(digit)")//Usinc backslash to insert a variable in a string
        }
        
    }
    
    @IBAction func enter() {
        operandStack.append(displayValue)
        if (display2.text==nil || display2.text=="0"){
            display2.text = String(displayValue) + " "
        }
        else{
            display2.text = display2.text! + String(displayValue) + " "
        }
        userIsTypingANumber = false

        print("The operand stack for the moment is: \(operandStack)")
    }
    //Calculated property
    var displayValue:Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsTypingANumber = false
        }
    }
    //Pasing functions as parameterers
    func performOperation(operation:Double->Double){//Definition of a method that uses a function as parameter
        if(operandStack.count>=1){
            displayValue = operation(operandStack.popLast()!)//Using function passed as parameter to be assigned to a variable

            enter()
        }
    }
    //Methods with the same name but different parameters
    private func performOperation(operation:(Double,Double)->Double){
        if(operandStack.count>=2){
            displayValue = operation(operandStack.popLast()!,operandStack.popLast()!)
            enter()
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        if(!(display2.text==nil)){display2.text = display2.text! + operation + " "}


        if(userIsTypingANumber){enter()}
        
        switch operation{
        case "+":performOperation{$0+$1}//Using closures to define functions Also Using $ notation to associate or reference parameters
        case "-":performOperation{(op1,op2) in op1 - op2}//Using type inference to declare the function to be pased as parameter
        case "×":performOperation( { (op1:Double,op2:Double)-> Double in op1 * op2} )// Defining the function in the parameter completely without type inference
        case "÷":performOperation(divide)//Using a referenced function
        case "√":performOperation{sqrt($0)}
        case "sin":performOperation{sin($0)}
        case "cos":performOperation{cos($0)}
        default: addConstant(operation)
        }
        
        
    }
    private func divide(op1:Double,op2:Double) -> Double{
        return op2/op1
    }
    
    @IBAction func dot() {
        if((display.text!.rangeOfString(".")) == nil){//Use of a method of String class to find a character
            display.text = display.text! + "."
            userIsTypingANumber = true
        }
    }
    
    func addConstant(constant:String){
        if userIsTypingANumber {enter()}
        switch constant{
        case "∏":displayValue = M_PI
        default: break
        }
        enter()
    }
    
    
    @IBAction func clear() {
        operandStack.removeAll()
        display.text = "0"
        display2.text = nil
        userIsTypingANumber = false
    }
    
    @IBAction func backSpace() {
        if(userIsTypingANumber){display.text = String(display.text!.characters.dropLast())}
    }
    
    
}

