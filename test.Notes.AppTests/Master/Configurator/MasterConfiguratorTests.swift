//
//  MasterMasterConfiguratorTests.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

@testable import test_Notes_App
import Nimble
import Quick

class MasterModuleConfiguratorTests: QuickSpec {
    override func spec() {
        describe("Configurator") {
            context("while assembly module") {
                let viewController = MasterViewControllerMock()
                let configurator = MasterModuleConfigurator()

                configurator.configureModuleForViewInput(viewInput: viewController)

                it("did setup correct ViewOutput") {
                    expect(viewController.output).toNot(beNil())
                    expect(viewController.output).to(beAKindOf(MasterPresenter.self))
                }

                it("did setup correct Presenter") {
                    guard let presenter: MasterPresenter = viewController.output as? MasterPresenter else { return }
                    expect(presenter.view).toNot(beNil())
                    expect(presenter.view) === viewController
                    expect(presenter.router).toNot(beNil())
                    expect(presenter.interactor).toNot(beNil())
                }

                it("did setup correct Router") {
                    guard let presenter: MasterPresenter = viewController.output as? MasterPresenter else { return }
                    expect(presenter.router).to(beAKindOf(MasterRouter.self))

                    guard let router: MasterRouter = presenter.router as? MasterRouter else { return }
                    expect(router.transition).toNot(beNil())
                    expect(router.transition) === viewController
                }

                it("did setup correct Interactor") {
                    guard let presenter: MasterPresenter = viewController.output as? MasterPresenter else { return }
                    expect(presenter.interactor).to(beAKindOf(MasterInteractor.self))

                    guard let interactor: MasterInteractor = presenter.interactor as? MasterInteractor else { return }
                    expect(interactor.output).toNot(beNil())
                    expect(interactor.output) === presenter
                }
            }
        }
    }

    class MasterViewControllerMock: MasterViewController {

        var setupInitialStateDidCall = false

        override func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
