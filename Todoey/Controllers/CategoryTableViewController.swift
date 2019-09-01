//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Mac on 8/31/19.
//  Copyright © 2019 beshoy tharwat. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadCat()
        
    }
    
    
    // MARK: - Table view data source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        
        
        
        return cell
    }
    
    // MARk: - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return categoryArray.count
    }
    
    
    // MARk:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    // i hv to initialize itme array with all item fe todolist / de ht4t3'l 2bl el perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //1 reference for the destination
        let destinationVC = segue.destination as! TodoListViewController
        //2 drag the items for the selected row hgib el items el t5s el categroy el ana 3mltlh select
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
    
    
    // MARk: - Data mainpulation  Methods
    
    func saveCat(){
        do{
            try context.save()
        }catch{
            
            print("Error saving Context\(error)")
        }
        
        tableView.reloadData()
    }
    
    
    // loed data funcation
    
    func loadCat(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
         categoryArray = try context.fetch(request)
        }catch{
            
            print("Error Fetching Data\(error)")
        }
        self.tableView.reloadData()
    }
    

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCat = Category(context: self.context)
            newCat.name = textField.text!
            self.categoryArray.append(newCat)
            
            self.saveCat()
            
            
        }
        let disMiss = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(disMiss)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New a Category"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
  
}
