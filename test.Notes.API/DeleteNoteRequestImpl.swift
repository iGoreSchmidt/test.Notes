//
//  DeleteNoteRequestImpl.swift
//  test.Notes.API
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation

public struct DeleteNoteRequestImpl: DeleteNoteRequest {
    public var urlRequest: NSMutableURLRequest?

    public let method = HTTPMethod.delete
    public let path: String
    public let body: BodyType? = nil

    public init(id: Int) {
        path = "/notes/\(id)"
    }
}
