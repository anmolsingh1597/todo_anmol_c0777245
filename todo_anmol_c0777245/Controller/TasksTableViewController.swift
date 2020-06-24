//
//  TasksTableViewController.swift
//  todo_anmol_c0777245
//
//  Created by Anmol singh on 2020-06-23.
//  Copyright © 2020 Swift Project. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TasksTableViewController: UITableViewController {

    @IBOutlet weak var trashSelectedTasks: UIBarButtonItem!
    @IBOutlet weak var moveToCategory: UIBarButtonItem!
    
    var taskTitle: String?
    var taskDescription: String?
    var dueDate: Date?
    
    var tasks = [Tasks]()
    
    var selectedCategory: Category? {
        didSet{
            loadTasks()
        }
    }
    
    var editMode: Bool = false
    
    // create context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
     let datePicker = UIDatePicker()
    var dueDateTextFiled = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell", for: indexPath)
        
        let formatter = DateFormatter()
               formatter.dateStyle = .medium
               formatter.timeStyle = .short
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = formatter.string(from: task.dueDate ?? Date())
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        if task.dueDate! >= Date(){
            cell.backgroundColor = .green
        }else{
            cell.backgroundColor = .red
        }
       
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightGray
        cell.selectedBackgroundView = backgroundView

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
            
            deleteTask(task: tasks[indexPath.row])
            saveTask()
            tasks.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
   
    @IBAction func deleteTasks(_ sender: UIBarButtonItem) {
        if let indexPaths = tableView.indexPathsForSelectedRows{
            let rows = (indexPaths.map {$0.row}).sorted(by: >)
            let _ = rows.map{deleteTask(task: tasks[$0])}
            let _ = rows.map {tasks.remove(at: $0)}
            
            tableView.reloadData()
            
            saveTask()
        }
    }
    
    
    @IBAction func editTasks(_ sender: UIBarButtonItem) {
        editMode = !editMode
        tableView.setEditing(editMode ? true: false, animated: true)
        trashSelectedTasks.isEnabled = !trashSelectedTasks.isEnabled
        moveToCategory.isEnabled = !moveToCategory.isEnabled
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

    
    
    //MARK: data manipulation core data
    
    //MARK: load tasks
    
    func loadTasks(){
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName=%@", selectedCategory!.categoryName!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.predicate = categoryPredicate
        
        do {
            tasks = try context.fetch(request)
        } catch  {
            print("Error loading tasks: \(error.localizedDescription)")
        }
    
        tableView.reloadData()
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
    
    func updateTask(with title: String, description: String, date: Date)  {
        tasks = []
        let newTask = Tasks(context: context)
        newTask.title = title
        newTask.taskDescription = description
        newTask.dueDate = date
        newTask.parentCategory = selectedCategory
        
        saveTask()
        loadTasks()
    }

    func createDatePicker(){
        
      datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        dueDateTextFiled.inputAccessoryView = toolbar
        dueDateTextFiled.inputView = datePicker
    }
    
    @objc func donePressed() {
       
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        dueDateTextFiled.text = formatter.string(from: datePicker.date)
//        self.datePicker.endEditing(true)

        self.dueDateTextFiled.endEditing(true)
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        var titleTextFiled = UITextField()
        var taskDescriptionTextFiled = UITextField()
        
    
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: UIAlertController.Style.alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let taskName = self.tasks.map {$0.title}

            guard !taskName.contains(titleTextFiled.text) else {
                return self.showAlert()
            }

            self.updateTask(with: titleTextFiled.text!, description: taskDescriptionTextFiled.text!, date: self.datePicker.date)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
              // change the font color of cancel
              cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
              
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            titleTextFiled = field
            titleTextFiled.placeholder = "Task Name"
        }
        alert.addTextField { (field) in
                  taskDescriptionTextFiled = field
                  taskDescriptionTextFiled.placeholder = "Task Description"
              }
        alert.addTextField { (field) in
            self.dueDateTextFiled = field
            self.dueDateTextFiled.placeholder = "Due Date"
            self.createDatePicker()
              }
       
              present(alert, animated: true, completion: nil)
    }
    
    func showAlert() {
         let alert = UIAlertController(title: "Alert", message: "Task Name already Exist", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         okAction.setValue(UIColor.orange, forKey: "titleTextColor")
         alert.addAction(okAction)
         present(alert, animated: true, completion: nil)
     }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? MoveToTableViewController{
                   if let indexPaths = tableView.indexPathsForSelectedRows{
                       let rows = indexPaths.map {$0.row}
                       destination.selectedTasks = rows.map {tasks[$0]}
                                }
               }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
          // if editemode is true should make it true
          
          guard identifier != "movePerformSegue" else {
              return true
          }
          
          return editMode ? false : true
      }
   
    
    @IBAction func unwindToTasksTableVC(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        saveTask()
        loadTasks()
        self.tableView.reloadData()
        tableView.setEditing(false, animated: false)
    }

}
