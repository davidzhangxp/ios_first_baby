//
//  SearchProductViewController.swift
//  first-baby
//
//  Created by Max Wen on 5/12/21.
//

import UIKit

class SearchProductViewController: UIViewController {
    private let searchBar :UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        searchBar.placeholder = "Search"
        searchBar.autocapitalizationType = .none
        return searchBar
    }()

    private let tableView :UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(ProductsTableViewCell.self, forCellReuseIdentifier: ProductsTableViewCell.identifier)
        return table
    }()
    private let noResultsLabel:UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    public var products:[Product] = []
    private var results:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.becomeFirstResponder()
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        view.addSubview(noResultsLabel)
        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: view.width/4,
                                      y: view.height/2,
                                      width: view.width/2,
                                      height: 100)
    }
    
    //MARK:- Navigation
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    private func showProductView(product:Product){
        let vc = ProductViewController()
        vc.product = product
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension SearchProductViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.identifier,for: indexPath) as! ProductsTableViewCell
        cell.configure(with: results[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showProductView(product: results[indexPath.row])
        
    }

}
extension SearchProductViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
        results.removeAll()

        self.searchUsers(query: text)
        
    }
    func searchUsers(query: String){
        for product in products {
            if product.productName.lowercased().hasPrefix(query.lowercased()) || product.category.lowercased().hasPrefix(query.lowercased()){
                self.results.append(product)
            }
        }
        updateUI()
    }

    func updateUI(){
        if results.isEmpty{
            self.tableView.isHidden = true
            self.noResultsLabel.isHidden = false
            tableView.reloadData()
        }else{
            self.tableView.isHidden = false
            self.noResultsLabel.isHidden = true
            tableView.reloadData()
        }
    }
}

