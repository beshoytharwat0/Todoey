//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Mac on 8/31/19.
//  Copyright © 2019 beshoy tharwat. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

// 3mlt inherit from sup class swipetableVC
class CategoryTableViewController: SwipeTableViewController  {
    
    // we call (try!) code smell or bad smell
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCat()
        // to fixed the hight for the cell
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
   
    
    
    // MARK: - Table view data source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added Yet"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "3B1E41")
        
        return cell
    }

    
    
    // MARk: - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return categories?.count ?? 1
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
            
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
    
    
    
    // MARk: - Data mainpulation  Methods
    
    func saveCat(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            
            print("Error saving Context\(error)")
        }
        
        tableView.reloadData()
    }
    
    
    // loed data funcation
    
    func loadCat(){
        
      categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    // MARK : - Delete date from swip
    
    override func updateModel(at indexPath: IndexPath) {
        // handle action by updating model with deletion
            if let deleteCat = self.categories?[indexPath.row]{

            do{
                try self.realm.write {
                     self.realm.delete(deleteCat)
             }
             }catch{
        
            print("Error deleting category,\(error)")
                
            }
        
        
        
        }
        
    }
    

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCat = Category()
            newCat.name = textField.text!
            newCat.color = UIColor.randomFlat.hexValue()
            self.saveCat(category: newCat)
            
            
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


