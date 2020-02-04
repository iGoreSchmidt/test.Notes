//
//  NoteRequestImpl.swift
//  test.Notes.API
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation
import struct test_Notes_Model.NoteImpl

public struct NoteRequestImpl: NoteRequest {
    public typealias ResponseType = NoteImpl

    public var urlRequest: NSMutableURLRequest?

    public let method = HTTPMethod.get
    public let path: String
    public let body: BodyType? = nil

    public init(id: Int) {
        self.path = "/notes/\(id)"
    }
}
