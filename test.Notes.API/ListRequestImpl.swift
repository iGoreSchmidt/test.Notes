//
//  ListRequestImpl.swift
//  test.Notes.API
//
//  Created by zentity on 02/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation
import struct test_Notes_Model.NoteImpl

public struct ListRequestImpl: ListRequest {
    public typealias ResponseType = [NoteImpl]

    public var urlRequest: NSMutableURLRequest?

    public let method = HTTPMethod.get
    public let path = "/notes"
    
    public let body: BodyType? = nil

    public init() {}
}
