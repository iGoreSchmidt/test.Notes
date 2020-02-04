//
//  MasterMasterInteractor.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import test_Notes_API
import Combine

public class MasterInteractor: MasterInteractorInput {
    let requestSender: RequestManager

    init(networking: RequestManager) {
        requestSender = networking
    }

    public func loadList() {
        do {
            var token: AnyCancellable?
            token = try requestSender
                .send(ListRequestImpl())
                .sink(
                    receiveCompletion: { [weak self] completion in
                        defer { token = nil }
                        guard case .failure(let error) = completion else { return }
                        OperationQueue.main.addOperation {
                            self?.output.loadFinished(error)
                        }
                    },
                    receiveValue: { [weak self] list in
                        OperationQueue.main.addOperation {
                            self?.output.loadFinished(list)
                        }
                    }
            )
        } catch {
            output.loadFinished(error)
        }
    }

    public func deleteItem(with id: Int) {
        do {
            var token: AnyCancellable?
            token = try requestSender
                .send(DeleteNoteRequestImpl(id: id))
                .sink(
                    receiveCompletion: { [weak self] completion in
                        defer { token = nil }
                        OperationQueue.main.addOperation {
                            guard case .failure(let error) = completion else {
                                self?.output.deletionFinished()
                                return
                            }
                            self?.output.deletionFinished(error)
                        }
                    },
                    receiveValue: { _ in }
            )
        } catch {
            output.loadFinished(error)
        }
    }

    weak var output: MasterInteractorOutput!

}
