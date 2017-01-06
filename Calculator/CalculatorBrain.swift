//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Andrius on 05.01.17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var stringAccumulator = ""
    private var partialResultFlag = false
    
    func setOperand(operand: Double) {
        accumulator = operand
        
        if isPartialResult == false {
            stringAccumulator = String(operand)
        }
    }
    
    
    
    private var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant(M_PI), // M_PI,
        "e": Operation.Constant(M_E), // M_E
        "√": Operation.UnaryOperation(sqrt), // sqrt
        "cos": Operation.UnaryOperation(cos), // cos
        "±": Operation.UnaryOperation({ -$0 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "=": Operation.Equals,
        "C": Operation.Cleanup
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> (Double))
        case BinaryOperation((Double, Double) -> (Double))
        case Equals
        case Cleanup
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                stringAccumulator += symbol
            case .UnaryOperation(let function):
                executeInStringUnaryOperation(symbol: symbol)
                accumulator = function(accumulator)
                
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryOperation: function, firstOperand: accumulator)
                stringAccumulator += " \(symbol) "
                partialResultFlag = true
            case .Equals:
                executePendingBinaryOperation()
            case .Cleanup:
                accumulator = 0
                stringAccumulator = ""
                partialResultFlag = false
                pending = nil
            }
        }
    }
    
    private func executeInStringUnaryOperation(symbol: String) {
        if pending != nil {
            stringAccumulator += symbol + "(\(accumulator))"
        } else {
            stringAccumulator = symbol + "(\(stringAccumulator))"
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            if stringAccumulator.characters.last == " " {
                stringAccumulator += "\(accumulator)"
            }
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
        }
        pending = nil
        partialResultFlag = false
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryOperation: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    var description: String {
        get {
            return stringAccumulator
        }
    }
    
    var isPartialResult: Bool {
        get {
            return partialResultFlag
        }
    }
    
    
}
