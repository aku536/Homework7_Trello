//
//  AddTaskView.swift
//  Homework7_Trello
//
//  Created by Кирилл Афонин on 03/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

// view для добавления новой задачи
class AddTaskView: UIView {
    
    let titleLabel = UITextField()
    
    init() {
        super.init(frame: .zero)
        self.frame = CGRect(x: 0,
                                  y: 0,
                                  width: 400,
                                  height: 30)
        self.backgroundColor = .white
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.green.cgColor
        
        titleLabel.textAlignment = .left
        titleLabel.backgroundColor = .white
        titleLabel.text = "Новая задача"
        titleLabel.becomeFirstResponder()
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
