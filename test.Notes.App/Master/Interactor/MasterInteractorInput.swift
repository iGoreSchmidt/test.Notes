//
//  MasterMasterInteractorInput.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation

public protocol MasterInteractorInput {
    func loadList()
    func deleteItem(with id: Int)
}
