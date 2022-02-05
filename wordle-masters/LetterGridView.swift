//
//  LetterGridView.swift
//  wordle-masters
//
//  Created by Ionel Lescai on 05.02.2022.
//

import SwiftUI

struct LetterGridView: View {
    let matrix: LetterMatrix
    
    var body: some View {
        GeometryReader() { geometry in
            VStack(spacing: 2) {
                ForEach(matrix.rows) { row in
                    HStack(spacing: 2) {
                        ForEach(row.letters) { data in
                            LetterSquareView(letter: data.letter,
                                             configuration: data.state.viewConfiguration)
                                .square(
                                    getSquareSize(size: geometry.size,
                                                  spacing: 2,
                                                  rows: matrix.rows.count,
                                                  columns: matrix.rows[0].letters.count)
                                )
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
            .padding(.vertical, 2)
            .offset(getOffset(size: geometry.size,
                              spacing: 2,
                              rows: matrix.rows.count,
                              columns: matrix.rows[0].letters.count))
        }
    }
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
            LetterGridView(matrix: matrix)
                .frame(width: 314, height: 314)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Light Mode")
            
            LetterGridView(matrix: matrix)
                .frame(width: 262, height: 350)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Dark Mode")
        }
    }
}
