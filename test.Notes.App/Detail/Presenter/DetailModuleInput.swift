//
//  DetailDetailModuleInput.swift
//  test.Notes
//
//  Created by zentity on 05/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note

public protocol DetailModuleInput: class {
    func setup(with noteId: Int?)
}
