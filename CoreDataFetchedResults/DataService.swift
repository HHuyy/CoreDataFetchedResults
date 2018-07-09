//
//  DataService.swift
//  CoreDataFetchedResults
//
//  Created by thamgiahuy on 7/9/18.
//  Copyright © 2018 thamgiahuy. All rights reserved.
//

import Foundation
import CoreData

class DataService {
    
    static let shared: DataService = DataService()
    private var _fetchedResultsController: NSFetchedResultsController<Entity>?
    var fetchedResultsController: NSFetchedResultsController<Entity> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        // Edit the sort key as appropriate.
        let sortDescriptor =  NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: "Master")
        do {
            try _fetchedResultsController?.performFetch()
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return _fetchedResultsController!
    }
    func saveData() {
        guard let context = _fetchedResultsController?.managedObjectContext else { return  }
        do {
            try context.save()
            print("CoreData Saved")
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
