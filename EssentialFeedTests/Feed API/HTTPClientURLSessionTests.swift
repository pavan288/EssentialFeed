//
//  HTTPClientURLSessionTests.swift
//  EssentialFeedTests
//
//  Created by Pavan Powani on 13/07/21.
//

import XCTest
import EssentialFeed

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask
}

protocol HTTPSessionTask {
    func resume()
}

class URLSessionHTTPClient {
    private let session: HTTPSession

    init(session: HTTPSession) {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class HTTPClientURLSessionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getFromURL_resumesDataTaskWithURL() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let url = URL(string: "https://any-url.com")!
        let session = HTTPSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)

        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url) { _ in }

        XCTAssertEqual(task.resumeCallCount, 1)
    }

    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://any-url.com")!
        let session = HTTPSessionSpy()
        let error = NSError(domain: "any error", code: 1)
        session.stub(url: url, error: error)

        let sut = URLSessionHTTPClient(session: session)

        let exp = expectation(description: "Wait for completion")
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }

            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: Helpers
    private class HTTPSessionSpy: HTTPSession {
        private var stubs = [URL: Stub]()

        private struct Stub {
            let task: HTTPSessionTask
            let error: NSError?
        }

        func stub(url: URL, task: HTTPSessionTask = FakeURLSessionDataTask(), error: NSError? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask {
            guard let stub = stubs[url] else { fatalError("Couldnt find stub for the given url") }
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }

    private class FakeURLSessionDataTask: HTTPSessionTask {
        func resume() {}
    }
    private class URLSessionDataTaskSpy: HTTPSessionTask {
        var resumeCallCount = 0

        func resume() {
            resumeCallCount += 1
        }
    }
}
