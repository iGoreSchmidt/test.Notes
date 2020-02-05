//
//  DetailDetailInteractor.swift
//  test.Notes
//
//  Created by zentity on 05/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import test_Notes_API
import test_Notes_Model
import Combine

public class DetailInteractor: DetailInteractorInput {
    weak var output: DetailInteractorOutput!
    let requestSender: RequestManager

    init(networking: RequestManager) {
        requestSender = networking
    }

    public func loadDetails(_ id: Int) {
        do {
            var token: AnyCancellable?
            token = try requestSender
                .send(NoteRequestImpl(id: id))
                .sink(
                    receiveCompletion: { [weak self] completion in
                        defer { token = nil }
                        guard case .failure(let error) = completion else { return }
                        OperationQueue.main.addOperation {
                            self?.output.loadFinished(error)
                        }
                    },
                    receiveValue: { [weak self] details in
                        OperationQueue.main.addOperation {
                            self?.output.loadFinished(details)
                        }
                    }
            )
        } catch {
            output.loadFinished(error)
        }
    }

    public func save(_ note: Note) {
        do {
            var token: AnyCancellable?
            token = try requestSender
                .send(SetupNoteRequestImpl(note: note))
                .sink(
                    receiveCompletion: { [weak self] completion in
                        defer { token = nil }
                        guard case .failure(let error) = completion else { return }
                        OperationQueue.main.addOperation {
                            self?.output.saveFinished(error)
                        }
                    },
                    receiveValue: { [weak self] details in
                        OperationQueue.main.addOperation {
                            self?.output.saveFinished(details)
                        }
                    }
            )
        } catch {
            output.saveFinished(error)
        }
    }
}
