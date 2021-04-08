//
//  ViewController.swift
//  calculator
//
//  Created by Pavel Akulenak on 4.04.21.
//

import UIKit

class ViewController: UIViewController {
    private var firstNumber: Double = 0
    private var secondNumber: Double = 0
    private var result: Double = 0
    private var operation: String = ""
    private var isResultBottonFirstPress = true
    private var isMayContinueTyping = true
    private var dotIsPlased = false
    private var error = false
    private var isOperationButtonFirstPress = true

    @IBOutlet weak var displayLabel: UILabel!

    @IBAction private func onNumberButton(_ sender: UIButton) {
        if isMayContinueTyping {
            if displayLabel.text == "0" {
                displayLabel.text = sender.currentTitle
            } else {
                if let number = displayLabel.text, let digit = sender.currentTitle {
                    displayLabel.text = number + digit
                }
            }
        }
    }

    @IBAction private func onClearButton(_ sender: UIButton) {
        displayLabel.text = "0"
        firstNumber = 0
        secondNumber = 0
        result = 0
        operation = ""
        isMayContinueTyping = true
        isResultBottonFirstPress = true
        dotIsPlased = false
        error = false
        isOperationButtonFirstPress = true
    }

    @IBAction private func onDotButton(_ sender: UIButton) {
        if dotIsPlased == false {
            if let text = displayLabel.text {
                displayLabel.text = text + "."
                dotIsPlased = true
            }
        }
    }

    @IBAction private func onPlusMinusButton(_ sender: UIButton) {
        if displayLabel.text != "0" {
            if let text = displayLabel.text, var number = Double(text) {
                number = -number
                removeZeroAfterDot(number: number)
            }
        }
    }

    @IBAction private func onPersentButton(_ sender: UIButton) {
        if let text = displayLabel.text, let number = Double(text) {
            if isOperationButtonFirstPress == true {
                displayLabel.text = String(number / 100)
            } else {
                displayLabel.text = String(firstNumber * number / 100)
            }
        }
    }

    @IBAction private func onOperationButton(_ sender: UIButton) {
        if isOperationButtonFirstPress {
            if let text = displayLabel.text, let number = Double(text) {
                firstNumber = number
            }
        }
        if let text = sender.currentTitle {
            operation = text
        }
        displayLabel.text = "0"
        isMayContinueTyping = true
        dotIsPlased = false
        isOperationButtonFirstPress = false
    }

    @IBAction private func onResultButton(_ sender: UIButton) {
        if isResultBottonFirstPress {
            if let text = displayLabel.text, let number = Double(text) {
                secondNumber = number
            }
            defineSignAndCalculate(sign: operation, firstNumber: firstNumber, secondNumber: secondNumber)
            isResultBottonFirstPress = false
            isOperationButtonFirstPress = true
        } else if !isResultBottonFirstPress && isOperationButtonFirstPress {
            firstNumber = result
            defineSignAndCalculate(sign: operation, firstNumber: firstNumber, secondNumber: secondNumber)
            isOperationButtonFirstPress = true
        } else if !isResultBottonFirstPress && !isOperationButtonFirstPress {
            firstNumber = result
            if let text = displayLabel.text, let number = Double(text) {
                secondNumber = number
            }
            defineSignAndCalculate(sign: operation, firstNumber: firstNumber, secondNumber: secondNumber)
            isOperationButtonFirstPress = true
        }
        removeZeroAfterDot(number: result)
        isMayContinueTyping = false
        errorDetection(error: error)
    }

    private func defineSignAndCalculate(sign: String, firstNumber: Double, secondNumber: Double) {
        switch operation {
        case "+":
            result = firstNumber + secondNumber
        case "-":
            result = firstNumber - secondNumber
        case "×":
            result = firstNumber * secondNumber
        case "÷":
            switch secondNumber {
            case 0:
                error = true
            default:
                result = firstNumber / secondNumber
            }
        default:
            break
        }
    }

    private func removeZeroAfterDot(number: Double) {
        let array = String(number).components(separatedBy: ".")
        if array[1] == "0" {
            displayLabel.text = "\(array[0])"
        } else {
            displayLabel.text = String(number)
        }
    }

    private func errorDetection(error: Bool) {
        if error {
            displayLabel.text = "error"
        }
    }
}
