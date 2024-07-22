//
//  ViewControllerUITests.swift
//  PALOIT-TaskUITests
//
//  Created by Bhagyashree Khatri on 22/07/24.
//

import XCTest

class ViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testTableViewSetup() {
        let tableView = app.tables["ImageTableView"]
        XCTAssertTrue(tableView.exists, "The table view should exist.")
        let cell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5), "The table view should have at least one cell.")
    }

    func testFetchImages() {
        let tableView = app.tables["ImageTableView"]
        
        // Initial cell count
        let initialCellCount = tableView.cells.count
        
        // Set up expectation for the number of cells to increase
        let predicate = NSPredicate(format: "count > %d", initialCellCount)
        let expectation = expectation(for: predicate, evaluatedWith: tableView.cells, handler: nil)
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
        
        // Verify that the number of cells has increased
        XCTAssertGreaterThan(tableView.cells.count, initialCellCount, "The table view should have more cells after fetching images.")
    }
}
