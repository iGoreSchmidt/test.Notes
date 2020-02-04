//
//  SetupNoteRequestImpl.swift
//  test.Notes.API
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation
import protocol test_Notes_Model.Note
import struct test_Notes_Model.NoteImpl

public struct SetupNoteRequestImpl: SetupNoteRequest {
    public typealias ResponseType = NoteImpl

    public var urlRequest: NSMutableURLRequest?

    public let method: HTTPMethod
    public let path: String
    public let body: NoteImpl?

    public init(note: Note) {
        let basePath = "/notes"
        if let id = note.id {
            method = .put
            path = basePath + "/\(id)"
            body = NoteImpl(note.title) // don't send id
        } else {
            method = .post
            path = basePath
            body = note as? NoteImpl ?? NoteImpl(note.title)
        }
    }
}
