//
//  MasterMasterRouter.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note
import class UIKit.UIViewController

public class MasterRouter: MasterRouterInput {
    public func prepare(_ destination: UIViewController, with note: Note?) {
        DetailModuleConfigurator()
            .configureModuleForViewInput(viewInput: destination)?
            .setup(with: note?.id)
    }

    weak var transition: MasterViewTransition!

    struct Segues {
        static let showDetails = "showDetail"
    }
    public func showDetail(for id: Int) {
        transition.performSegue(withIdentifier: Segues.showDetails, sender: id)
    }

    public func closeDetail() {
        transition.closeDetail()
    }

    public func showNew() {
        transition.performSegue(withIdentifier: Segues.showDetails, sender: nil)
    }
}
