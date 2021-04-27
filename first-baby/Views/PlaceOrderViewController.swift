//
//  PlaceOrderViewController.swift
//  first-baby
//
//  Created by Max Wen on 4/23/21.
//

import UIKit

class PlaceOrderViewController: UIViewController {
    var order:Order!
    var products:[Product]!
    var shipping:Shipping!
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let tableView:UITableView = {
        let view = UITableView()
        view.register(BasketTableViewCell.self, forCellReuseIdentifier: BasketTableViewCell.identifier)
        return view
    }()
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Congratulations ..."
        label.layer.masksToBounds = true
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    private let orderLabel:UILabel = {
        let label = UILabel()
        label.text = "Your order Number is:..."
        label.layer.masksToBounds = true
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let totalPriceView: UITextView = {
        let field = UITextView()
        field.text = "Total Price:"
        field.textAlignment = .right
        field.font = .systemFont(ofSize: 20, weight: .semibold)
        field.backgroundColor = .lightGray
        return field
    }()
    private let shippingAddressView: UITextView = {
        let field = UITextView()
        field.text = "Shipping Address:"
        field.textAlignment = .left
        field.font = .systemFont(ofSize: 16, weight: .medium)
        field.backgroundColor = .yellow
        
        return field
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Order Information"
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backToHome))
        // Do any additional setup after loading the view.
        setupUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.addSubview(tableView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(orderLabel)
        scrollView.addSubview(shippingAddressView)
        scrollView.addSubview(totalPriceView)
        titleLabel.frame = CGRect(x: 20, y: 5, width: view.width - 40, height: 32)
        orderLabel.frame = CGRect(x: 20, y: titleLabel.bottom + 3, width: view.width - 40, height: 60)
        shippingAddressView.frame = CGRect(x: 20, y: orderLabel.bottom + 5, width: view.width - 40, height: 60)
        totalPriceView.frame = CGRect(x: 20, y: shippingAddressView.bottom + 5, width: view.width - 40, height: 32)
        tableView.frame = CGRect(x: 20, y: totalPriceView.bottom + 5, width: view.width - 40, height: view.height - 250)
        tableView.tableFooterView = UIView()
        scrollView.contentSize = CGSize(width: view.width, height: tableView.bottom + 20)
    }
    
    @objc func backToHome(){
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "mainView") as! UITabBarController
        mainView.modalPresentationStyle = .fullScreen
        present(mainView, animated: true, completion: nil)
    }
    
    private func setupUI(){
        if self.order != nil{
            
            orderLabel.text = "Order Number is: " + order.orderID
            shippingAddressView.text = "Shipping Address: " + self.shipping.address + " " + self.shipping.city + self.shipping.postalCode
            totalPriceView.text = "Total Price: \(order.totalPrice)" 
        }
    }


}
extension PlaceOrderViewController: UITableViewDataSource,UITableViewDelegate {
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
}
