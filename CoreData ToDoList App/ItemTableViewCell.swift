//
//  ItemTableViewCell.swift
//  CoreData ToDoList App
//
//  Created by Macbook Air 2017 on 12. 3. 2024..
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    static let identifier = "ItemTableViewCell"

    private let itemLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let checkButton: UIButton = {
        let bttn = UIButton()
        bttn.layer.borderWidth = 1
        bttn.layer.borderColor = UIColor.lightGray.cgColor
        return bttn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(checkButton)
        addSubview(itemLabel)
        
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        checkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        checkButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 20).isActive = true
        itemLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        itemLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        itemLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(text: String) {
        itemLabel.text = text
    }
    
    override func prepareForReuse() {
        itemLabel.text = nil
    }
}
