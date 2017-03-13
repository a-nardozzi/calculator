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
        print("Pushing \(datum)")
        data.append(datum)
    }
    func isEmpty() -> Bool {
        if data.count == 0 {
            return true
        } else {
            return false
        }
    }
    func printStack(){
        for i in 0..<data.count {
            print(data[i])
        }
    }
}

class ViewController: UIViewController {
    var operators = Stack<String>()
    var operands = Stack<Double>()
    var number: String = ""
    @IBOutlet var displayLabel: UILabel!
    
    func updateDisplay(_ displayValue: String){
        displayLabel.text = displayValue
    }
    
    //Function to turn a string into a double, if the string is empty it returns 0
    func makeNumber(_ num: String) -> Double {
        if(num.characters.count < 1){
            return 0
        }else{
            return Double(num)!
        }
    }
    
    func checkDecimal() -> Bool {
        for i in number.characters {
            if (i == ".") {
                return true
            }
        }
        return false
    }
    
    func doMath() -> Double {
        var ans: Double = 0
        print("Stack before doMath: ")
        operands.printStack()
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
        
        print(a, op, b, "=", ans)
        updateDisplay(String(ans))
        
        return ans
    }
    
    
    
    
    
    @IBAction func keyStrike(_ sender: UIButton) {
        let button = sender.titleLabel?.text
            switch button!{
                case "+", "-":
                    print("pressed", button!)
                    if(number == "" && operands.isEmpty()){
                        updateDisplay("Error")
                        break
                    } else if (number != "") {
                        operands.push(makeNumber(number))
                        number = ""
                    }
                    if(!operators.isEmpty() && operators.top() != "("){
                        operands.push(doMath())
                    }
                    operators.push(button!)
                case "*", "/":
                    print("pressed", button!)
                    if(number == "" && operands.isEmpty()){
                        updateDisplay("Error")
                        break
                    } else if (number != "") {
                        operands.push(makeNumber(number))
                        number = ""
                    }
                    if !operators.isEmpty() && (operators.top() == "*" || operators.top() == "/")  && operators.top() != "(" {
                        operands.push(doMath())
                    }
                    operators.push(button!)
                case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                    print("pressed", button!)
                    number.append(button!) //builds the number
                    updateDisplay(number)
                case ".":
                    print("pressed", button!)
                    if(checkDecimal()){
                        break
                    } else {
                        number.append(button!)
                        updateDisplay(number)
                    }
                case "(":
                    operators.push(button!)
                case ")":
                    while operators.top() != "(" {
                        operands.push(doMath())
                    }
                    operators.pop()
                case "=":
                    print("pressed", button!)
                    //operands.printStack()
                    operands.push(makeNumber(number))
                    number = ""
                    while !operators.isEmpty() {
                        operands.push(doMath())
                        print("Stack after doMath: ")
                        operands.printStack()
                    }
                case "AC":
                    while !operators.isEmpty(){
                        operators.pop()
                    }
                    while !operands.isEmpty(){
                        operands.pop()
                    }
                    displayLabel.text = ""
                    number = ""
                default:
                    print("Error")
        }
    }
}
