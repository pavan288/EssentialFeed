//
//  XCTTestCaseMemoryLeakTrackingHelper.swift
//  EssentialFeedTests
//
//  Created by Pavan Powani on 28/07/21.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "instance should have been deallocated", file: file, line: line)
        }
    }
}
