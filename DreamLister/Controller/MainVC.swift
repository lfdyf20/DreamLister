//
//  MainVC.swift
//  DreamLister
//
//  Created by Fei Liang on 9/23/17.
//  Copyright © 2017 Fei Liang. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segment: UISegmentedControl!

    var controller: NSFetchedResultsController<Item>!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self

//        generateTestData()
        attemptFetch()
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func configureCell(cell: ItemCell, indexPath: IndexPath) {

        //update the cell

        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {

            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }

        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func attemptFetch(){

        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dataSort = NSSortDescriptor(key: "created_date", ascending: false)
        fetchRequest.sortDescriptors = [ dataSort ]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller

        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                // update the cell data
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }

    func generateTestData(){

        let item = Item(context: context)
        item.title = "iPhone X"
        item.price = 999
        item.details = "newest iphone that everyone want"

        let item2 = Item(context: context)
        item2.title = "MacBook Pro"
        item2.price = 1800
        item2.details = "want another macbook"

        let item3 = Item(context: context)
        item3.title = "Surface"
        item3.price = 1800
        item3.details = "never used it before, just wanna a try"

        ad.saveContext()
    }

}

