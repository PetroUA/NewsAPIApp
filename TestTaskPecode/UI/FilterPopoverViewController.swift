//
//  FilterPopoverViewController.swift
//  TestTaskPecode
//
//  Created by Petro on 17.09.2021.
//

import Foundation
import UIKit

protocol FilterPopoverViewControllerDelegate: AnyObject {
    func filterPopoverViewControllerNeedsFilterOptions(_ filterPopoverViewController: FilterPopoverViewController) -> [NameableAndIdentifiable]
    func filterPopoverViewController(_ filterPopoverViewController: FilterPopoverViewController, isSelected filterOption: NameableAndIdentifiable) -> Bool
    
    func filterPopoverViewControllerNeedToInvertSelection(_ filterPopoverViewController: FilterPopoverViewController, for filterOption: NameableAndIdentifiable)
}

class FilterPopoverViewController: UIViewController {
    let cellReuseIdentifier = "cell"
    
    @IBOutlet var tableView: UITableView!
    
    private var filterOptions: [NameableAndIdentifiable]?
    
    weak var filterPopoverViewControllerDelegate: FilterPopoverViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterOptions = filterPopoverViewControllerDelegate?.filterPopoverViewControllerNeedsFilterOptions(self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
}

extension FilterPopoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let filterOption = filterOptions?[indexPath.row] {
            filterPopoverViewControllerDelegate?.filterPopoverViewControllerNeedToInvertSelection(self, for: filterOption)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension FilterPopoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        if let filterOption = filterOptions?[indexPath.row] {
            cell.textLabel?.text = filterOption.name
            if filterPopoverViewControllerDelegate?.filterPopoverViewController(self, isSelected: filterOption) == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions?.count ?? 0
    }
}

