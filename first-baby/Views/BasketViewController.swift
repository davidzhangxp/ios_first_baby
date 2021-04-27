//
//  BasketViewController.swift
//  first-baby
//
//  Created by Max Wen on 4/10/21.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class BasketViewController: UIViewController {
    var products:[Product] = []
    var basket:Basket?
    var totalPriceToPass = 0.0
    private let tableView:UITableView = {
        let view = UITableView()
        view.register(BasketTableViewCell.self, forCellReuseIdentifier: BasketTableViewCell.identifier)
        return view
    }()

    private let footerView:UIView = {
        let view = UIView()
        return view
    }()
    private let totalPriceText: UITextView = {
        let field = UITextView()
        field.text = "Total Price:"
        field.textAlignment = .right
        field.font = .systemFont(ofSize: 20, weight: .semibold)
        field.backgroundColor = .lightGray
        return field
    }()
    private let checkoutButton: UIButton={
        let button = UIButton()
        button.setTitle("Continue to checkout", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        return button
    }()
    private let emptyTextView: UITextView = {
        let field = UITextView()
        field.text = "Your cart is empty"
        field.textAlignment = .center
        field.font = .systemFont(ofSize: 26, weight: .semibold)
        return field
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Basket"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = footerView
        // Do any additional setup after loading the view.
        checkoutButton.addTarget(self, action: #selector(goToCheckout), for: .touchUpInside)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProducts()
    }
    private func setupUI() {
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height - 60)
        tableView.addSubview(footerView)
        footerView.addSubview(totalPriceText)
        footerView.addSubview(checkoutButton)
        footerView.frame = CGRect(x: 0, y: tableView.height, width: view.width, height: 80)
        totalPriceText.frame = CGRect(x: 10, y: 0, width: view.width - 20, height: 30)
        checkoutButton.frame = CGRect(x: 10, y: 40, width: view.width - 20, height: 36)
 
    }
    private func setupEmptyUI(){
        view.addSubview(emptyTextView)
        emptyTextView.frame = CGRect(x: 0, y: view.height/2 - 30, width: view.width, height: 60)
    }
    
    private func loadProducts(){
        if FirebaseAuth.Auth.auth().currentUser == nil{
            loginView()
        }else{
            FirestoreClass().downloadAllBasketFromFirebase(FUser.currentId()) { (allBaskets) in
                if allBaskets.isEmpty{
                    self.setupEmptyUI()
                }else{
                    self.getBasketItems(baskets: allBaskets)
                    self.setupUI()
                }
                
            }
        }
    }
    private func getBasketItems(baskets:[Basket]){
        if !baskets.isEmpty {
            FirestoreClass().downloadItems(baskets) { (allItems) in
                self.products = allItems
                self.tableView.reloadData()
                self.updateBasketTotalPrice(products: self.products)
                
            }
        }
    }
    
    private func updateBasketTotalPrice(products:[Product]) {
        var totalPrice = 0.0
        for item in products {
            totalPrice += item.productPrice * Double(item.productQty)
        }
        self.totalPriceText.text =  "Total price: " + "$\(totalPrice)"
        self.totalPriceToPass = totalPrice
    }
    //MARK:-loginAuth
    private func loginView(){
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
    }
    private func showProductView(product:Product){
        let vc = ProductViewController()
        vc.product = product
        navigationController?.pushViewController(vc, animated: true)
    }
    private func removeBasketFromFirebase(productId:String){
        FirestoreClass().downloadBasketFromFirebase(userId: FUser.currentId(), productId: productId) { (basket) in
            if basket != nil{
                FirestoreClass().deletBasketObject(basketId: basket!.id)
                self.loadProducts()
            }
        }
    }
    @objc func goToCheckout(){
        let vc = ShippingViewController()
        vc.totalPrice = self.totalPriceToPass
        vc.products = self.products
        navigationController?.pushViewController(vc, animated: true)
    }

}
extension BasketViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier) as! BasketTableViewCell
        cell.configure(with: self.products[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showProductView(product: products[indexPath.row])
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = products[indexPath.row]
            products.remove(at: indexPath.row)
            tableView.reloadData()
            removeBasketFromFirebase(productId: itemToDelete.productId)
        }
    }
}
