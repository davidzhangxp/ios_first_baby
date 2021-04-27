//
//  RegisterViewController.swift
//  first-baby
//
//  Created by Max Wen on 3/11/21.
//

import UIKit
import ProgressHUD
import FirebaseAuth

class RegisterViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let userNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "user name"
        field.autocapitalizationType = .none
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return field
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email Address"
        field.autocapitalizationType = .none
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return field
    }()
    private let lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        return field
    }()
    private let lineView3: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    private let passwordField2: UITextField = {
        let field = UITextField()
        field.placeholder = "Password confirm"
        field.isSecureTextEntry = true
        return field
    }()
    private let lineView4: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        return button
    }()

    private let loginLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.text = "You already have an account?"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("SignIn", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.link, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        setupBackgroundTouch()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        userNameField.frame = CGRect(x: 20,
                                  y: 30,
                                  width: view.width - 40,
                                  height: 42)
        lineView.frame = CGRect(x: 20, y: userNameField.bottom, width: view.width - 40, height: 2)
        emailField.frame = CGRect(x: 20,
                                  y: userNameField.bottom + 20,
                                  width: view.width - 40,
                                  height: 42)
        lineView2.frame = CGRect(x: 20, y: emailField.bottom, width: view.width - 40, height: 2)
        passwordField.frame = CGRect(x: 20,
                                     y: emailField.bottom + 20,
                                     width: view.frame.size.width - 60,
                                     height: 42)
        lineView3.frame = CGRect(x: 20, y: passwordField.bottom, width: view.width - 40, height: 2)
        passwordField2.frame = CGRect(x: 20,
                                     y: passwordField.bottom + 20,
                                     width: view.frame.size.width - 60,
                                     height: 42)
        lineView4.frame = CGRect(x: 20, y: passwordField2.bottom, width: view.width - 40, height: 2)
        registerButton.frame = CGRect(x: 20,
                                     y: passwordField2.bottom + 40,
                                     width: view.width - 40,
                                     height: 42)
       
        loginLabel.frame = CGRect(x: 20, y: registerButton.bottom + 20, width: view.width - 100, height: 28)
        
        loginButton.frame = CGRect(x: loginLabel.right + 1, y: registerButton.bottom + 20, width: 60, height: 28)
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: loginLabel.bottom + 30)
        view.addSubview(scrollView)
        scrollView.addSubview(userNameField)
        scrollView.addSubview(lineView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(lineView2)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(lineView3)
        scrollView.addSubview(passwordField2)
        scrollView.addSubview(lineView4)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(loginLabel)
        scrollView.addSubview(loginButton)
    }
    
    //MARK:-Fuctions
    @objc private func registerButtonTapped(){
        if !validatedRegister(){
            ProgressHUD.showError("Please check your email and password")
        }else{
            FUser.registerUserWith(email: emailField.text!, password: passwordField.text!, userName: userNameField.text!) { (error) in
                if error == nil{
                    self.alertMessage(with: "Verification email sent!Please verify your email")
                }else{
                    ProgressHUD.showError(error!.localizedDescription)
                }
            }
        }
    }

    private func validatedRegister() -> Bool {
        return (emailField.text != "" && passwordField.text != "" && passwordField.text == passwordField2.text)
    }
    
    @objc private func loginButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    private func alertMessage(with message:String){
        let alert = UIAlertController(title: "Message", message:message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.navigationController?.popViewController(animated: true)
        }
        ))
        present(alert, animated: true, completion: nil)
    }
    //MARK:- InteractionEnabled
    

    private func setupBackgroundTouch(){
        scrollView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        scrollView.addGestureRecognizer(tapGesture)
    }

    @objc func backgroundTap(){
        self.view.endEditing(false)
    }

}
