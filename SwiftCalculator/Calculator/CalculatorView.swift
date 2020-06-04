//
//  CalculatorView.swift
//  DrawingBoard
//
//  Created by Willian Antunes on 18/05/20.
//  Copyright © 2020 Willian Antunes. All rights reserved.
//

import SwiftUI

struct CalculatorButton {
    
    var id = UUID()
    var title: String
    var buttonImage: String
    
}

struct CalculatorView: View {
    
    let buttons: [CalculatorButton] = [CalculatorButton(title: "C", buttonImage: "c.square.fill"), CalculatorButton(title: "x", buttonImage: "multiply.square.fill"), CalculatorButton(title: "÷", buttonImage: "divide.square.fill"), CalculatorButton(title: "+", buttonImage: "plus.square.fill"), CalculatorButton(title: "-", buttonImage: "minus.square.fill"), CalculatorButton(title: "=", buttonImage: "equal.square.fill")]
    
    @State private var currentDrawing: Drawing = Drawing()
    @State private var drawings: [Drawing] = [Drawing]()
    @State private var color: Color = Color.white
    @State private var lineWidth: CGFloat = 25.0
    @State private var uiimage: UIImage? = nil
    @State private var rect: CGRect = .zero
    @State private var text: String = "0"
    @State private var imageClassifier: ImageClassifier?
    @State private var calculatorBrain: CalculatorBrain?
    @State private var middleOfTyping = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Text(text)
                .font(.largeTitle)
            Spacer()
            DrawingPad(currentDrawing: $currentDrawing,
                       drawings: $drawings,
                       color: $color,
                       lineWidth: $lineWidth)
                .background(RectGetter(rect: $rect))
            Spacer()
            Button(action: {
                self.uiimage = UIApplication.shared.windows[0].rootViewController?.view.asImage(rect: self.rect)
                self.imageClassifier?.updateClassifications(for: self.uiimage!)
                self.drawings.removeAll()
                if !self.middleOfTyping {
                    self.text = ""
                    self.middleOfTyping = true
                }
            }) {
                Text("Enter digit")
                    .font(.largeTitle)
            }
            Spacer()
            HStack {
                ForEach(buttons, id: \.id) { button in
                    Button(action: {
                        if self.middleOfTyping {
                            self.calculatorBrain?.setOperand()
                            self.middleOfTyping = false
                        }
                        self.calculatorBrain?.performOperation(button.title)
                        if let result = self.calculatorBrain?.result {
                            self.text = result.description
                        }
                    }) {
                        Image(systemName: button.buttonImage)
                            .font(.system(size: 50))
                    }
                }
            }
            Spacer()
        }.onAppear(perform: initialize)
    }
    
    func initialize() {
        self.imageClassifier = ImageClassifier(text: self.$text)
        self.calculatorBrain = CalculatorBrain(text: self.$text)
    }

}
