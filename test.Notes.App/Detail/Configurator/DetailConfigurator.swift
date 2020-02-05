//
//  DetailDetailConfigurator.swift
//  test.Notes
//
//  Created by zentity on 05/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_API.RequestManager

import UIKit

public class DetailModuleConfigurator {

    @discardableResult
    public func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) -> DetailModuleInput? {
        guard let viewController = viewInput as? DetailViewController else { return nil }
        return configure(viewController: viewController)
    }

    private func configure(viewController: DetailViewController) -> DetailModuleInput?  {
        let router = DetailRouter()

        let presenter = DetailPresenter()
        presenter.view = viewController
        presenter.router = router

        guard let requestManager = try? Resolver.shared.resolve() as RequestManager else { return nil }
        let interactor = DetailInteractor(networking: requestManager)
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        return presenter
    }
}
