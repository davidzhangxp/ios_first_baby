//
//  AddProductViewController.swift
//  first-baby
//
//  Created by Max Wen on 3/28/21.
//

import UIKit
import ProgressHUD
import Gallery

class AddProductViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.clipsToBounds = true
        return view
    }()

    private let nameLabel: UILabel={
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Product Name:"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let nameField:UITextField={
        let field = UITextField()
        field.placeholder = "product name"
        field.autocapitalizationType = .none
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.borderWidth  = 1
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return field
    }()
    private let priceLabel: UILabel={
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Product Price:"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let priceField:UITextField={
        let field = UITextField()
        field.placeholder = "product price"
        field.autocapitalizationType = .none
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.borderWidth  = 1
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return field
    }()
    private let categoryLabel: UILabel={
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Category:"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let categoryField:UITextField={
        let field = UITextField()
        field.placeholder = "Category"
        field.autocapitalizationType = .none
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.borderWidth  = 1
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return field
    }()
    private let descriptionLabel: UILabel={
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Product Description:"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let descriptionField:UITextView={
        let field = UITextView()
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.text = "Product information"
        field.backgroundColor = .white
        return field
    }()
    
    private let imageView:UIImageView={
        let view = UIImageView()
        view.image=UIImage(named: "user1")
        return view
    }()
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("submit ", for: .normal)
        button.backgroundColor = .systemRed
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 20
        return button
    }()
    //Vars
    var gallery: GalleryController!
    var itemImages: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title="add Products"
        setupBackgroundTouch()
        setupImageViewTouch()
        submitButton.addTarget(self, action: #selector(saveToFirestore), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(nameField)
        scrollView.addSubview(imageView)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(priceField)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(descriptionField)
        scrollView.addSubview(categoryLabel)
        scrollView.addSubview(categoryField)
        scrollView.addSubview(submitButton)
        
        scrollView.frame = view.bounds
        imageView.frame = CGRect(x: 20, y: 0, width: view.width - 40, height: 200)
        nameLabel.frame = CGRect(x: 20, y: imageView.bottom+10, width:
                                    (view.width-40
                                     )/3, height: 36)
        nameField.frame = CGRect(x: nameLabel.right+5, y: imageView.bottom+10, width: (view.width-45)*2/3, height: 36)
        priceLabel.frame = CGRect(x: 20, y: nameField.bottom+10, width:
                                    (view.width-40
                                     )/3, height: 36)
        priceField.frame = CGRect(x: priceLabel.right+5, y: nameField.bottom+10, width: (view.width-45)*2/3, height: 36)
        categoryLabel.frame = CGRect(x: 20, y: priceLabel.bottom+10, width:
                                    (view.width-40
                                     )/3, height: 36)
        categoryField.frame = CGRect(x: categoryLabel.right+5, y: priceField.bottom+10, width: (view.width-45)*2/3, height: 36)
        descriptionLabel.frame = CGRect(x: 20, y: categoryField.bottom+10, width:
                                    view.width-40, height: 36)
        descriptionField.frame = CGRect(x: 20, y: descriptionLabel.bottom+10, width: view.width-40, height: 90)
        
        submitButton.frame = CGRect(x: 20, y: descriptionField.bottom+30, width: view.width-40, height: 36)
        scrollView.contentSize = CGSize(width: view.width, height: submitButton.bottom+20)
    }
    

    @objc func saveToFirestore(){
        if fieldsAreCompleted(){
            let productId = UUID().uuidString
            let productName = nameField.text!
            let productPrice = Double(priceField.text!) ?? 0.0
            let category = categoryField.text!
            let description = descriptionField.text!
            let product = Product(_productId: productId, _productName: productName, _productPrice: productPrice)
            product.category = category
            product.description = description
            if self.itemImages.count > 0{
                StorageManager.shared.uploadImage(image: self.itemImages.first!!) { (imageLink) in
                    product.productImg = imageLink
                    DispatchQueue.main.async {
                        FirestoreClass().saveProductToFirestore(product: product)
                        self.fieldsClean()
                    }
                }
            }else{
                FirestoreClass().saveProductToFirestore(product: product)
                fieldsClean()
            }
            
        }else{
            ProgressHUD.showError("Please check your form")
        }
    }
    
    //Helpers
    private func fieldsAreCompleted() -> Bool {
        return nameField.text != "" && priceField.text != "" && categoryField.text != "" && descriptionField.text != ""
    }
    private func fieldsClean(){
        nameField.text = ""
        priceField.text = ""
        categoryField.text = ""
        descriptionField.text = ""
    }
    private func setupBackgroundTouch(){
        scrollView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        scrollView.addGestureRecognizer(tapGesture)
    }

    @objc func backgroundTap(){
        self.view.endEditing(false)
    }
    
    private func setupImageViewTouch(){
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCameraGallery))
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc private func showCameraGallery(){
        itemImages = []
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab,.cameraTab]
        Config.Camera.imageLimit = 6
        present(self.gallery, animated: true, completion: nil)
        
    }

}

extension AddProductViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImages) in
                self.itemImages = resolvedImages
                
                self.imageView.image = resolvedImages.first!
                
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
