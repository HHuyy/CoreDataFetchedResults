//
//  MasterTableViewController.swift
//  CoreDataFetchedResults
//
//  Created by thamgiahuy on 7/9/18.
//  Copyright © 2018 thamgiahuy. All rights reserved.
//

import UIKit
import  CoreData

class MasterTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController = DataService.shared.fetchedResultsController
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        // Configure the cell...
        let entity = fetchedResultsController.object(at: indexPath)
        configureCell(cell, with: entity)
        return cell
    }
    func configureCell(_ cell: UITableViewCell, with entity: Entity) {
        cell.textLabel?.text = entity.name
        cell.detailTextLabel?.text = "Age: \(entity.age)"
        cell.imageView?.image = entity.photo as? UIImage
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController {
            if let index = tableView.indexPathForSelectedRow {
                detailViewController.object = fetchedResultsController.object(at: index)
            }
        }
    }
    @IBAction func unwind(_ sender: UIStoryboardSegue) {}
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, with: anObject as! Entity)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, with: anObject as! Entity)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
