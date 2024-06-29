//
//  ViewController.swift
//  ImageGallery
//
//  Created by Manish T on 28/06/24.
//

import UIKit

class ListingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ListingViewModel = ListingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpOnLoad()
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        viewModel.outputs.reloadTableView()
    }
    
}

private extension ListingVC {
    func setUpOnLoad() {
        viewModel.inputs.fetchImages()
        bindUI()
        registerTableViewCell()
    }
    
    func bindUI() {
        viewModel.reloadTableView = {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.updateTableView()
            }
        }
    }
    
    func registerTableViewCell() {
        tableView.register(UINib(nibName: ListRowCell.reusedentifier, bundle: nil), forCellReuseIdentifier: ListRowCell.reusedentifier)
    }
    
    func updateTableView() {
        if viewModel.isListEmpty() {
            tableView.setEmptyView(title: "Empty List", message: "Couldn't load photos, try again later")
        } else {
            tableView.restore()
        }
        tableView.reloadData()
    }
}

extension ListingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.outputs.getNumberOfImages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListRowCell.reusedentifier) as? ListRowCell,
              let (model, isRowEnabled) = viewModel.outputs.getPhotoModelWithState(for: indexPath.row) else {
                  return UITableViewCell()
              }
        cell.tag = indexPath.row
        cell.configureCell(for: model, isEnabled: isRowEnabled, delegate: self)
        return cell
    }
}

extension ListingVC: UITableViewDelegate {
    
}

extension ListingVC: RowSelection {
    func didToggleRowSelection(_ newValue: Bool, at index: Int) {
        viewModel.inputs.updateState(forRow: index, to: newValue)
    }
}
