//
//  LetterSquareView.swift
//  wordle-masters
//
//  Created by Ionel Lescai on 05.02.2022.
//

import SwiftUI

struct LetterSquareView: View {
    var letter: String
    var configuration: Configuration
    
    struct Configuration {
        let backgroundColor: Color
        let foregroundColor: Color
        let borderColor: Color
        
        static let temporary = Configuration("Letter-Temporary",
                                             "Letter-Foreground-Temporary",
                                             "Letter-Border")
        
        static let wrong = Configuration("Letter-Wrong",
                                         "Letter-Foreground",
                                         "Letter-Border")
        
        static let misplaced = Configuration("Letter-Misplaced",
                                             "Letter-Foreground",
                                             "Letter-Border")
        
        static let correct = Configuration("Letter-Correct",
                                           "Letter-Foreground",
                                           "Letter-Border")
    }
    
    var body: some View {
        GeometryReader { geo in
            Text(letter)
                .foregroundColor(configuration.foregroundColor)
                .frame(width: geo.size.width, height: geo.size.width)
                .font(.system(size: geo.size.height * 0.618, weight: .bold, design: .default))
                .background(configuration.backgroundColor)
                .border(configuration.borderColor, width: 2)
        }
    }
}

extension View {
    fileprivate func previewStyle(_ index: Int) -> some View {
        let size = CGFloat([100, 80, 60, 40][index])
        
        return self
            .frame(width: size, height: size)
            .foregroundColor(.white)
            .padding()
    }
}

struct LetterView_Previews: PreviewProvider {
    static var letters: some View {
        HStack {
            LetterSquareView(letter: "A", configuration: .temporary)
                .previewStyle(0)
            
            LetterSquareView(letter: "B", configuration: .wrong)
                .previewStyle(1)
            
            LetterSquareView(letter: "C", configuration: .misplaced)
                .previewStyle(2)
            
            LetterSquareView(letter: "D", configuration: .correct)
                .previewStyle(3)
        }
    }
    
    static var previews: some View {
        letters
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Light Mode")
        
        letters
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Dark Mode")
    }
}

extension LetterSquareView.Configuration {
    init(_ background: String, _ foreground: String, _ border: String) {
        self.init(backgroundColor: Color(background),
                  foregroundColor: Color(foreground),
                  borderColor: Color(border))
    }
}
