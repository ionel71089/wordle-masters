//
//  LetterMatrix.swift
//  wordle-masters
//
//  Created by Ionel Lescai on 05.02.2022.
//

import Foundation

enum LetterState: Equatable {
    case empty
    case temporary(letter: String)
    case wrong(letter: String)
    case misplaced(letter: String)
    case correct(letter: String)
    
    fileprivate var letter: String {
        switch self {
            case .empty:
                return ""
            case .temporary(letter: let letter):
                return letter
            case .wrong(letter: let letter):
                return letter
            case .misplaced(letter: let letter):
                return letter
            case .correct(letter: let letter):
                return letter
        }
    }
    
    func correct() -> LetterState {
        .correct(letter: letter)
    }
    
    func wrong() -> LetterState {
        .wrong(letter: letter)
    }
    
    func misplaced() -> LetterState {
        .misplaced(letter: letter)
    }
}

extension String {
    func empty() -> LetterState {
        .empty
    }
    
    func temporary() -> LetterState {
        .temporary(letter: self)
    }
    
    func correct() -> LetterState {
        .correct(letter: self)
    }
    
    func wrong() -> LetterState {
        .wrong(letter: self)
    }
    
    func misplaced() -> LetterState {
        .misplaced(letter: self)
    }
}

struct LetterData: Identifiable {
    var id: String {
        "\(row):\(column)"
    }
    
    let row, column: Int
    let state: LetterState
    
    var letter: String {
        state.letter
    }
    
    func correct() -> LetterData {
        LetterData(row: row, column: column, state: state.correct())
    }
    
    func wrong() -> LetterData {
        LetterData(row: row, column: column, state: state.wrong())
    }
    
    func misplaced() -> LetterData {
        LetterData(row: row, column: column, state: state.misplaced())
    }
}

struct LetterRow: Identifiable {
    var id: String {
        "\(letters.first!.row)"
    }
    
    let letters: [LetterData]
}

struct LetterMatrix {
    let word: String
    var rows: [LetterRow]
    private var submitted = 0
    
    init(word: String, guesses: Int = 6) {
        self.word = word.uppercased()
        rows = (0..<guesses).map { row in
            LetterRow(letters: (0..<word.count).map { LetterData(row: row, column: $0, state: .empty) })
        }
    }
    
    func submitting(guess: String) -> LetterMatrix {
        var matrix = self
        matrix.submit(guess: guess)
        return matrix
    }
    
    mutating func submit(guess: String) {
        let guess = guess.uppercased()
        guard word.count == guess.count else { return }
        var rows = self.rows
        
        var letters = guess.characters.enumerated().map { offset, letter in
            LetterData(row: submitted, column: offset, state: .temporary(letter: letter))
        }
        
        var characterCount: [String: Int] = word.characters.reduce([:]) { dict, charater in
            var dict = dict
            dict[charater] = dict[charater, default: 0] + 1
            return dict
        }
        
        for i in 0..<word.count {
            let wordLetter = word.characters[i]
            let guessLetter = guess.characters[i]
            
            if wordLetter == guessLetter {
                letters[i] = letters[i].correct()
                
                if let count = characterCount[guessLetter] {
                    characterCount[guessLetter] = count - 1
                }
            }
        }
        
        for i in 0..<word.count {
            let guessLetter = guess.characters[i]
            
            if word.characters[i] == guessLetter {
                continue
            }
            
            if characterCount[guessLetter, default: 0] > 0 {
                letters[i] = letters[i].misplaced()
            } else {
                letters[i] = letters[i].wrong()
            }
            
            if let count = characterCount[guessLetter] {
                characterCount[guessLetter] = count - 1
            }
        }
        
        rows[submitted] = LetterRow(letters: letters)
        self.rows = rows
        submitted += 1
    }
    
    func appending(character: String) -> LetterMatrix {
        var matrix = self
        matrix.append(character: character)
        return matrix
    }
    
    mutating func append(character: String) {
        guard let character = character.characters.first?.uppercased() else { return }
        var rows = self.rows
        
        var letters = rows[submitted].letters
        if let index = letters.firstIndex(where: { $0.state == .empty }) {
            letters[index] = LetterData(row: letters[index].row,
                                        column: letters[index].column,
                                        state: character.temporary())
        }
        
        rows[submitted] = LetterRow(letters: letters)
        self.rows = rows
    }
    
    func removingLast() -> LetterMatrix {
        var matrix = self
        matrix.removeLast()
        return matrix
    }
    
    mutating func removeLast() {
        var rows = self.rows
        
        var letters = rows[submitted].letters
        if let index = letters.lastIndex(where: { $0.state != .empty }) {
            letters[index] = LetterData(row: letters[index].row,
                                        column: letters[index].column,
                                        state: .empty)
        }
        
        rows[submitted] = LetterRow(letters: letters)
        self.rows = rows
    }
    
    var currentInput: String? {
        let letters = rows[submitted].letters.map { $0.state.letter }
        guard letters.count == word.count else { return nil }
        return letters.joined()
    }
}

extension StringProtocol {
    subscript(offset: Int) -> String {
        let character = self[index(startIndex, offsetBy: offset)]
        return String(character)
    }
    
    var characters: [String] {
        (0..<count).map { self[$0] }
    }
}
