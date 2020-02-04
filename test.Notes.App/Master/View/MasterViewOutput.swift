//
//  MasterMasterViewOutput.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note

public protocol MasterViewOutput {
    /**
        Notify presenter that view is ready
    */
    func viewIsReady()

    func remove(_ item: Note)
    func showDetail(for item: Note)
    func addNew()
}
