//
//  DescriptionTests.swift
//  DescriptionTests
//
//  Created by Diego Freniche Brito on 5/8/21.
//

import XCTest
@testable import DescriptionFile

class DescriptionTests: XCTestCase {

    func test_Given_Empty_Lines_When_ProcessLine_Then_Returns_Empty_Array() throws {
        let result = DescriptionFile.processLines([])
        XCTAssertTrue(result.isEmpty)
    }

    func test_Given_One_Line_With_Comment_When_ProcessLine_Then_Returns_One_Line() throws {
        let result = DescriptionFile.processLines(["filename   :   comment is here"])
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result[0].name, "filename")
        XCTAssertEqual(result[0].comment, "comment is here")
    }

    func test_Given_One_Line_With_Comment_WithoutSpaces_When_ProcessLine_Then_Returns_One_Line() throws {
        let result = DescriptionFile.processLines(["filename:comment is here"])
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result[0].name, "filename")
        XCTAssertEqual(result[0].comment, "comment is here")
    }
    
    func test_Given_Some_Lines_With_Comments_When_GettingLongestFileName_Then_Returns_Correct() throws {
        let result = DescriptionFile.processLines(["filename:comment is here", "second: other"])
        let longest = DescriptionFile.longestName(inLines: result)
        XCTAssertEqual(longest, 8)
    }
    
    func test_Given_Some_Lines_With_CommentsAndTwoColons_When_GettingLongestFileName_Then_Returns_CorrectLines() throws {
        let result = DescriptionFile.processLines(["filename:comment: is: : here:", "second: other", "colon: other : more colon" ])
        
        XCTAssertEqual(result[0].name, "filename")
        XCTAssertEqual(result[0].comment, "comment: is: : here:")
        XCTAssertEqual(result[2].name, "colon")
        XCTAssertEqual(result[2].comment, "other : more colon")
    }
}
