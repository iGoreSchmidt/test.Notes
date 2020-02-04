//
//  MasterMasterViewInput.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note

public protocol MasterViewInput: class {
    /**
        Setup initial state of the view
    */
    func setupInitialState()

    func showLoading()
    func hideLoading()

    func display(_ list: [Note])
    func display(_ error: Error)
}

public protocol MasterViewTransition: class {
    func performSegue(withIdentifier identifier: String, sender: Any?)
    func closeDetail()
}
