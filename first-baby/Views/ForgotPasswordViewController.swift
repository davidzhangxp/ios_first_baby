//
//  ForgotPasswordViewController.swift
//  first-baby
//
//  Created by Max Wen on 3/16/21.
//

import UIKit
import ProgressHUD
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
        

    private let forgotPasswordLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Enter your email address we\'ll send you a email, you can reset you email address."
        label.numberOfLines = 0
        
        return label
    }()
        private let emailField: UITextField = {
            let field = UITextField()
            field.placeholder = "Email Address"
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
            field.autocapitalizationType = .none
            return field
        }()
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit ", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 20
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forgot Password"
        view.backgroundColor = .white
        submitButton.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        setupBackgroundTouch()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(forgotPasswordLabel)
        scrollView.addSubview(lineView)
        scrollView.addSubview(submitButton)
        scrollView.frame = view.bounds
        forgotPasswordLabel.frame = CGRect(x: 20,
                                           y: 60,
                                           width: view.width - 40,
                                           height: 90)
        emailField.frame = CGRect(x: 20,
                                  y: forgotPasswordLabel.bottom + 20,
                                  width: view.width - 40,
                                  height: 42)
        lineView.frame = CGRect(x: 20, y: emailField.bottom, width: view.width - 40, height: 2)
        submitButton.frame = CGRect(x: 20, y: emailField.bottom + 30, width: view.width - 40, height: 42)
    }
    

    @objc func forgotPasswordButtonPressed(_ sender: Any) {
        if emailField.text != ""{
            Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (error) in
                if error == nil{
                    ProgressHUD.showSuccess("Email has sent")
                }else{
                    ProgressHUD.showError(error!.localizedDescription)
                }
            }
        }else{
            ProgressHUD.showError("Please fill in your email")
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
}
