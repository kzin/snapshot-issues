//
//  UserCell.swift
//  swift-testing
//
//  Created by Rodrigo Cavalcante on 15/03/17.
//  Copyright © 2017 Rodrigo Cavalcante. All rights reserved.
//

import UIKit
import Cartography

class UserCell: UITableViewCell {
    
    let usernameLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .blue
        label.font = UIFont.init(name: "SF UI Display", size: 16.0)
        return label
    }()
    
    let emailLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.init(name: "SF UI Display", size: 16.0)
        return label
    }()
    
    let ageLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .blue
        label.font = UIFont.init(name: "SF UI Display", size: 16.0)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.build()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(user: User) {
        self.emailLabel.text = user.email
        self.usernameLabel.text = user.username
        self.ageLabel.text = "\(user.age) yo"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
    }
    
    func build() {
        buildViewHierarchy()
        buildConstrains()
        setup()
    }
    
    func buildConstrains() {
        
        let margin: CGFloat = 16.0
        
        constrain(self.contentView, ageLabel, emailLabel, usernameLabel) { view, age, email, name in
            age.bottom == view.bottom - margin
            age.left == view.left + (margin)
            age.right == view.right - (margin/2)
            
            email.bottom == age.top - (margin/2)
            email.left == view.left + (margin)
            email.right == view.right - (margin/2)
            
            name.bottom == email.top - (margin/2)
            name.left == view.left + (margin)
            name.right == view.right - (margin/2)
            name.top == view.top + (margin*2)
        }
    }
    
    func buildViewHierarchy() {
        self.contentView.addSubview(usernameLabel)
        self.contentView.addSubview(emailLabel)
        self.contentView.addSubview(ageLabel)
    }
    
    func setup() {
        self.backgroundColor = .lightGray
        self.selectionStyle = .none
    }
}

typealias JsonObject = [String: Any]

struct JSON {
    
    static func user() -> JsonObject {
        return [
            "username": "username",
            "email": "user@mail.com",
            "age": 26
        ]
    }
}
