//
//  BasketTableViewCell.swift
//  first-baby
//
//  Created by Max Wen on 4/10/21.
//

import UIKit

class BasketTableViewCell: UITableViewCell {
    static let identifier = "basketTableViewCell"

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
    private let qtyLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "Qty:"
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
        contentView.addSubview(qtyLabel)
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
        qtyLabel.frame = CGRect(x: producImageView.right + 10,
                                    y: nameLabel.bottom + 2,
                                     width: contentView.width - producImageView.width - 65,
                                     height: 40)
        priceLabel.frame = CGRect(x: nameLabel.right + 2, y: 20, width: 40, height: 30)
        
    }
    public func configure(with model:Product){
        let totalPrice = model.productPrice * Double(model.productQty)
        self.nameLabel.text = model.productName
        self.qtyLabel.text = "Qty: " + "\(model.productQty)"
        self.priceLabel.text = "$\(totalPrice)"
        if model.productImg != ""{
            StorageManager.shared.downloadImage(imageUrl: model.productImg) { (image) in
                DispatchQueue.main.async {
                    self.producImageView.image = image
                }
                
            }
        }
    }

}
