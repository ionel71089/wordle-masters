//
//  LetterMatrixTests.swift
//  wordle-mastersTests
//
//  Created by Ionel Lescai on 05.02.2022.
//

import XCTest
@testable import wordle_masters

class LetterMatrixTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testSubmitWord() throws {
        var sut = LetterMatrix(word: "EVADE")
        sut.submit(guess: "SMART")
        let word = sut.rows[0].letters.map { $0.letter }
        XCTAssertEqual(word, "SMART".characters)
    }
    
    func testSubmitWord_Correct_Wrong() throws {
        var sut = LetterMatrix(word: "EVADE")
        sut.submit(guess: "SMART")
        let states = sut.rows[0].letters.map { $0.state }
        XCTAssertEqual(states[0], "S".wrong())
        XCTAssertEqual(states[1], "M".wrong())
        XCTAssertEqual(states[2], "A".correct())
        XCTAssertEqual(states[3], "R".wrong())
        XCTAssertEqual(states[4], "T".wrong())
    }
    
    func testSubmitWord_Single_Misplaced() {
        var sut = LetterMatrix(word: "EVADE")
        sut.submit(guess: "CRAVE")
        let states = sut.rows[0].letters.map { $0.state }
        XCTAssertEqual(states[0], "C".wrong())
        XCTAssertEqual(states[1], "R".wrong())
        XCTAssertEqual(states[2], "A".correct())
        XCTAssertEqual(states[3], "V".misplaced())
        XCTAssertEqual(states[4], "E".correct())
    }
    
    func testSubmitWord_No_Misplaced() {
        var sut = LetterMatrix(word: "EVADE")
        sut.submit(guess: "EEAVE")
        let states = sut.rows[0].letters.map { $0.state }
        XCTAssertEqual(states[0], "E".correct())
        XCTAssertEqual(states[1], "E".wrong())
        XCTAssertEqual(states[2], "A".correct())
        XCTAssertEqual(states[3], "V".misplaced())
        XCTAssertEqual(states[4], "E".correct())
    }
    
    func testSubmitWord_Multiple_Misplaced() {
        var sut = LetterMatrix(word: "EVADE")
        sut.submit(guess: "EEAEV")
        let states = sut.rows[0].letters.map { $0.state }
        XCTAssertEqual(states[0], "E".correct())
        XCTAssertEqual(states[1], "E".misplaced())
        XCTAssertEqual(states[2], "A".correct())
        XCTAssertEqual(states[3], "E".wrong())
        XCTAssertEqual(states[4], "V".misplaced())
    }
    
    func test_Append() {
        var sut = LetterMatrix(word: "EVADE")
        sut.append(character: "E")
        let states = sut.rows[0].letters.map { $0.state }
        XCTAssertEqual(states[0], "E".temporary())
    }
    
    func test_Remove() {
        var sut = LetterMatrix(word: "EVADE")
        sut.append(character: "E")
        sut.append(character: "V")
        sut.removeLast()
        let states = sut.rows[0].letters.map { $0.state }
        XCTAssertEqual(states[1], .empty)
    }
}
