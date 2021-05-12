//
//  ProductViewController.swift
//  first-baby
//
//  Created by Max Wen on 4/3/21.
//

import UIKit
import ProgressHUD

class ProductViewController: UIViewController {

    var product:Product!
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let producImageView:UIImageView = {
        let view = UIImageView()
        return view
    }()

    private let nameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        label.textColor = .black
        label.text = "name"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let descriptionLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "description"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth=true
        return label
    }()
    private let descriptionTextView:UITextView={
        let view = UITextView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.text = "Product information"
        view.backgroundColor = .white
        return view
    }()
    private let priceLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.text = "0.0"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let qtyLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.text = "Qty:"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let qtyNumber:UITextField={
        let field = UITextField()
        field.text = "1"
        field.font = .systemFont(ofSize: 20)
        field.keyboardType = UIKeyboardType.decimalPad
        return field
    }()
    private let addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add To Cart", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(scrollView)
        scrollView.addSubview(producImageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(descriptionTextView)
        scrollView.addSubview(qtyLabel)
        scrollView.addSubview(qtyNumber)
        scrollView.addSubview(addToCartButton)
        scrollView.frame = view.bounds
        producImageView.frame = CGRect(x: 0, y: 0, width: view.width, height: 200)
        nameLabel.frame = CGRect(x: 20, y: producImageView.bottom + 6, width: view.width - 40, height: 36)
        priceLabel.frame = CGRect(x: 20, y: nameLabel.bottom + 6, width: view.width - 40, height: 32)
        descriptionLabel.frame = CGRect(x: 20, y: priceLabel.bottom + 6, width: view.width - 40, height: 30)
        descriptionTextView.frame = CGRect(x: 20, y: descriptionLabel.bottom + 2, width: view.width - 40, height: 100)
        qtyLabel.frame = CGRect(x: 20, y: descriptionTextView.bottom + 6, width: 40, height: 32)
        qtyNumber.frame = CGRect(x: qtyLabel.right + 10, y: descriptionTextView.bottom + 6, width: 40, height: 32)
        addToCartButton.frame = CGRect(x: 20, y: qtyNumber.bottom + 16, width: view.width - 40, height: 40)
        scrollView.contentSize = CGSize(width: view.width, height: addToCartButton.bottom + 30)
    }

    private func setupUI(){
        setupBackgroundTouch()
        self.nameLabel.text = product.productName
        self.descriptionTextView.text = product.description
        self.priceLabel.text = "$\(product.productPrice)"
        if product.productImg != "" {
            StorageManager.shared.downloadImage(imageUrl: product.productImg) { (image) in
                DispatchQueue.main.async {
                    self.producImageView.image = image
                }
            }
        }
    }
    
    private func setupBackgroundTouch(){
        scrollView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap(){
        self.view.endEditing(false)
    }
    
    @objc func addToCart(){
        if FUser.currentUser() != nil {
            FirestoreClass().downloadBasketFromFirebase(userId: FUser.currentId(), productId: product.productId) { (basket) in
                if basket == nil{
                    self.createNewBasket()
                }else{
                    if let qtyText = self.qtyNumber.text{
                        basket!.productQty += Int(qtyText)!
                        FirestoreClass().updateBasketInFirestore(basket!, withValues: [kPRODUCTQTY:basket!.productQty]) { (error) in
                            if error != nil{
                                ProgressHUD.showError(error?.localizedDescription)
                            }
                        }
                    }
                    ProgressHUD.showSuccess("already exist,update your basket")
                    
                }
            }
        }else{
            showLoginView()
        }
    }
    
    private func showLoginView(){
        let vc=LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Add to basket
    private func createNewBasket(){
        
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.userId = FUser.currentId()
        newBasket.productId = self.product.productId
        if let qtyText = self.qtyNumber.text{
            newBasket.productQty = Int(qtyText) ?? 1
            FirestoreClass().saveBasketToFirestore(basket: newBasket)
        }else{
            FirestoreClass().saveBasketToFirestore(basket: newBasket)
        }
        ProgressHUD.showSuccess("Add to you basket")
    }
}
