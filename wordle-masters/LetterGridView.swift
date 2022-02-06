//
//  LetterGridView.swift
//  wordle-masters
//
//  Created by Ionel Lescai on 05.02.2022.
//

import SwiftUI

struct LetterGridView: View {
    let matrix: LetterMatrix
    
    // layout
    @State private var squareSize: CGFloat = 0
    @State private var offset: CGSize = .zero
    
    // animation state
    @State private var typingScale: Matrix<CGFloat>
    @State private var revealScale: Matrix<CGFloat>
    @State private var isRevealed: Matrix<Bool>
    
    init(matrix: LetterMatrix, revealed: Bool = false) {
        self.matrix = matrix
        _typingScale = .init(initialValue: Matrix(repeating: 1,
                                             numberOfRows: matrix.rows.count,
                                             numberOfColumns: matrix.word.count))
        
        _revealScale = .init(initialValue: Matrix(repeating: 1,
                                                  numberOfRows: matrix.rows.count,
                                                  numberOfColumns: matrix.word.count))
        
        _isRevealed = .init(initialValue: Matrix(repeating: revealed,
                                                 numberOfRows: matrix.rows.count,
                                                 numberOfColumns: matrix.word.count))
    }
    
    var body: some View {
        GeometryReader() { geometry in
            VStack(spacing: 2) {
                ForEach(matrix.rows) { row in
                    HStack(spacing: 2) {
                        ForEach(row.letters) { data in
                            LetterSquareView(letter: data.letter,
                                             configuration: reveal(data, isRevealed[data.row, data.column]).state.viewConfiguration)
                                .square(
                                    getSquareSize(size: geometry.size,
                                                  spacing: 2,
                                                  rows: matrix.rows.count,
                                                  columns: matrix.rows[0].letters.count)
                                )
                                .scaleEffect(CGSize(width: 1.0, height: revealScale[data.row, data.column]))
                                .scaleEffect(typingScale[data.row, data.column])
                                .onChange(of: data) { data in
                                    switch data.state {
                                        case .empty:
                                            typingScale[data.row, data.column] = 1.0
                                            
                                        case .temporary(letter: _):
                                            typingScale[data.row, data.column] = 1.1
                                            withAnimation {
                                                typingScale[data.row, data.column] = 1.0
                                            }
                                            
                                        default:
                                            let duration = 0.3
                                            
                                            withAnimation(.linear(duration: duration).delay(Double(data.column) * 0.2)) {
                                                revealScale[data.row, data.column] = 0
                                            }
                                                
                                            withAnimation(.linear(duration: duration).delay(duration + 0.2 + Double(data.column) * 0.2)) {
                                                isRevealed[data.row, data.column] = true
                                                revealScale[data.row, data.column] = 1
                                            }
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
            .padding(.vertical, 2)
            .offset(
                getOffset(size: geometry.size,
                          spacing: 2,
                          rows: matrix.rows.count,
                          columns: matrix.rows[0].letters.count)
            )
        }
    }
}

private func reveal(_ data: LetterData, _ revealed: Bool) -> LetterData {
    revealed ? data : data.temporary()
}

private func getLetterWidth(width: CGFloat, spacing: CGFloat, columns: CGFloat) -> CGFloat {
    (width - spacing * (columns + 1)) / columns
}

private func getLetterHeight(height: CGFloat, spacing: CGFloat, rows: CGFloat) -> CGFloat {
    (height - spacing * (rows + 1)) / rows
}

private func getSquareSize(size: CGSize, spacing: CGFloat, rows: Int, columns: Int) -> CGFloat {
    let rows = CGFloat(rows)
    let columns = CGFloat(columns)
    let width = getLetterWidth(width: size.width, spacing: spacing, columns: columns)
    let height = getLetterHeight(height: size.height, spacing: spacing, rows: rows)
    
    return min(width, height)
}

private func getOffset(size: CGSize, spacing: CGFloat, rows: Int, columns: Int) -> CGSize {
    let squareSize = getSquareSize(size: size, spacing: spacing, rows: rows, columns: columns)
    let rows = CGFloat(rows)
    let columns = CGFloat(columns)
    let width = squareSize * columns + spacing * (columns + 1)
    let height = squareSize * rows + spacing * (columns + 1)
    return CGSize(width: (size.width - width) / 2, height: (size.height - height) / 2)
}

extension LetterState {
    var viewConfiguration: LetterSquareView.Configuration {
        switch self {
            case .empty:
                return .temporary
            case .temporary(letter: _):
                return .temporary
            case .wrong(letter: _):
                return .wrong
            case .misplaced(letter: _):
                return .misplaced
            case .correct(letter: _):
                return .correct
        }
    }
}

extension View {
    fileprivate func square(_ size: CGFloat) -> some View {
        frame(width: size, height: size)
    }
}

struct LetterGridView_Previews: PreviewProvider {
    static let matrix: LetterMatrix = .init(word: "evade")
        .submitting(guess: "smart")
        .submitting(guess: "blame")
        .submitting(guess: "inane")
        .submitting(guess: "crave")
        .submitting(guess: "evade")
        .appending(character: "O")
        .appending(character: "K")
    
    static var previews: some View {
        Group {
            LetterGridView(matrix: matrix, revealed: true)
                .frame(width: 314, height: 314)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Light Mode")
            
            LetterGridView(matrix: matrix, revealed: true)
                .frame(width: 262, height: 350)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Dark Mode")
        }
    }
}
