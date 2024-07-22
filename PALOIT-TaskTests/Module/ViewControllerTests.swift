
import XCTest
@testable import PALOIT_Task

class ViewControllerTests: XCTestCase {

    var viewController: ViewController!
    var mockViewModel: MockImagesViewModel!
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        mockViewModel = MockImagesViewModel()
        viewController.viewModel = mockViewModel
        viewController.loadViewIfNeeded()
    }
    
    func testTableViewSetup() {
        // Ensure that tableView is connected and has the right properties
        XCTAssertNotNil(viewController.tableView, "tableView should be connected")
        XCTAssertEqual(viewController.tableView.rowHeight, UITableView.automaticDimension, "rowHeight should be automatic dimension")
        XCTAssertEqual(viewController.tableView.estimatedRowHeight, 200, "estimatedRowHeight should be 200")
        XCTAssertEqual(viewController.tableView.accessibilityIdentifier, "ImageTableView", "accessibilityIdentifier should be 'ImageTableView'")
    }
    
    func testFetchImagesSuccess() {
        let expectation = self.expectation(description: "fetchImages")
        
        // Set up the mock view model to simulate success
        mockViewModel.shouldFail = false
        mockViewModel.fetchImagesCompletion = { error in
            XCTAssertNil(error, "error should be nil")
            XCTAssertEqual(self.viewController.tableView.numberOfRows(inSection: 0), 20, "tableView should have 1 row after fetching images")
            expectation.fulfill()
        }
        
        // Call the method to fetch images and simulate it
        viewController.fetchImages()
        mockViewModel.simulateFetchImages() // Simulate the fetch operation
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
    }
    
    func testFetchImagesFailure() {
        let expectation = self.expectation(description: "fetchImages")
        mockViewModel.shouldFail = true
        viewController.fetchImages()
        expectation.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
