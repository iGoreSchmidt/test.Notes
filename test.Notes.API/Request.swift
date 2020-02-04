//
//  Request.swift
//  test.Notes.API
//
//  Created by zentity on 02/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public struct Nothing: Codable {
    public init() {}
    public init(from decoder: Decoder) throws {}
    public func encode(to encoder: Encoder) throws {}
}

public protocol Request {
    associatedtype BodyType: Encodable
    associatedtype ResponseType: Decodable

    var method: HTTPMethod { get }
    var path: String { get }
    var body: BodyType? { get }

    /// Allows custom prepare `urlRequest` that will be called by URLSession
    var urlRequest: NSMutableURLRequest? { get }
}
