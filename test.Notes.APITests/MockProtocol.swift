//
//  MockProtocol.swift
//  test.Notes.APITests
//
//  Created by zentity on 03/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation

@objc class MockProtocol: URLProtocol {
    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        var responseSent = false
        if let response = MockProtocol.property(forKey: "response", in: request) as? URLResponse {
            client?.urlProtocol(self,
                                didReceive: response,
                                cacheStoragePolicy: .notAllowed)
            responseSent = true
        }
        if let string = MockProtocol.property(forKey: "responseString", in: request) as? String  {
            if !responseSent {
                // have responseString but no response- act as Success by default
                client?.urlProtocol(self,
                                    didReceive: HTTPURLResponse(url: request.url!,
                                                                statusCode: 200,
                                                                httpVersion: kCFHTTPVersion1_1 as String,
                                                                headerFields: nil)!,
                                    cacheStoragePolicy: .notAllowed)
            }
            client?.urlProtocol(self, didLoad: Data(string.utf8))
        } else {
            let error = MockProtocol.property(forKey: "error", in: request) as? Error  ?? """
            Wrong Call MockProtocol
            At least one property (response, responseString, error) must be set
            """
            client?.urlProtocol(self, didFailWithError: error)
        }
        // mark that we've finished
        client?.urlProtocolDidFinishLoading(self)
    }

    // this method is required but doesn't need to do anything
    override func stopLoading() {

    }
}
