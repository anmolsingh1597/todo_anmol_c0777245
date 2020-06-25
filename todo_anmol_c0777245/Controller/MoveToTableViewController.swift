//
//  MoveToTableViewController.swift
//  todo_anmol_c0777245
//
//  Created by Anmol singh on 2020-06-23.
//  Copyright © 2020 Swift Project. All rights reserved.
//

import UIKit
import CoreData

class MoveToTableViewController: UITableViewController {

    var categories = [Category]()
    /// computed property
    var selectedTasks: [Tasks]? {
        didSet {
            loadCategories()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
       
    }
    
      func loadCategories() {
            
        let request: NSFetchRequest<Category> = Category.fetchRequest()
              
    // predicate if you want
           let categoryPredicate = NSPredicate(format: "NOT categoryName MATCHES %@", selectedTasks?[0].parentCategory?.categoryName ?? "")
              request.predicate = categoryPredicate
              
            do {
                categories = try context.fetch(request)
    //            print(folders.count)
            } catch  {
                print("Error fetching data of categories: \(error.localizedDescription)")
            }
        }

    @objc func cancelButton(){
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissViewController(_ sender: UIBarButtonItem) {
       
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moveToCategoriesCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].categoryName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Move to \(categories[indexPath.row].categoryName!)", message: "Are you sure", preferredStyle: .alert)
               let yesAction = UIAlertAction(title: "Move", style: .default) { (action) in
                   for task in self.selectedTasks! {
                    task.parentCategory = self.categories[indexPath.row]
                   }
                   self.performSegue(withIdentifier: "dismissMoveView", sender: self)
                   self.dismiss(animated: true, completion: nil)
               }
               
               let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
               noAction.setValue(UIColor.orange, forKey: "titleTextColor")
               alert.addAction(yesAction)
               alert.addAction(noAction)
               present(alert, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
