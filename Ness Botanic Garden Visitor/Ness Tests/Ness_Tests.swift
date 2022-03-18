//
//  Ness_Tests.swift
//  Ness Tests
//
//  Created by Jake Darby on 01/03/2022.
//

import XCTest
import MapKit
import UIKit
@testable import Ness_Botanic_Garden_Visitor

class Ness_Tests: XCTestCase {
    
    var sut: attractionListViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        try super.setUpWithError()
        sut = attractionListViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        sut = nil
        try super.tearDownWithError()
    }
    
    // Tests that the number of table headers is the expected value of 1
    func testNumberOfTableHeaders() {
        XCTAssertEqual(sut.numberOfSections(in: sut.tableView), 1, "The number of headers in the table is wrong")
    }
    
    // Tests that the number of rows in the table matches the number of items pulled from the plist
    func testNumberOfTableRows() {
        XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: 0), sut.sections?.count)
    }
    
    func testUserInterface() {
        
    }
}
