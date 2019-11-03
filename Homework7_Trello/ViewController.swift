//
//  ViewController.swift
//  Homework7_Trello
//
//  Created by Кирилл Афонин on 30/10/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let data = Data()
    var addTaskView = AddTaskView()
    let addButton = UIButton.init(type: .custom)
    let bottomInset: CGFloat = 150
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCollectionView()
        setupAddButton()
    }
    
    // MARK: - Настройка элементов view
    
    // горизонатальная collectionView
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ISSAnotherCollectionViewCell.self, forCellWithReuseIdentifier: "AnotherCVCell")
        collectionView.backgroundColor = .purple
        collectionView.contentInset.bottom = bottomInset
        collectionView.contentInset.top = 25
        view.addSubview(collectionView)
    }
    
    // кнопка добавления новой задачи
    private func setupAddButton() {
        addButton.backgroundColor = .white
        addButton.frame = CGRect(x: view.frame.width/2-50,
                              y: view.frame.height - bottomInset/2,
                              width: 150,
                              height: 25)
        addButton.setTitle("Добавить задачу", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    // добавляем view новой задачи на экран
    @objc private func addNewTask() {
        addButton.isEnabled = false
        addTaskView.center = view.center
        addTaskView.titleLabel.frame = CGRect(x: 10,
                                              y: 0,
                                              width: addTaskView.frame.width-10,
                                              height: addTaskView.frame.height)
        let dragInteraction = UIDragInteraction(delegate: self)
        dragInteraction.isEnabled = true
        addTaskView.addInteraction(dragInteraction)
        view.addSubview(addTaskView)
        
    }
    
    // MARK: Настройка collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnotherCVCell", for: indexPath) as! ISSAnotherCollectionViewCell
        cell.backgroundColor = .lightGray
        cell.titleLabel.text = data.titles[indexPath.row]
        cell.tasksArray = data.tasksArray[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
        return CGSize(width: collectionView.frame.width/2.5, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
}

extension ViewController: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let string = addTaskView.titleLabel.text else {
            return []
        }
        let provider = NSItemProvider(object: string as NSString)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = string
        
        return [item]
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
        addTaskView.removeFromSuperview()
        addButton.isEnabled = true
    }
}


