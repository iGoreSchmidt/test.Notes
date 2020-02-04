//
//  NoteRequest.swift
//  test.Notes.API
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation
import protocol test_Notes_Model.Note

public protocol NoteRequest: Request where BodyType == Nothing, ResponseType: Note {
    init(id: Int)
}
