//
//  PaymentViewController.swift
//  first-baby
//
//  Created by Max Wen on 4/15/21.
//

import UIKit
import Braintree

class PaymentViewController: UIViewController {
    
    var shipping:Shipping!
    var products:[Product] = []
    var braintreeClient:BTAPIClient!
    
    var itemsPrice = 0.0
    var shippingPrice = 0.0
    var taxPrice = 0.0
    var paymentPrice = 0.0
    
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
    private let footerView:UIView = {
        let view = UIView()
        return view
    }()
    private let itemPriceView: UITextView = {
        let field = UITextView()
        field.text = "Items Price:"
        field.textAlignment = .right
        field.font = .systemFont(ofSize: 16, weight: .medium)
        field.backgroundColor = .lightGray
        return field
    }()
    private let shippingPriceView: UITextView = {
        let field = UITextView()
        field.text = "Shipping Price:"
        field.textAlignment = .right
        field.font = .systemFont(ofSize: 16, weight: .medium)
        field.backgroundColor = .lightGray
        return field
    }()
    private let taxPriceView: UITextView = {
        let field = UITextView()
        field.text = "Tax Price:"
        field.textAlignment = .right
        field.font = .systemFont(ofSize: 16, weight: .medium)
        field.backgroundColor = .lightGray
        return field
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


    private let paymentButton: UIButton={
        let button = UIButton()
        button.setTitle("Continue to pay", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Payment"
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        loadPriceAddress()
        paymentButton.addTarget(self, action: #selector(payPalButtonTapped), for: .touchUpInside)
        braintreeClient = BTAPIClient(authorization: "sandbox_fwvpzxcj_rdzzpgb6vh7whv9b")
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.addSubview(footerView)
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: tableView.height, width: view.width, height: 250)
        footerView.addSubview(itemPriceView)
        footerView.addSubview(shippingPriceView)
        footerView.addSubview(taxPriceView)
        footerView.addSubview(totalPriceView)
        footerView.addSubview(shippingAddressView)

        footerView.addSubview(paymentButton)
        itemPriceView.frame = CGRect(x: 0, y: 0, width: view.width, height: 30)
        shippingPriceView.frame = CGRect(x: 0, y: 30, width: view.width, height: 30)
        taxPriceView.frame = CGRect(x: 0, y: 60, width: view.width, height: 30)
        totalPriceView.frame = CGRect(x: 0, y: 90, width: view.width, height: 30)
        shippingAddressView.frame = CGRect(x: 0, y: 130, width: view.width, height: 60)

        paymentButton.frame = CGRect(x: 0, y: 200, width: view.width, height: 40)
    }

    private func loadPriceAddress() {
        var totalPrice = 0.0
        var itemPrice = 0.0
        var shippingPrice = 10.0
        var taxPrice = 0.0
        for item in self.products {
            itemPrice += item.productPrice * Double(item.productQty)
            self.itemsPrice = itemPrice
        }
        taxPrice = Double(itemPrice * 0.15)
        self.taxPrice = taxPrice
        taxPriceView.text = "tax Price: $" + String(format: "%.2f", taxPrice)
        self.itemPriceView.text =  "Items price: " + "$\(itemPrice)"
        if shipping.pickup {
            shippingPrice = 0.0
            shippingPriceView.text = "Shipping Price:" + "$\(shippingPrice)"
            totalPrice = itemPrice + taxPrice + shippingPrice
            self.paymentPrice = totalPrice
            totalPriceView.text = "Total price :" + "$\(totalPrice)"
            shippingAddressView.text = "Shipping Address: Pick up"
        }else{
            if itemPrice > 100.0 {
                shippingPrice = 0.0
                shippingPriceView.text = "Shipping Price:" + "$\(shippingPrice)"
                totalPrice = itemPrice + taxPrice + shippingPrice
                self.paymentPrice = totalPrice
                totalPriceView.text = "Total price :" + "$\(totalPrice)"
                shippingAddressView.text = "Shipping Address: " + shipping.firstName + " " + shipping.address + "," + shipping.city + "," + shipping.postalCode
            }else{
                shippingPrice = 10.0
                shippingPriceView.text = "Shipping Price:" + "$\(shippingPrice)"
                totalPrice = itemPrice + taxPrice + shippingPrice
                self.shippingPrice = shippingPrice
                self.paymentPrice = totalPrice
                totalPriceView.text = "Total price :" + "$\(totalPrice)"
                shippingAddressView.text = "Shipping Address: " + shipping.firstName + " " + shipping.address + "," + shipping.city + "," + shipping.postalCode
            }
        }
        
    }

    @objc func payPalButtonTapped(){
        let payPalDriver = BTPayPalDriver(apiClient: self.braintreeClient)
 

        let request = BTPayPalCheckoutRequest(amount: "1.00")
        // or let request = BTPayPalVaultRequest()

        payPalDriver.tokenizePayPalAccount(with: request) { (tokenizedPayPalAccount, error) in
            guard let tokenizedPayPalAccount = tokenizedPayPalAccount else {
                if let error = error {
                    // Handle error
                } else {
                    // User canceled
                }
                return
            }
            print("Got a nonce! \(tokenizedPayPalAccount.nonce)")
            var dataToSave: [[String:Any]] = [[:]]
            var count = 0
            var preData = [[String:Any]]()
            for product in self.products{
                count += 1
                let data = product.productDictionary as! [String:Any]
                    preData.append(data)
                if count == self.products.count{
                    dataToSave = preData
                }
            }
            
            let order = Order()
                        order.userId = FUser.currentId()
                        order.orderItems = dataToSave
                        order.shipping = self.shipping.shippingDictionary as! [String:Any]
                        order.itemsPrice = self.itemsPrice
                        order.shippingPrice = self.shippingPrice
                        order.taxPrice = self.taxPrice
                        order.totalPrice = self.paymentPrice
                        order.isPaid = true
                        order.payerID = tokenizedPayPalAccount.payerID ?? ""
                        order.orderID = tokenizedPayPalAccount.nonce
            print(order.payerID)
            FirestoreClass().setNewOder(order: order)
            self.goToOrderPage(order: order)

    }
    }
    private func goToOrderPage(order:Order){
        let vc = PlaceOrderViewController()
        vc.order = order
        vc.shipping = self.shipping
        vc.products = self.products
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}
extension PaymentViewController: UITableViewDataSource,UITableViewDelegate {
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



