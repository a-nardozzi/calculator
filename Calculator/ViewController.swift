//
//  ViewController.swift
//  Calculator
//
//  Created by Alexander Nardozzi on 2/2/17.
//  Copyright © 2017 CSC2310. All rights reserved.
//

import UIKit

class Stack<Element>{
    var data = [Element]()
    func top() -> Element {
        return data[data.count - 1]
    }
    func pop() {
        data.removeLast()
    }
    func push(_ datum: Element) {
        data.append(datum)
    }
    func isEmpty() -> Bool {
        if data.count == 0 {
            return true
        } else {
            return false
        }
    }
}

class ViewController: UIViewController {
    var operators = Stack<String>()
    var operands = Stack<Double>()
    var number: String = ""
    @IBOutlet var displayLabel: UILabel!
    
    func updateDisplay(_ displayValue: Double){
        displayLabel.text = String(displayValue)
    }
    
    //Function to turn a string into a double, if the string is empty it returns 0
    func makeNumber(_ num: String) -> Double {
        if(num.characters.count < 1){
            return 0
        }else{
            return Double(num)!
        }
    }
    
    func doMath() -> Double {
        var ans: Double = 0
        let b = operands.top()
        print("b:",b)
        operands.pop()
        let a = operands.top()
        print("a:", a)
        operands.pop()
        let op = operators.top()
        operators.pop()
        
        if op == "+" {
            ans=a+b
        } else if op == "-" {
            ans=a-b
        } else if op == "*" {
            ans=a*b
        } else if op == "/" {
            ans=a/b
        }
        
        print(a, op, b, "=", ans)
        updateDisplay(ans)
        return ans
    }
    
    
    
    @IBAction func keyStrike(_ sender: UIButton) {
        let button = sender.titleLabel?.text
            switch button!{
                case "+", "-":
                    print("pressed", button!)
                    operands.push(makeNumber(number))
                    number = ""
                    if(!operators.isEmpty()){
                        operands.push(doMath())
                    }
                    operators.push(button!)
                case "*", "/":
                    print("pressed", button!)
                    operands.push(makeNumber(number))
                    number = ""
                    if operators.top() == "*" || operators.top() == "/" {
                        operands.push(doMath())
                    }
                    operators.push(button!)
                case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                    print("pressed", button!)
                    number.append(button!) //builds the number
                    updateDisplay(Double(number)!)
                case "=":
                    print("pressed", button!)
                    operands.push(makeNumber(number))
                    while !operators.isEmpty() {
                        operands.push(doMath())
                    }
                default:
                    print("Error")
        }
    }
}
