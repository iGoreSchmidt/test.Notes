//
//  MasterMasterInitializer.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import UIKit

public class MasterModuleInitializer: NSObject {
    //Connect with object on storyboard
    @IBOutlet weak var masterViewController: MasterViewController!

    override public func awakeFromNib() {
        let configurator = MasterModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: masterViewController)
    }
}
