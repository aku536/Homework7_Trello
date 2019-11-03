//
//  DragCoordinator.swift
//  Homework7_Trello
//
//  Created by Кирилл Афонин on 03/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

// для отслеживания drag&drop между 2мя collectionViews
class DragCoordinator {
    let sourceIndexPath: IndexPath // индекс начала drag
    var dragCompleted = false
    var isReordering = false
    
    init(sourceIndexPath: IndexPath) {
        self.sourceIndexPath = sourceIndexPath
    }
}
