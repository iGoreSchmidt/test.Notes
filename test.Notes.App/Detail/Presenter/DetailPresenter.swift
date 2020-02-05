//
//  DetailDetailPresenter.swift
//  test.Notes
//
//  Created by zentity on 05/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note
import struct test_Notes_Model.NoteImpl

public class DetailPresenter {
    weak var view: DetailViewInput!
    var interactor: DetailInteractorInput!
    var router: DetailRouterInput!
    var noteId: Int?
    var isViewReady = false
}

extension DetailPresenter: DetailModuleInput {
    public func setup(with noteId: Int?) {
        self.noteId = noteId
        if isViewReady {
            setup()
        }
    }
    func setup() {
        guard let id = noteId else {
            return view.display(NoteImpl(""), editing: true)
        }
        view.showLoading()
        interactor.loadDetails(id)
    }
}

extension DetailPresenter: DetailViewOutput {
    public func viewIsReady() {
        view.setupInitialState()
        isViewReady = true
        setup()
    }

    public func save(_ note: Note) {
        view.showLoading()
        interactor.save(note)
    }
}

extension DetailPresenter: DetailInteractorOutput {
    func operationFailed(_ error: Error) {
        view.hideLoading()
        view.display(error)
    }

    public func loadFinished(_ note: Note) {
        view.display(note, editing: false)
        view.hideLoading()
    }

    public func loadFinished(_ error: Error) {
        operationFailed(error)
    }

    public func saveFinished(_ note: Note) {
        view.display(note, editing: false)
        view.hideLoading()
    }

    public func saveFinished(_ error: Error) {
        operationFailed(error)
    }
}
