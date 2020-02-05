//
//  DetailDetailConfiguratorTests.swift
//  test.Notes
//
//  Created by zentity on 05/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

@testable import test_Notes_App
import Nimble
import Quick

class DetailModuleConfiguratorTests: QuickSpec {
    override func spec() {
        describe("Configurator") {
            context("while assembly module") {
                let viewController = DetailViewControllerMock()
                let configurator = DetailModuleConfigurator()

                configurator.configureModuleForViewInput(viewInput: viewController)

                it("did setup correct ViewOutput") {
                    expect(viewController.output).toNot(beNil())
                    expect(viewController.output).to(beAKindOf(DetailPresenter.self))
                }

                it("did setup correct Presenter") {
                    guard let presenter: DetailPresenter = viewController.output as? DetailPresenter else { return }
                    expect(presenter.view).toNot(beNil())
                    expect(presenter.view) === viewController
                    expect(presenter.router).toNot(beNil())
                    expect(presenter.interactor).toNot(beNil())
                }

                it("did setup correct Router") {
                    guard let presenter: DetailPresenter = viewController.output as? DetailPresenter else { return }
                    expect(presenter.router).to(beAKindOf(DetailRouter.self))
                }

                it("did setup correct Interactor") {
                    guard let presenter: DetailPresenter = viewController.output as? DetailPresenter else { return }
                    expect(presenter.interactor).to(beAKindOf(DetailInteractor.self))

                    guard let interactor: DetailInteractor = presenter.interactor as? DetailInteractor else { return }
                    expect(interactor.output).toNot(beNil())
                    expect(interactor.output) === presenter
                }
            }
        }
    }

    class DetailViewControllerMock: DetailViewController {

        var setupInitialStateDidCall = false

        override func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
