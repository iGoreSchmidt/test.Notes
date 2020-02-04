//
//  Note.swift
//  test.Notes.Model
//
//  Created by zentity on 02/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation

public protocol Note: Codable {
    /// Could be `nil` while `id` not initialized (create new Note)
    var id: Int! { get }

    /// Note's body
    var title: String { get set }
}
