//
//  DetailDetailViewController.swift
//  test.Notes
//
//  Created by zentity on 05/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note

import UIKit

public class DetailViewController: UIViewController, DetailViewInput {
    @IBOutlet weak var loader: UIActivityIndicatorView! {
        didSet {
            loader.transform = .init(scaleX: 1.333, y: 1.333)
        }
    }
    @IBOutlet weak var detailTextView: UITextView!
    lazy var editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
    lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    var output: DetailViewOutput!

    public var detailItem: Note? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        detailTextView?.text = detailItem?.title
    }

    // MARK: Life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        prepareLoader()
        output.viewIsReady()
    }

    func prepareLoader() {
        let loaderView = UIActivityIndicatorView(style: .large)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.color = .black
        loaderView.hidesWhenStopped = true
        view.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
        view.setNeedsUpdateConstraints()
        loader = loaderView
    }

    public override func setEditing(_ editing: Bool, animated: Bool) {
        detailTextView.isEditable = editing
        super.setEditing(editing, animated: animated)
        navigationItem.rightBarButtonItem = editing ? saveButton : editButton
        guard editing else { return }
        detailTextView.becomeFirstResponder()
    }

    @objc
    func edit() {
        self.setEditing(true, animated: true)
    }

    @objc
    func save() {
        self.setEditing(false, animated: true)
        detailItem?.title = detailTextView.text
        guard let note = detailItem else { return }
        output.save(note)
    }

    // MARK: DetailViewInput
    public func setupInitialState() {
        navigationItem.title = "Note"
        navigationItem.rightBarButtonItem = editButton
        configureView()
    }

    public func showLoading() {
        loader.startAnimating()
        loader.isHidden = false
    }

    public func hideLoading() {
        loader.stopAnimating()
    }

    public func display(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        alert.addAction(.init(title: "😕", style: .cancel))
        present(alert, animated: true)
    }

    public func display(_ note: Note, editing: Bool) {
        detailItem = note
        setEditing(editing, animated: true)
    }

}
