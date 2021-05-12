//
//  HomeViewController.swift
//  first-baby
//
//  Created by Max Wen on 3/10/21.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private let tableView:UITableView = {
        let view = UITableView()
        view.register(ProductsTableViewCell.self, forCellReuseIdentifier: ProductsTableViewCell.identifier)
        return view
    }()
    private let searchBarButton :UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    var productArray:[Product] = []
    var productSection = [String]()
    var productDictionary = [String:[Product]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title="Menu"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        loadProducts()
        searchBarButton.addTarget(self, action: #selector(searchProduct), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        view.addSubview(searchBarButton)
        searchBarButton.frame = CGRect(x: 0, y: 0, width: view.width, height: 32)
        tableView.frame = CGRect(x: 0, y: searchBarButton.bottom + 2, width: view.width, height: view.height - 34)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.productSection.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return productSection[section].uppercased()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.productSection[section].uppercased()
        if let products = productDictionary[key]{
            return products.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.identifier,for: indexPath) as! ProductsTableViewCell
        let key = self.productSection[indexPath.section].uppercased()
        if let products = self.productDictionary[key]{
            cell.configure(with: products[indexPath.row])
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = self.productSection[indexPath.section].uppercased()
        if let products = self.productDictionary[key]{
            showProductView(product: products[indexPath.row])
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    private func loadProducts(){
        FirestoreClass().downloadProductsFromFirestore { (allProducts) in
            self.productArray = allProducts
            for product in self.productArray{
                let key = product.category.uppercased()
                if self.productDictionary[key] != nil{
                    self.productDictionary[key]!.append(product)
                }else{
                    self.productDictionary[key] = [product]
                }
                self.productSection = [String](self.productDictionary.keys).sorted()
            }
            
            self.tableView.reloadData()
        }
    }

    private func showProductView(product:Product){
        let vc = ProductViewController()
        vc.product = product
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func searchProduct(){
        let vc = SearchProductViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.products = productArray
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

