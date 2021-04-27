//
//  LoginViewController.swift
//  first-baby
//
//  Created by Max Wen on 3/10/21.
//

import UIKit
import ProgressHUD
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInDelegate, LoginButtonDelegate {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email Address"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.autocapitalizationType = .none
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
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot password?", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.link, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .light)
        button.contentHorizontalAlignment = .right
        return button
    }()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login ", for: .normal)
        button.backgroundColor = .systemRed
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    private let googleLoginButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "btn_google.png")
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
//    private let facebookLoginButton: UIButton = {
//        let button = UIButton()
//        let image = UIImage(named: "btn_facebook.png")
//        button.setBackgroundImage(image, for: .normal)
//        return button
//    }()

    private let signupLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.text = "You don't have an account?"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Signup ", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.link, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.contentHorizontalAlignment = .left
        return button
    }()
    let facebookLoginButton = FBLoginButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        title="Login"
        view.backgroundColor = .white
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
//        facebookLoginButton.addTarget(self, action: #selector(facebookLogin), for: .touchUpInside)
        setupBackgroundTouch()
        GIDSignIn.sharedInstance().delegate = self
        
        facebookLoginButton.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(lineView)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(lineView2)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(googleLoginButton)
        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(forgotPasswordButton)
        scrollView.addSubview(signupLabel)
        scrollView.addSubview(signupButton)
        emailField.frame = CGRect(x: 20,
                                  y: 30,
                                  width: view.width - 40,
                                  height: 42)
        lineView.frame = CGRect(x: 20, y: emailField.bottom, width: view.width - 40, height: 2)
        passwordField.frame = CGRect(x: 20,
                                     y: emailField.bottom + 20,
                                     width: view.width - 60,
                                     height: 42)
        lineView2.frame = CGRect(x: 20, y: passwordField.bottom, width: view.width - 40, height: 2)
        forgotPasswordButton.frame = CGRect(x: view.width/2 - 20,
                                            y: passwordField.bottom + 2,
                                            width: view.width/2,
                                            height: 36)
        loginButton.frame = CGRect(x: 20,
                                     y: forgotPasswordButton.bottom + 20,
                                     width: view.width - 40,
                                     height: 42)
        googleLoginButton.frame = CGRect(x: 20,
                                     y: loginButton.bottom + 20,
                                     width: view.width - 40,
                                     height: 42)
        facebookLoginButton.frame = CGRect(x: 20,
                                     y: googleLoginButton.bottom + 20,
                                     width: view.width - 40,
                                     height: 42)
        signupLabel.frame = CGRect(x: 20, y: facebookLoginButton.bottom + 20, width: view.width - 100, height: 28)
        
        signupButton.frame = CGRect(x: signupLabel.right + 1, y: facebookLoginButton.bottom + 20, width: 60, height: 28)
        
        scrollView.contentSize = CGSize(width: view.width, height: signupLabel.bottom + 30)
        
    }
    
    //MARK:-Functions
      @objc private func loginButtonTapped(){
          emailField.resignFirstResponder()
          passwordField.resignFirstResponder()
          guard  let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
              //alert
              alertUserLoginError(with: "Please enter all fields")
              return
          }
 
          //user login
        if emailField.text != "" && passwordField.text != "" {
            ProgressHUD.show()
            Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
                guard self != nil else { return }
                
                ProgressHUD.dismiss()
                if error == nil {
                    let user = authResult!.user
                    if user.isEmailVerified{
                        ProgressHUD.showSuccess("login")
                        //update verification status
                        FirestoreClass().downloadCurrentUserFromFirebase(userId: user.uid, email: user.email ?? "", name: user.displayName ?? "")
                        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "mainView") as! UITabBarController
                        mainView.modalPresentationStyle = .fullScreen
                        self?.present(mainView, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Email Verification", message:"You did not verify your email yet,we\'ll send you Authentication email" , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                            user.sendEmailVerification { (error) in
                                if error == nil{
                                    ProgressHUD.showSuccess("send email to you")
                                }
                            }
                        }))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }else{
                    self?.alertUserLoginError(with: error?.localizedDescription ?? "Error")
                }
            }
            
        }else{
            ProgressHUD.showError("All fielfs are required")
        }
      }
    @objc func googleLogin(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
        
    }

    @objc func forgotPasswordButtonPressed(_ sender: Any) {
        let vc = ForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
      private func alertUserLoginError(with message:String){
          let alert = UIAlertController(title: "Error", message:message , preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
          present(alert, animated: true, completion: nil)
      }
      
      @objc func didTapRegister(){
          let vc = RegisterViewController()
          vc.title = "Register"
          navigationController?.pushViewController(vc, animated: true)
      }
      
      private func setupBackgroundTouch(){
          scrollView.isUserInteractionEnabled = true
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
          scrollView.addGestureRecognizer(tapGesture)
      }
      
      @objc func backgroundTap(){
          self.view.endEditing(false)
      }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if error != nil {
        return
      }
        
      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
      //
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                return
                
            }else{
                if authResult?.user != nil{
                    FirestoreClass().downloadCurrentUserFromFirebase(userId: authResult!.user.uid, email: authResult!.user.email ?? "", name: authResult!.user.displayName ?? "")
                    let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "mainView") as! UITabBarController
                    mainView.modalPresentationStyle = .fullScreen
                    self.present(mainView, animated: true, completion: nil)
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
          print(error.localizedDescription)
          return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                return
                
            }else{
                if authResult?.user != nil{
                    FirestoreClass().downloadCurrentUserFromFirebase(userId: authResult!.user.uid, email: authResult!.user.email ?? "", name: authResult!.user.displayName ?? "")
                    let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "mainView") as! UITabBarController
                    mainView.modalPresentationStyle = .fullScreen
                    self.present(mainView, animated: true, completion: nil)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
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
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
