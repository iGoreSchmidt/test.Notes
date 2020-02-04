//
//  DetailViewController.swift
//  test.Notes
//
//  Created by zentity on 02/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import UIKit

public class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    public var detailItem: Any? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            detailDescriptionLabel?.text = String(describing: detail)
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
}

