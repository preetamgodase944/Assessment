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
                self?.tableView.reloadData()
            }
        }
    }
    
    func registerTableViewCell() {
        tableView.register(UINib(nibName: ListRowCell.reusedentifier, bundle: nil), forCellReuseIdentifier: ListRowCell.reusedentifier)
    }
}

extension ListingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.outputs.getNumberOfImages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListRowCell.reusedentifier) as? ListRowCell,
              let model = viewModel.outputs.getPhotoModel(for: indexPath.row) else {
                  return UITableViewCell()
              }
        cell.configureCell(for: model)
        return cell
    }
}

extension ListingVC: UITableViewDelegate {
    
}
