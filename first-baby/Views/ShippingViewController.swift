//
//  ShippingViewController.swift
//  first-baby
//
//  Created by Max Wen on 4/13/21.
//

import UIKit
import ProgressHUD

class ShippingViewController: UIViewController {
    var products:[Product] = []
    var totalPrice : Double!
    var isChecked = false
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "First Name"
        field.autocapitalizationType = .none
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 10
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 0))
        return field
    }()

    private let lastNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Last Name"
        field.autocapitalizationType = .none
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 10
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return field
    }()
    
    private let addressField: UITextField = {
        let field = UITextField()
        field.placeholder = "Address"
        field.autocapitalizationType = .none
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 10
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return field
    }()
    
    private let cityField: UITextField = {
        let field = UITextField()
        field.placeholder = "City"
        field.autocapitalizationType = .none
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 10
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return field
    }()
    private let postalCodeField: UITextField = {
        let field = UITextField()
        field.placeholder = "PostalCode"
        field.autocapitalizationType = .none
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 10
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return field
    }()
    private let countryField: UITextField = {
        let field = UITextField()
        field.placeholder = "Country"
        field.autocapitalizationType = .none
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 10
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return field
    }()
    private let continueToPaymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue to payment", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        return button
    }()
    private let checkbox:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "unchecked-checkbox"), for: .normal)
        return button
    }()
    private let pickupLabel:UILabel = {
        let label = UILabel()
        label.text = "Pick Up(no need address)"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .blue
        label.textAlignment = .left
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shipping Information"
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        continueToPaymentButton.addTarget(self, action: #selector(goToPayment), for: .touchUpInside)
        
        checkbox.addTarget(self, action: #selector(self.toggleCheckboxSelection), for: .touchUpInside)
        
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(addressField)
        scrollView.addSubview(cityField)
        scrollView.addSubview(postalCodeField)
        scrollView.addSubview(countryField)
        scrollView.addSubview(checkbox)
        scrollView.addSubview(pickupLabel)
        scrollView.addSubview(continueToPaymentButton)
        firstNameField.frame = CGRect(x: 20,
                                      y: 30,
                                      width: view.width - 40,
                                      height: 36)
        lastNameField.frame = CGRect(x: 20,
                                     y: firstNameField.bottom + 8,
                                     width: view.width - 40,
                                     height: 36)
        addressField.frame = CGRect(x: 20,
                                    y: lastNameField.bottom + 8,
                                    width: view.width - 40,
                                    height: 36)
        cityField.frame = CGRect(x: 20,
                                 y: addressField.bottom + 8,
                                 width: view.width - 40,
                                 height: 36)
        postalCodeField.frame = CGRect(x: 20,
                                       y: cityField.bottom + 8,
                                       width: view.width - 40,
                                       height: 36)
        countryField.frame = CGRect(x: 20,
                                    y: postalCodeField.bottom + 8,
                                    width: view.width - 40,
                                    height: 36)
        
        checkbox.frame = CGRect(x: 20,
                                y: countryField.bottom + 8,
                                width: 26,
                                height: 26)
        pickupLabel.frame = CGRect(x: checkbox.right + 8,
                                   y: countryField.bottom + 8,
                                   width: view.width - 80,
                                   height: 26)
        
        continueToPaymentButton.frame = CGRect(x: 20,
                                               y: checkbox.bottom + 20,
                                               width: view.width - 40,
                                               height: 42)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: continueToPaymentButton.bottom + 30)
        
        
    }
    
    @objc func goToPayment(){
        if validateForm(){
            let address = Shipping()
            address.firstName = firstNameField.text!
            address.lastName = lastNameField.text!
            address.address = addressField.text!
            address.city = cityField.text!
            address.postalCode = postalCodeField.text!
            address.country = countryField.text!
            address.pickup = self.isChecked
            
            let vc = PaymentViewController()
            vc.shipping = address
            vc.products = self.products
            navigationController?.pushViewController(vc, animated: true)
        }else{
            ProgressHUD.showError("Please fill in your form completely")
        }
    }
    
    private func validateForm()->Bool{
        return ( isChecked || (firstNameField.text != "" && lastNameField.text != "" && addressField.text != "" && cityField.text != ""))
        
    }
    @objc func toggleCheckboxSelection() {
        self.isChecked = !self.isChecked
        if isChecked{
            checkbox.setBackgroundImage(UIImage(named: "checked-checkbox"), for: .normal)
        }else{
            checkbox.setBackgroundImage(UIImage(named: "unchecked-checkbox"), for: .normal)
        }
    }
}
