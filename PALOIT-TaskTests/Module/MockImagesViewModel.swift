import Foundation
import UIKit
@testable import PALOIT_Task

class MockImagesViewModel: ImagesViewModel {
    var fetchImagesCompletion: ((Error?) -> Void)?
    var shouldFail = false
    
    func simulateFetchImages() {
        // Simulate asynchronous behavior
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.shouldFail {
                self.fetchImagesCompletion?(NSError(domain: "TestError", code: 0, userInfo: nil))
            } else {
                // Simulate success with dummy data
                self.fetchImagesCompletion?(nil)
            }
        }
    }
}
