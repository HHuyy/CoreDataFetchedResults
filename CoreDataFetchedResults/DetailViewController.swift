//
//  ViewController.swift
//  CoreDataFetchedResults
//
//  Created by thamgiahuy on 7/9/18.
//  Copyright © 2018 thamgiahuy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var photoImage: UIImageView!
    
    var object: Entity?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configure()
    }
    func configure() {
        if let dataObject = object {
            nameTextField.text = dataObject.name
            ageTextField.text = String(dataObject.age)
            photoImage.image = dataObject.photo as? UIImage
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var ageValue: Int?
        if nameTextField.text != "", ageTextField.text != "" {
            ageValue = Int(ageTextField.text ?? "") ?? 0
        }
        guard let masterTableviewController = segue.destination as? MasterTableViewController else { return  }
        if masterTableviewController.tableView.indexPathForSelectedRow == nil {
            object = Entity(context: masterTableviewController.fetchedResultsController.managedObjectContext)
        }
        object?.age = Int64(ageValue!)
        object?.name = nameTextField.text
        object?.photo = #imageLiteral(resourceName: "photoDefault")
        DataService.shared.saveData()
    }
    

}

