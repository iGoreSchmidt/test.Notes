//
//  NoteImpl.swift
//  test.Notes.Model
//
//  Created by zentity on 02/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation

public struct NoteImpl: Note {
    public let id: Int!
    public var title: String

    public init(_ title: String) {
        id = nil
        self.title = title
    }
}

extension NoteImpl: CustomStringConvertible {
    public var description: String { title }
}
