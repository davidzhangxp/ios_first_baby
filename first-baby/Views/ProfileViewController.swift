//
//  ProfileViewController.swift
//  first-baby
//
//  Created by Max Wen on 4/3/21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    var orders:[Order] = []
    private let tableView:UITableView = {
        let view = UITableView()
        view.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order History"
        setupAddProductBtn()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logout))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadOrders()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        tableView.frame = view.bounds

    }
    private func setupAddProductBtn(){
        if FirebaseAuth.Auth.auth().currentUser !== nil{
            mFirestore.collection(kUSERS).document(FUser.currentId()).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else {return}
                if snapshot.exists{
                    let user = FUser(_dictionary: snapshot.data()! as NSDictionary)
                    if(user.admin == true){
                        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewProduct))
                    }
                }
            }
        }

    }

    @objc func logout(){
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        let vc=LoginViewController()
        vc.title="login"
        navigationController?.pushViewController(vc, animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
    }
    @objc func addNewProduct(){
        let vc = AddProductViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    private func loadOrders(){
        if FirebaseAuth.Auth.auth().currentUser !== nil{
            FirestoreClass().downloadAllOrdersFromFirebase(FUser.currentId()) { orderArray in
                self.orders = orderArray
                self.tableView.reloadData()
            }
        }
    }
    private func showOrderView(order:Order){
        let vc = PlaceOrderViewController()
        vc.order = order
        var products = [Product]()
        for doc in order.orderItems{
            let product = Product(_dictionary: doc as NSDictionary)
            products.append(product)
        }
        vc.products = products
        let shipping = Shipping()
        vc.shipping = shipping
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier) as! OrderTableViewCell
        cell.configure(with: self.orders[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showOrderView(order:orders[indexPath.row])
    }
}
