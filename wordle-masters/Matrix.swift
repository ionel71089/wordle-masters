//
//  Matrix.swift
//  wordle-masters
//
//  Created by Ionel Lescai on 05.02.2022.
//

import Foundation

struct Matrix<T> {
    let numberOfRows: Int
    let numberOfColumns: Int
    
    private(set) var elements: [T]
    
    init(repeating repeatedValue: T, numberOfRows: Int, numberOfColumns: Int) {
        let numberOfRows = numberOfRows > 0 ? numberOfRows : 0
        let numberOfColumns = numberOfColumns > 0 ? numberOfColumns : 0
        
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        self.elements = Array(repeating: repeatedValue, count: numberOfRows * numberOfColumns)
    }
    
    subscript(row: Int, column: Int) -> T {
        get { elements[(row * numberOfColumns) + column] }
        set { elements[(row * numberOfColumns) + column] = newValue }
    }
}
