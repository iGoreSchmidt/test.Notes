//
//  RequestManagerImpl.swift
//  test.Notes.API
//
//  Created by zentity on 03/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Combine

extension String: Error {}

open class RequestManagerImpl: RequestManager {
    public let baseURL: URL
    public let decoder = JSONDecoder()
    public let encoder = JSONEncoder()

    var session: URLSession
    public init(_ baseURL: URL, session: URLSession = URLSession.shared) {
        self.session = session
        self.baseURL = baseURL
    }

    public func send<R>(_ request: R) throws -> AnyPublisher<R.ResponseType, Error> where R : Request {
        return session
            .dataTaskPublisher(for: try (request.urlRequest as URLRequest?) ?? prepare(request))
            .tryMap { [decoder = self.decoder] result -> R.ResponseType in
                return try R.ResponseType.self == Nothing.self
                    ? Nothing() as! R.ResponseType
                    : decoder.decode(R.ResponseType.self, from: result.data)
            }
            .receive(on: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
}

extension RequestManagerImpl {
    struct Constants {
        static let timeout: TimeInterval = 5
        static let cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    }

    func url<R: Request>(for request: R) throws -> URL {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw "Internal Inconsistency Exception: can't parse `baseURL`"
        }
        components.path = request.path
        guard let url = components.url else {
            throw """
            Internal Inconsistency Exception: can't create URL for components \(baseURL.absoluteString)/\(request.path)
            """
        }
        return url
    }

    func prepare<R: Request>(_ request: R) throws -> URLRequest {
        var urlRequest = URLRequest(url: try url(for: request),
                                    cachePolicy: Constants.cachePolicy,
                                    timeoutInterval: Constants.timeout)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = ["Accept": "application/json"]
        if let body = request.body {
            urlRequest.httpBody = try encoder.encode(body)
        }
        return urlRequest
    }
}
