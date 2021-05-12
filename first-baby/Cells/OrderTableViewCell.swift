//
//  OrderTableViewCell.swift
//  first-baby
//
//  Created by Max Wen on 5/11/21.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    static let identifier = "orderTableViewCell"
    private let orderIdLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.text = "Order Id"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let dateLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "Date:"
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(orderIdLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(priceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        orderIdLabel.frame = CGRect(x: 20,
                                     y: 5,
                                     width: contentView.width - 108,
                                     height: 30)
        dateLabel.frame = CGRect(x: 20,
                                    y: orderIdLabel.bottom + 2,
                                     width: contentView.width - 108,
                                     height: 26)
        priceLabel.frame = CGRect(x: dateLabel.right + 2, y: 10, width: 65, height: 30)
        
    }
    public func configure(with model:Order){

        self.orderIdLabel.text = "Order: \(model.orderID)"
        self.dateLabel.text = "Date: " + Date.longDate(model.date)()
        self.priceLabel.text = "Price: \(model.totalPrice)"

    }

}
