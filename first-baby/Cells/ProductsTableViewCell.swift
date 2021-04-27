//
//  ProductsTableViewCell.swift
//  first-baby
//
//  Created by Max Wen on 4/3/21.
//

import UIKit

class ProductsTableViewCell : UITableViewCell {
    static let identifier = "productsTableViewCell"
    private let producImageView:UIImageView = {
        let view = UIImageView()
        return view
    }()

    private let nameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
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
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth=true
        return label
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(producImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        producImageView.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        nameLabel.frame = CGRect(x: producImageView.right + 10,
                                     y: 2,
                                     width: contentView.width - producImageView.width - 65,
                                     height: 36)
        descriptionLabel.frame = CGRect(x: producImageView.right + 10,
                                    y: nameLabel.bottom + 2,
                                     width: contentView.width - producImageView.width - 65,
                                     height: 40)
        priceLabel.frame = CGRect(x: nameLabel.right + 2, y: 20, width: 40, height: 30)
        
    }
    public func configure(with model:Product){
        self.nameLabel.text = model.productName
        self.descriptionLabel.text = model.description
        self.priceLabel.text = "\(model.productPrice)"
        if model.productImg != ""{
            StorageManager.shared.downloadImage(imageUrl: model.productImg) { (image) in
                DispatchQueue.main.async {
                    self.producImageView.image = image
                }
                
            }
        }
    }
    
}
