//
//  TableViewController.swift
//  testSalad
//
//  Created by naomi-hidaka on 2017/04/26.
//  Copyright © 2017年 naomi-hidaka. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var datasource: Datasource<User, Recipe>?

    override func viewDidLoad() {
        super.viewDidLoad()

        User.observeSingle("-KicsG6NNXIr8TAibOZF", eventType: .value) { (user) in
            guard let user: User = user as? User else {
                return
            }
        }

        let user: User = User()
        user.name = "hoge"
        user.save { (ref, error) in
            if let error = error {
                debugPrint(error)
                return
            }

            self.setupDatasource(key: ref!.key)

            for _ in 0..<10 {
                let recipe = Recipe()
                recipe.title = "カレー"
                recipe.detail = "おいしい"
                recipe.save({ (ref, error) in
                    if let error = error {
                        debugPrint(error)
                        return
                    }

                    user.recipes.insert(ref!.key)
                })
            }
        }
    }

    func setupDatasource(key: String) {
        let options: SaladaOptions = SaladaOptions()
        options.limit = 10
        options.ascending = false

        self.datasource = Datasource(parentKey: key, referenceKey: "recipes", options: options, block: { [weak self](changes) in
            guard let tableView: UITableView = self?.tableView else { return }

            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                print(error)
            }
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        configure(cell, atIndexPath: indexPath)
        return cell
    }

    func configure(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        self.datasource?.observeObject(at: indexPath.item, block: { (recipe) in
            cell.imageView?.contentMode = .scaleAspectFill
            cell.textLabel?.text = recipe?.title
            cell.detailTextLabel?.text = recipe?.detail
            cell.setNeedsLayout()
        })
    }
}
