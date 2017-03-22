//
//  ViewController.swift
//  Calculator
//
//  Created by Alexander Nardozzi on 2/2/17.
//  Copyright © 2017 CSC2310. All rights reserved.
//

import UIKit


//Stack class to hold any data type
class Stack<Element>{
    var data = [Element]()
    
    //Returns the element at the top of the stack
    func top() -> Element {
        return data[data.count - 1]
    }
    
    //Pops the element at the top of the stack off
    //Does NOT return the element
    func pop() {
        data.removeLast()
    }
    
    //Pushes element onto the stack
    func push(_ datum: Element) {
        print("Pushing \(datum)")
        data.append(datum)
    }
    
    //Returns a bool stating whether the stack is empty
    //True if it is empty, false if it is not
    func isEmpty() -> Bool {
        if data.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    //Prints all the elements in the stack from the bottom up
    //The value at the top of the stack will be printed last
    func printStack(){
        for i in 0..<data.count {
            print(data[i])
        }
    }
}


class ViewController: UIViewController {
    var operators = Stack<String>() //Holds operator symbols +, -, *, and /
    var operands = Stack<Double>() //Holds operands 0-9
    var number: String = "" //Holds the operand the user is currently building
    @IBOutlet var displayLabel: UILabel! //Outlet to the calculator display
    
    //Outlet to change the AC/C button from C to AC and back
    //again based on the current state of the calculator.
    //If number contains a value, C is displayed.
    //Otherwise AC is displayed.
    @IBOutlet var clearButton: UIButton!
    
    //indicator to tell the user that they are currently inside
    //a paranthesized expression
    @IBOutlet var parenthesisIndicator: UILabel!
    
    
    //Function to take a string and set the calculators display
    //to the string
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
    
    //Function to check if the number being built by the user already
    //contains a decimal point. If it does, returns true, if it does
    //not, returns false
    func checkDecimal() -> Bool {
        for i in number.characters {
            if (i == ".") {
                return true
            }
        }
        return false
    }
    
    
    //Function to clear all stacks and values held
    func allClear() {
        while !operators.isEmpty(){
            operators.pop()
        }
        while !operands.isEmpty(){
            operands.pop()
        }
        updateDisplay("")
        number = ""
        parenthesisIndicator.text = ""
    }
    
    //Function to perform simple math functions
    //Pops the needed values off the appropriate stacks
    //and returns the answer as a double
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
    
    
    
    //Function that is called whenever a button is pressed on
    //the calculator. Uses the title of the button pressed to
    //determine what to do.
    @IBAction func keyStrike(_ sender: UIButton) {
        //button becomes the pressed buttons title
        let button = sender.titleLabel?.text
            switch button!{
                case "+", "-":
                    print("pressed", button!)
                    
                    //check if calculator can perform calculation
                    if(number == "" && operands.isEmpty()){
                        updateDisplay("Error")
                        break
                    } else if (number != "") {
                        //turns the operand the user built into a double
                        //and pushes it onto the operand stack, then clears
                        //out number so a new operand can be built
                        operands.push(makeNumber(number))
                        number = ""
                    }
                    if(!operators.isEmpty() && operators.top() != "("){
                        //ensures the order of operations is followed
                        operands.push(doMath())
                    }
                    operators.push(button!)
                
                case "*", "/":
                    print("pressed", button!)
                    if(number == "" && operands.isEmpty()){
                        allClear()
                        updateDisplay("Error")
                        break
                    } else if (number != "") {
                        //turns the operand the user built into a double
                        //and pushes it onto the operand stack, then clears
                        //out number so a new operand can be built
                        operands.push(makeNumber(number))
                        number = ""
                    }
                    if !operators.isEmpty() && (operators.top() == "*" || operators.top() == "/")  && operators.top() != "(" {
                        //ensures the order of operations is followed
                        operands.push(doMath())
                    }
                    operators.push(button!)
                
                case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                    clearButton.setTitle("C", for: .normal)
                    print("pressed", button!)
                    number.append(button!) //builds the number
                    updateDisplay(number)
                
                case ".":
                    print("pressed", button!)
                    //checks if the operand being built already has a decimal
                    //if it does, break, otherwise add decimal to the number 
                    //being built and any operands inputed afterward will follow
                    //the decimal point
                    if(checkDecimal()){
                        break
                    } else {
                        number.append(button!)
                        updateDisplay(number)
                    }
                
                case "(":
                    //begins paranthesized statement, when a right parenthese is inputed
                    //the equation is processed up until the left parenthese is found
                    operators.push(button!)
                    parenthesisIndicator.text = "( )"
                case ")":
                    //ends paranthesized statement, once pressed the equation enclosed in
                    //the parenthesis is processed.
                    if(number == "" && operands.isEmpty()){
                        //checks to make sure the equation is valid
                        allClear()
                        updateDisplay("Error")
                        break
                    }
                    parenthesisIndicator.text = ""
                    print("pressed", button!)
                    operands.push(makeNumber(number))
                    while operators.top() != "(" {
                        //continues until "(" is reached
                        operands.push(doMath())
                        if(operators.isEmpty()){
                            //if the end of the operators stack is reached before a "("
                            //is found, error is printed to the screen.
                            allClear()
                            updateDisplay("Error")
                            break
                        }
                    }
                    number = ""
                    operators.pop()
                case "=":
                    if(number == "" && operands.isEmpty()){
                        //checks to make sure the user inputed a valid expression
                        allClear()
                        updateDisplay("Error")
                        break
                    }
                    print("pressed", button!)
                    //operands.printStack()
                    if(number != ""){
                        operands.push(makeNumber(number))
                    }
                    number = ""
                    while !operators.isEmpty() {
                        //performs al calculations the user entered
                        //displays the final answer in the display
                        operands.push(doMath())
                        print("Stack after doMath: ")
                        operands.printStack()
                    }
                
                case "+/-":
                    //switches operand between positive and negative
                    var currentValue = makeNumber(number)
                    if(currentValue == 0.0){
                        //if current value of operand is 0, does nothing
                        break
                    } else {
                        print("pressed", button!)
                        currentValue *= -1
                        number = "\(currentValue)"
                        updateDisplay(number)
                    }
                
                case "AC", "C":
                    //clears the display/stacks depending on the
                    //calculators current state
                    if(number != "") {
                        //if number is not empty, just clears the number
                        number = ""
                        updateDisplay("")
                        clearButton.setTitle("AC", for: .normal)
                    } else {
                        //if number is empty, clears all stacks and values
                        clearButton.setTitle("AC", for: .normal)
                        allClear()
                    }
                
                default:
                    allClear()
                    updateDisplay("Error")
                    print("Error")
                    break
        }
    }
}
