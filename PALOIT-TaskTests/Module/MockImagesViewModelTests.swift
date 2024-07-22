
import XCTest
@testable import PALOIT_Task

class ImagesViewModelTests: XCTestCase {
    
    var viewModel: ImagesViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = ImagesViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testFetchImagesSuccess() {
        mockNetworkManager.shouldReturnError = false
        
        let expectation = self.expectation(description: "FetchImagesSuccess")
        
        viewModel.fetchImages { error in
            XCTAssertNil(error)
            XCTAssertEqual(self.viewModel.numberOfImages, 10)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchImagesFailure() {
        mockNetworkManager.shouldReturnError = true
        
        let expectation = self.expectation(description: "FetchImagesFailure")
        
        viewModel.fetchImages { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(self.viewModel.numberOfImages, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}

// Mock Network Manager
class MockNetworkManager: NetworkManager {
    
    var shouldReturnError = false
    
    override func fetchImages(page: Int, pagelimit: Int, url: String, completion: @escaping ([ImageModel]?, Error?) -> Void) {
        if shouldReturnError {
            completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        } else {
            let images = (0..<pagelimit).map { i in
                ImageModel(id: "\(i)", author: "Author \(i)", download_url: "https://example.com/\(i).jpg")
            }
            completion(images, nil)
        }
    }
}
