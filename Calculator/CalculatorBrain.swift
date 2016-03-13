//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Min Zheng on 3/24/15.
//  Copyright (c) 2015 Min Zheng. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable //protocol
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BiaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BiaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init(){
        func learnOp(op:Op){
            knownOps[op.description] = op
        }
        learnOp(Op.BiaryOperation("✖️", *))
        // knownOps["✖️"] = Op.BiaryOperation("✖️", *)
        
        knownOps["➗"] = Op.BiaryOperation("➗"){$1 / $0}
        
        knownOps["➕"] = Op.BiaryOperation("➕", +)
        
        knownOps["➖"] = Op.BiaryOperation("➖"){$1 - $0}
        
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList { //guaranteed to be a PropertyList
        get{
            return opStack.map{$0.description}
            
            /*
            var returnValue = Array<String>()
            for op in opStack{
                returnValue.append(op.description)
            }
            return returnValue*/
        }
        set{
            if let opSymbols = newValue as? Array<String>{
                var newOpstack = [Op]()
                for opSymbol in opSymbols{
                    if let op = knownOps[opSymbol]{
                        newOpstack.append(op)
                    }else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue{
                        newOpstack.append(.Operand(operand))
                        
                    }
                }
                
                opStack = newOpstack
            }
            
            
        }
    
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
    // copy ops, read only. default let, can put var. only class is not immutable and pass reference
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand): // op
                return (operand, remainingOps)
            case .UnaryOperation( _ , let operation): //_, I dont care about this thing
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result
                {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            
            case .BiaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result
                {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        return (nil, ops);
    }
    
    func evaluate() -> Double?{
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
}