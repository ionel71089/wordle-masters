//
//  ContentView.swift
//  wordle-masters
//
//  Created by Ionel Lescai on 05.02.2022.
//

import SwiftUI

class ViewModel: ObservableObject {
    let word: String
    @Published var matrix: LetterMatrix
    
    init(word: String) {
        self.word = word
        matrix = LetterMatrix(word: word)
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel(word: "evade")
    
    var body: some View {
        NavigationView {
            VStack {
                LetterGridView(matrix: viewModel.matrix)
                    .padding()
                
                Spacer()
                
                KeyboardView(letterMatrix: $viewModel.matrix)
            }
            .navigationTitle("Wordle")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
