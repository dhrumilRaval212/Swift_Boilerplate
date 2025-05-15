//
//  AddDeviceViewController.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil on 15/05/25.
//

import UIKit

class AddDeviceViewController: UITableViewController {
    
    var viewModel = AddDeviceViewModel()
    var onDeviceAdded: ((Device) -> Void)?
    
    // UI Elements
    private let nameTextField = UITextField()
    private let yearTextField = UITextField()
    private let priceTextField = UITextField()
    private let cpuModelTextField = UITextField()
    private let hardDiskSizeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add New Device"
        viewModel.delegate = self
        setupTableView()
        setupTextFields()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupTextFields() {
        [nameTextField, yearTextField, priceTextField, cpuModelTextField, hardDiskSizeTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        }
        
        nameTextField.placeholder = "Name"
        yearTextField.placeholder = "Year"
        yearTextField.keyboardType = .numberPad
        
        priceTextField.placeholder = "Price"
        priceTextField.keyboardType = .decimalPad
        
        cpuModelTextField.placeholder = "CPU Model"
        hardDiskSizeTextField.placeholder = "Hard Disk Size"
    }
    
    // MARK: - Actions
    
    @objc private func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func addTapped() {
        viewModel.name = nameTextField.text ?? ""
        viewModel.year = yearTextField.text ?? ""
        viewModel.price = priceTextField.text ?? ""
        viewModel.cpuModel = cpuModelTextField.text ?? ""
        viewModel.hardDiskSize = hardDiskSizeTextField.text ?? ""
        
        guard let newDevice = viewModel.createDevice() else {
            showAlert("Please fix validation errors")
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        viewModel.addDevices(deviceData: newDevice)
    }
    
  
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
  
}


extension AddDeviceViewController: PostDataProtocol {
    func postObject(_ result: Device?, error: APIError?) {
        DispatchQueue.main.async {
            if let error = error {
                self.showAlert(error.localizedDescription)
            } else if let device = result {
//                self.onDeviceAdded?(device)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddDeviceViewController {
    
    @objc private func textFieldChanged() {
        viewModel.name = nameTextField.text ?? ""
        viewModel.year = yearTextField.text ?? ""
        viewModel.price = priceTextField.text ?? ""
        viewModel.cpuModel = cpuModelTextField.text ?? ""
        viewModel.hardDiskSize = hardDiskSizeTextField.text ?? ""
        
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.isFormValid
    }
    
    // MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let textField: UITextField
        switch indexPath.row {
            case 0: textField = nameTextField
            case 1: textField = yearTextField
            case 2: textField = priceTextField
            case 3: textField = cpuModelTextField
            case 4: textField = hardDiskSizeTextField
            default: textField = UITextField()
        }
        
        textField.frame = CGRect(x: 15, y: 7, width: tableView.frame.width - 30, height: 30)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(textField)
        
        return cell
    }
}
