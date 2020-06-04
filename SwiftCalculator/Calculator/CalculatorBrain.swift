//
//  CalculatorBrain.swift
//  DrawingBoard
//
//  Created by Willian Antunes on 18/05/20.
//  Copyright © 2020 Willian Antunes. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct CalculatorBrain {
    
    private var accumulator: Int?
    @Binding var text: String
    
    init(text: Binding<String>) {
        self._text = text
    }
    
    private enum Operation {
        case clear
        case binaryOperation((Int,Int) -> Int)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "C" : Operation.clear,
        "x" : Operation.binaryOperation( { $0 * $1 } ),
        "÷" : Operation.binaryOperation( { $0 / $1 } ),
        "+" : Operation.binaryOperation( { $0 + $1 } ),
        "-" : Operation.binaryOperation( { $0 - $1 } ),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .clear:
                accumulator = 0
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Int,Int) -> Int
        let firstOperand: Int
        
        func perform(with secondOperand: Int) -> Int {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand() {
        accumulator = Int(text)
    }
    
    var result: Int? {
        get {
            return accumulator
        }
    }
    
}
