//
//  MasterMasterViewController.swift
//  test.Notes
//
//  Created by zentity on 04/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//
import protocol test_Notes_Model.Note

import UIKit

public class MasterViewController: UITableViewController, MasterViewInput {
    @IBOutlet weak var loader: UIActivityIndicatorView! {
        didSet {
            loader.transform = .init(scaleX: 1.333, y: 1.333)
        }
    }

    var output: MasterViewOutput!

    var detailViewController: DetailViewController? = nil
    var notes = [Note]()

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
        tableView.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            loaderView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 30)
        ])
        tableView.setNeedsUpdateConstraints()
        loader = loaderView
    }

    override public func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject() {
        closeDetail()
        output.addNew()
    }

    // MARK: - Segues
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = (segue.destination as? UINavigationController)?.topViewController as? DetailViewController else { return }
        detailViewController = controller
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true

        if let id = sender as? Int,
            let note = notes.first(where: { $0.id == id }) {
            return output.prepare(controller, with: note)
        }
        output.prepare(controller, with: nil)
    }

    // MARK: - Table View
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if notes.indices.contains(indexPath.row) {

            cell.textLabel?.text = notes[indexPath.row].title

        }
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard notes.indices.contains(indexPath.row) else { return }
        output.showDetail(for: notes[indexPath.row])
    }

    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    public override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard notes.indices.contains(indexPath.row) else { return }
        output.remove(notes[indexPath.row])
    }

    // MARK: MasterViewInput
    public func setupInitialState() {
        navigationItem.title = "Notes"
        navigationItem.leftBarButtonItem = editButtonItem

        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject))
        if let split = splitViewController {
            detailViewController = (split.viewControllers.last as? UINavigationController)?
                .topViewController as? DetailViewController
        }
    }

    public func showLoading() {
        loader.startAnimating()
        loader.isHidden = false
    }

    public func hideLoading() {
        loader.stopAnimating()
    }

    public func display(_ list: [Note]) {
        notes = list
        tableView.reloadData()
    }

    public func display(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        alert.addAction(.init(title: "😕", style: .cancel))
        present(alert, animated: true)
    }
}

extension MasterViewController: MasterViewTransition {
    public func closeDetail() {
        detailViewController = nil
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        guard
            let splitViewController = splitViewController,
            let master = navigationController
        else { return }
        splitViewController.viewControllers = [master]
    }
}
