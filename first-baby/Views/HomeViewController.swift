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
    
    var productArray:[Product] = []
    var productSection = [String]()
    var productDictionary = [String:[Product]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title="Homes"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadProducts()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        tableView.frame = view.bounds
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
}

