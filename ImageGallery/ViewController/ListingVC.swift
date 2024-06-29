//
//  ViewController.swift
//  ImageGallery
//
//  Created by Manish T on 28/06/24.
//

import UIKit

class ListingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var overlayView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    weak var dialogView: DialogView?
    
    var viewModel: ListingViewModel = ListingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpOnLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpOnViewAppear()
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        viewModel.outputs.reloadTableView()
    }
    
}

private extension ListingVC {
    func setUpOnLoad() {
        configureUI()
        addTapGesture()
        viewModel.inputs.fetchImages()
        bindUI()
        registerTableViewCell()
    }
    
    func setUpOnViewAppear() {
        activityIndicator.startAnimating()
    }
    
    func bindUI() {
        viewModel.reloadTableView = {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.updateTableView()
            }
        }
        
        viewModel.hideLoadingIndicator = {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func registerTableViewCell() {
        tableView.register(UINib(nibName: ListRowCell.reusedentifier, bundle: nil), forCellReuseIdentifier: ListRowCell.reusedentifier)
    }
    
    func configureUI() {
        guard let dialogView = DialogView().loadView() as? DialogView else { return }
        dialogView.layer.cornerRadius = 12
        view.addSubview(dialogView)
        
        NSLayoutConstraint.activate([
            dialogView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dialogView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dialogView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            dialogView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        self.dialogView = dialogView
        view.layoutIfNeeded()
        dialogView.isHidden = true
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    func updateTableView() {
        if viewModel.isListEmpty() {
            tableView.setEmptyView(title: Constants.TableViewEmptyState.title.rawValue, message: Constants.TableViewEmptyState.description.rawValue)
        } else {
            tableView.restore()
        }
        tableView.reloadData()
    }
    
    func didSelectRow(at index: Int) {
        guard let (model, isRowEnabled) = viewModel.outputs.getPhotoModelWithState(for: index) else { return }
        
        if isRowEnabled {
            displayDialog(for: model)
        } else {
            showRowDisabledAlert()
        }
    }
    
    func displayDialog(for model: PhotoModel) {
        if let dialogView {
            dialogView.configureUI(for: model)
            dialogView.isHidden = false
            overlayView.isHidden = false
            tableView.isUserInteractionEnabled = false
        }
    }
    
    func showRowDisabledAlert() {
        let alert = UIAlertController(title: Constants.AlertStrings.RowDisabled.title.rawValue, message: Constants.AlertStrings.RowDisabled.message.rawValue, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.AlertStrings.ButtonTitle.ok.rawValue, style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc
    func viewTapped(_ gesture: UITapGestureRecognizer) {
        let isDialogDisplayed = !(dialogView?.isHidden ?? true)
        if isDialogDisplayed {
            DispatchQueue.main.async { [weak self] in
                self?.hideDialogView()
            }
        }
    }
    
    func hideDialogView() {
        dialogView?.isHidden = true
        overlayView.isHidden = true
        tableView.isUserInteractionEnabled = true
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectRow(at: indexPath.row)
    }
}

extension ListingVC: RowSelection {
    func didToggleRowSelection(_ newValue: Bool, at index: Int) {
        viewModel.inputs.updateState(forRow: index, to: newValue)
    }
}
