//
//  ArchiveTableViewController.swift
//  todo_anmol_c0777245
//
//  Created by Anmol singh on 2020-06-24.
//  Copyright © 2020 Swift Project. All rights reserved.
//

import UIKit
import CoreData

class ArchiveTableViewController: UITableViewController {
    
    var archivedTasks = [Tasks]()

     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadArchivedTasks()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return archivedTasks.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveCell", for: indexPath)
        let archiveTask = archivedTasks[indexPath.row]
        cell.textLabel?.text = archiveTask.title
        cell.detailTextLabel?.text = "Archived"

        return cell
    }
   

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
   

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
                       deleteTask(task: archivedTasks[indexPath.row])
                       saveTask()
                       archivedTasks.remove(at: indexPath.row)
                       // Delete the row from the data source
                       tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Core data manipulation
    
    func loadArchivedTasks()  {
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName=%@",  "Archive")
             request.predicate = categoryPredicate
               do {
                  archivedTasks = try context.fetch(request)
               } catch  {
                   print("Error Loading Folders: \(error.localizedDescription)")
               }
    }
    
    
    //MARK: delete task
       func deleteTask(task: Tasks){
           context.delete(task)
       }
       
       //MARK: save task
       func saveTask(){
           do {
               try context.save()
           } catch  {
               print("Error saving the context: \(error.localizedDescription)")
               }
       }
    
}
