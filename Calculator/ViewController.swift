//
//  ViewController.swift
//  Calculator
//
//  Created by Alexander Nardozzi on 2/2/17.
//  Copyright © 2017 CSC2310. All rights reserved.
//

import UIKit

struct Stack<Element>{
    var data = [Element]()
    func top() -> Element {
        return data[data.count - 1]
    }
    mutating func pop() {
        data.removeLast()
    }
    mutating func push(_ datum: Element) {
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
    
    @IBAction func keyStrike(_ sender: UIButton) {
        let button = sender.titleLabel?.text
        
        while button != "="{
            switch button!{
                case "+", "-", "*", "/":
                    operators.push(button!)
                    operands.push(makeNumber(number))
                    operands.push(doMath())
                case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                    number.append(button!) //builds the number
                default:
                    print("Error")
            }
        }
        
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
        operands.pop()
        let a = operands.top()
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
        return ans
    }
    
    func updateDisplay(){
        let num = operands.top()
        if let displayValue = num {
            displayLabel.text = num
        } else {
            displayLabel.text = ""
        }
    }

}

