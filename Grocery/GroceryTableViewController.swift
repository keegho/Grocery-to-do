//
//  GroceryTableViewController.swift
//  Grocery
//
//  Created by Kegham Karsian on 10/18/16.
//  Copyright © 2016 appologi. All rights reserved.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {
    
    var groceries = [Grocery]()
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if #available(iOS 10.0, *) {
            
            context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
        } /*else {
            // iOS 9.0 and below - however you were previously handling it
            guard let modelURL = Bundle.main.url(forResource: "Model", withExtension:"momd") else {
                fatalError("Error loading model from bundle")
            }
            guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Error initializing mom from: \(modelURL)")
            }
            let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
            context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            let storeURL = docURL.appendingPathComponent("Model.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
            
        } */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        
        groceries.removeAll(keepingCapacity: true)
        
        let request: NSFetchRequest<Grocery>
        
        if #available(iOS 10.0, OSX 10.12, *) {
            request = Grocery.fetchRequest()
        } else {
            request = NSFetchRequest(entityName: "Grocery")
        }
        
        do {
            let results = try context.fetch(request)
            for result in results {
                groceries.append(result)
                
                }
            tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addGrocery(_ sender: UIBarButtonItem) {
        
        
        let alertController = UIAlertController(title: "Add", message: "Add todays grocery", preferredStyle: .alert)
        alertController.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Milk..."
        }
        
        let okAction = UIAlertAction(title: "Add", style: .default) { (action:UIAlertAction) in
            
            let textField = alertController.textFields?.first
            let grocery = NSEntityDescription.insertNewObject(forEntityName: "Grocery", into: self.context) as! Grocery
            grocery.item = textField?.text!
            grocery.isPurchased = false
            grocery.timeStamp = Date().timeIntervalSince1970
         
            do {
                try self.context.save()
            } catch {
                fatalError("Cannot save grocery")
            }
            
            self.loadData()
            
        }
        let canelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(canelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groceries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let grocery = groceries[indexPath.row]
        
        //UnixTime is a typeAlias i created
        let time: UnixTime = grocery.timeStamp

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroceryCellTableViewController
        
        cell.groceryTitle.text = grocery.item
        
        cell.timeAdded.text = time.toDayAndHour //Using UnixTime type extension
        if grocery.isPurchased {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // When the cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let grocery = groceries[indexPath.row]
            if grocery.isPurchased {
                grocery.isPurchased = false
                cell.accessoryType = .none
            } else {
                grocery.isPurchased = true
                cell.accessoryType = .checkmark
            }
        }
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source & coredata
            
            let objectToDelete = groceries[indexPath.row]
            groceries.remove(at: indexPath.row)
            context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(objectToDelete as NSManagedObject)
            
            do {
                try context.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                fatalError("Cannot delete item")
            }
            
            
            
        } /*else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    */
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



typealias UnixTime = Double

extension UnixTime {
    
    private func formatType(from: String) -> DateFormatter {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = from
        return dateFormater
    }
    
    var fullDate:Date {
        return Date(timeIntervalSince1970: Double(self))
    }
    var toHour:String {
        return formatType(from: "HH:mm a").string(from: fullDate)
    }
    var toDay:String {
        return formatType(from: "dd/MM/yyyy").string(from: fullDate)
    }
    var toDayAndHour:String {
        return formatType(from: "dd/MM/yyyy  hh:mm:ss a").string(from: fullDate)
    }

}
