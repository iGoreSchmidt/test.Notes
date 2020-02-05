//
//  DetailDetailInteractorInput.swift
//  test.Notes
//
//  Created by zentity on 05/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note

import Foundation

public protocol DetailInteractorInput {
    func loadDetails(_ id: Int)
    func save(_ note: Note)
}
