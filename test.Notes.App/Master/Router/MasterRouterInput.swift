//
//  MasterMasterRouterInput.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note
import class UIKit.UIViewController
import Foundation

public protocol MasterRouterInput {
    func showDetail(for id: Int)
    func closeDetail()
    func showNew()
    func prepare(_ destination: UIViewController, with note: Note?)
}
