//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by azarateo on 11/23/15.
//  Copyright © 2015 COOL4CODE. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    //private var OpStack = [Op]()
    private var OpStack = Array<Op>()
    
    private enum Op{
        case Operand (Double)
        case UnaryOperation (String, Double -> Double)
        case BinaryOperation (String, (Double,Double) -> Double)
    }
    
    private var availableOperations = [String:Op]()
    //private var availableOperations : Dictionary<String, Op> = Dictionary<String,Op>()
    
    init(){
        availableOperations = [
            //Symbols are also functions
            "+":Op.BinaryOperation("+",+),
            "-":Op.BinaryOperation("-",{$1-$0}),
            "*":Op.BinaryOperation("*",*),
            "/":Op.BinaryOperation("/",{$1/$0}),
            "√":Op.UnaryOperation("√",{sqrt($0)})
            //"√":Op.UnaryOperation("√",sqrt) is the same
        ]
    }
    
    func addOperand(number:Double){
        OpStack.append(Op.Operand(number))
    }
    func addOperation(operationSymbol:String){
        OpStack.append(availableOperations[operationSymbol]!)
    }
    
    private func evaluate(operandsAndOperations:[Op])->(result:Double?,remainingOps:[Op]){
        if !operandsAndOperations.isEmpty{
            //Mutable copy of the array of operands and operations stack
            var remainingOps = operandsAndOperations
            //Variable of the for the bottom of the stack
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand,remainingOps)
            case .UnaryOperation(_, let operation):
                //Constant to store the result of the next evaluation
                let nextEvaluation = evaluate(remainingOps)
                //If the result part, of the tuple (Double?,[Op]) 
                //corresponding to the next evaluation is not null 
                //then return the result and the remaining ops
                if let nextResult = nextEvaluation.result{
                    return (operation(nextResult),nextEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let binaryOperation):
                let nextEvaluation = evaluate(remainingOps)
                //If the result part, of the tuple (Double?,[Op])
                //corresponding to the next evaluation is not null
                //then check if the second evaluation is not null
                //then return the result and the remaining ops
                if let nextResult = nextEvaluation.result{
                    let secondEvaluation = evaluate(nextEvaluation.remainingOps)
                    if let secondResult = secondEvaluation.result{
                        return (binaryOperation(nextResult,secondResult),secondEvaluation.remainingOps)
                    }
                }
            }
        }
        return (nil,operandsAndOperations)
    }
    
    func evaluate(){
        
    }
    
    
    
    
}