//
//  DetailDetailInitializer.swift
//  test.Notes
//
//  Created by zentity on 05/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import UIKit

public class DetailModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var detailViewController: DetailViewController!

    override public func awakeFromNib() {

        let configurator = DetailModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: detailViewController)
    }

}
