//
//  MasterMasterPresenter.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note

public class MasterPresenter: MasterModuleInput {
    weak var view: MasterViewInput!
    var interactor: MasterInteractorInput!
    var router: MasterRouterInput!
    var list = [Note]()
    var selectedNote: Note?
}

extension MasterPresenter: MasterViewOutput {
    public func viewIsReady() {
        view.setupInitialState()
        view.showLoading()
        interactor.loadList()
    }

    public func remove(_ item: Note) {
        guard let id = item.id else { return }
        router.closeDetail()
        view.showLoading()
        selectedNote = item
        interactor.deleteItem(with: id)
    }

    public func showDetail(for item: Note) {
        guard let id = item.id else { return }
        selectedNote = item
        router.showDetail(for: id)
    }

    public func addNew() {
        router.showNew()
    }
}

extension MasterPresenter: MasterInteractorOutput {
    func operationFailed(_ error: Error) {
        view.hideLoading()
        view.display(error)
    }
    public func loadFinished(_ list: [Note]) {
        self.list = list
        view.display(list)
        view.hideLoading()
    }

    public func loadFinished(_ error: Error) {
        operationFailed(error)
    }

    public func deletionFinished(_ errorOrNil: Error?) {
        if let error = errorOrNil {
            return operationFailed(error)
        }
        guard
            let id = selectedNote?.id,
            let idx = list.firstIndex(where: { $0.id == id })
        else { return }
        list.remove(at: idx)
        view.display(list)
        view.hideLoading()
    }

}
