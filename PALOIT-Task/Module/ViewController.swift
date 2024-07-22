//
//  ViewController.swift
//  PALOIT-Task
//
//  Created by Bhagyashree Khatri on 20/07/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ImagesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchImages()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.accessibilityIdentifier = "ImageTableView"
    }
    
    func fetchImages() {
        viewModel.fetchImages { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch images: \(error.localizedDescription)")
                // Handle error as needed (e.g., show alert)
                DispatchQueue.main.async {
                    ErrorAlertUtility.showError(in: self, error: error)
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//UITableView Delegate and Datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfImages
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageTableViewCell {
            let image = viewModel.getImage(at: indexPath.row)
            cell.selectionStyle = .none
            cell.configure(with: image)
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 // Estimated height for smooth scrolling (can change dynamically if needed)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Load more data when reaching the last cell
        if indexPath.row == viewModel.numberOfImages - 1 {
            fetchImages()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Cancel ongoing image downloads when user starts scrolling
        tableView.visibleCells.forEach { cell in
            if let imageCell = cell as? ImageTableViewCell {
                imageCell.photoImageView.sd_cancelCurrentImageLoad()
            }
        }
    }
}
