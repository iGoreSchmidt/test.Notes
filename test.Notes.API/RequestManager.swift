//
//  RequestManager.swift
//  test.Notes.API
//
//  Created by zentity on 02/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation
import struct Combine.AnyPublisher

public protocol RequestManager {
    var baseURL: URL { get }
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }

    func send<R>(_ request: R) throws -> AnyPublisher<R.ResponseType, Error> where R : Request
}
