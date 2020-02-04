//
//  MasterMasterInteractorOutput.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note

import Foundation

public protocol MasterInteractorOutput: class {
    func loadFinished(_ list: [Note])
    func loadFinished(_ error: Error)

    func deletionFinished(_ errorOrNil: Error?)
}

public extension MasterInteractorOutput {
    func deletionFinished() {
        deletionFinished(nil)
    }
}
