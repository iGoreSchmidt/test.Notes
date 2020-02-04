//
//  MasterMasterConfigurator.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_API.RequestManager
import UIKit

public class MasterModuleConfigurator {
    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? MasterViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: MasterViewController) {

        let router = MasterRouter()
        router.transition = viewController

        let presenter = MasterPresenter()
        presenter.view = viewController
        presenter.router = router

        guard let requestManager = try? Resolver.shared.resolve() as RequestManager else { return }
        let interactor = MasterInteractor(networking: requestManager)
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
