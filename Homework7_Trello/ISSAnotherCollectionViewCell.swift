//
//  ISSAnotherCollectionViewCell.swift
//  Homework7_Trello
//
//  Created by Кирилл Афонин on 01/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

// ячейка состоит из collectionView
class ISSAnotherCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var tasksArray = [String]() // массив задач
    let titleLabel = UILabel() // название задачи
    var collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let titleLabelHeight: CGFloat = 30
    let cellOffset: CGFloat = 20
    
    override func prepareForReuse() {
        titleLabel.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTitleLabel()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: настройка элементов ячейки
    private func setupTitleLabel() {
        titleLabel.frame = CGRect(x: cellOffset, y: 10, width: frame.width-cellOffset, height: titleLabelHeight)
        titleLabel.font = .boldSystemFont(ofSize: 18)
        contentView.addSubview(titleLabel)
    }
    
    private func setupCollectionView() {
        collectionView.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: contentView.frame.width, height: contentView.frame.height)
        collectionView.backgroundColor = .lightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self;
        collectionView.dropDelegate = self;
        collectionView.register(ISSDeskCell.self, forCellWithReuseIdentifier: "TaskCell")
        collectionView.contentInset.bottom = 30
        contentView.addSubview(collectionView)
    }
    
    // MARK: настройка collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as! ISSDeskCell
        cell.titleLabel.text = tasksArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        size.width = collectionView.frame.width - cellOffset
        size.height = 30
        return size
    }

}


// MARK: UICollectionViewDragDelegate
extension ISSAnotherCollectionViewCell: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragCoordinator = DragCoordinator(sourceIndexPath: indexPath)
        session.localContext = dragCoordinator
        let item = self.tasksArray[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        guard
            let dragCoordinator = session.localContext as? DragCoordinator,
            dragCoordinator.dragCompleted == true,
            dragCoordinator.isReordering == false
            else {
                return
        }
        let sourceIndexPath = dragCoordinator.sourceIndexPath
        collectionView.performBatchUpdates({
            self.tasksArray.remove(at: sourceIndexPath.item)
            collectionView.deleteItems(at: [sourceIndexPath])
        })
    }
}

// MARK: UICollectionViewDropDelegate
extension ISSAnotherCollectionViewCell : UICollectionViewDropDelegate
{
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        guard session.localDragSession != nil else {
            return UICollectionViewDropProposal(
                operation: .copy,
                intent: .insertAtDestinationIndexPath)
        }
        
        guard session.items.count == 1 else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    } 
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: collectionView.numberOfItems(inSection: 0), section: 0)
        let item = coordinator.items[0]
        
        switch coordinator.proposal.operation {
            
        case .move:
            guard let dragCoordinator =
                coordinator.session.localDragSession?.localContext as? DragCoordinator
                else { fallthrough  }
            
            if let sourceIndexPath = item.sourceIndexPath {
                dragCoordinator.isReordering = true
                collectionView.performBatchUpdates({
                    if destinationIndexPath != sourceIndexPath {
                        let tmpString = self.tasksArray.remove(at: sourceIndexPath.item)
                        self.tasksArray.insert(tmpString, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    }
                })
            } else {
                dragCoordinator.isReordering = false
                if let string = item.dragItem.localObject as? String {
                    collectionView.performBatchUpdates({
                        self.tasksArray.insert(string, at: destinationIndexPath.item)
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                }
            }
            dragCoordinator.dragCompleted = true
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        case .copy:
            let placeholder = UICollectionViewDropPlaceholder(
                insertionIndexPath: destinationIndexPath, reuseIdentifier: "TaskCell")
            placeholder.cellUpdateHandler = { cell in
                if let cell = cell as? ISSDeskCell {
                    cell.titleLabel.text = "Loading..."
                }
            }
            let context = coordinator.drop(item.dragItem, to: placeholder)
            let itemProvider = item.dragItem.itemProvider
            itemProvider.loadObject(ofClass: NSString.self) { string, error in
                if let string = string as? String {
                    DispatchQueue.main.async {
                        context.commitInsertion(dataSourceUpdates: {_ in
                            self.tasksArray.insert(string, at: destinationIndexPath.item)
                        })
                    }
                }
            }
        
        default:
            return
        }
    }
}
