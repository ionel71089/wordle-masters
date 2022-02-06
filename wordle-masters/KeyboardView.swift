//
//  KeyboardView.swift
//  wordle-masters
//
//  Created by Ionel Lescai on 05.02.2022.
//

import SwiftUI

struct KeyboardView: View {
    @Binding var letterMatrix: LetterMatrix
    
    let firstRow = "QWERTYUIOP".characters
    let secondRow = "ASDFGHJKL".characters
    let thirdRow = "ZXCVBNM".characters
    
    var body: some View {
        GeometryReader { geometry in
            let keyWidth = getKeyWidth(width: geometry.size.width, spacing: 8, columns: firstRow.count)
            
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(firstRow, id: \.self) { key in
                        KeyView(key: key)
                            .frame(width: keyWidth, height: 50)
                            .onTapGesture {
                                letterMatrix.append(character: key)
                            }
                    }
                }
                
                HStack(spacing: 8) {
                    ForEach(secondRow, id: \.self) { key in
                        KeyView(key: key)
                            .frame(width: keyWidth, height: 50)
                            .onTapGesture {
                                letterMatrix.append(character: key)
                            }
                    }
                }
                
                HStack(spacing: 8) {
                    KeyView(key: "")
                        .frame(height: 50)
                        .padding(.leading, 2)
                        .overlay(
                            Image(systemName: "return")
                                .renderingMode(.template)
                                .foregroundColor(.black)
                        )
                        .onTapGesture {
                            if let input = letterMatrix.currentInput {
                                letterMatrix.submit(guess: input)
                            }
                        }
                    
                    ForEach(thirdRow, id: \.self) { key in
                        KeyView(key: key)
                            .frame(width: keyWidth, height: 50)
                            .onTapGesture {
                                letterMatrix.append(character: key)
                            }
                    }
                    
                    KeyView(key: "")
                        .padding(.trailing, 2)
                        .frame(height: 50)
                        .overlay(
                            Image(systemName: "delete.backward")
                                .renderingMode(.template)
                                .foregroundColor(.black)
                        )
                        .onTapGesture {
                            letterMatrix.removeLast()
                        }
                }
            }
            .padding(.horizontal, 2)
        }
        .frame(height: 150 + 2 * 8)
    }
}

private func getKeyWidth(width: CGFloat, spacing: CGFloat, columns: Int) -> CGFloat {
    let columns = CGFloat(columns)
    let width = (width - spacing * (columns + 1)) / columns
    return floor(width)
}

struct KeyView: View {
    let key: String
    var body: some View {
        Rectangle()
            .fill(Color("Keyboard-Background"))
            .overlay(
                Text(key)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            )
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KeyboardView(letterMatrix: .constant(LetterMatrix(word: "evade")))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            KeyboardView(letterMatrix: .constant(LetterMatrix(word: "evade")))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
