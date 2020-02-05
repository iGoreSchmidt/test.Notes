//
//  DetailDetailViewInput.swift
//  test.Notes
//
//  Created by zentity on 05/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note

public protocol DetailViewInput: class {
    /**
        Setup initial state of the view
    */
    func setupInitialState()

    func showLoading()
    func hideLoading()

    func display(_ note: Note, editing: Bool)
    func display(_ error: Error)
}

extension DetailViewInput {
    func display(_ note: Note) {
        display(note, editing: false)
    }
}
