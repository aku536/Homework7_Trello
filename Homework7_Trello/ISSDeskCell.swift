//
//  ISSDeskCell.swift
//  Homework7_Trello
//
//  Created by Кирилл Афонин on 30/10/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

// ячейка задачи
class ISSDeskCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    let cellOffset: CGFloat = 10
    
    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = CGRect(x: cellOffset, y: 0, width: frame.width-cellOffset, height: 30)
        titleLabel.textAlignment = .left
        titleLabel.backgroundColor = .white
        self.backgroundColor = .white
        contentView.addSubview(titleLabel)
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
    }
    
}
