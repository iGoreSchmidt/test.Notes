//
//  DeleteNoteRequest.swift
//  test.Notes.API
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation

public protocol DeleteNoteRequest: Request where BodyType == Nothing, ResponseType == Nothing {
    init(id: Int)
}
