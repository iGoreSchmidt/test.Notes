//
//  DetailDetailInteractorOutput.swift
//  test.Notes
//
//  Created by zentity on 05/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note

import Foundation

public protocol DetailInteractorOutput: class {
    func loadFinished(_ note: Note)
    func loadFinished(_ error: Error)

    func saveFinished(_ note: Note)
    func saveFinished(_ error: Error)
}
