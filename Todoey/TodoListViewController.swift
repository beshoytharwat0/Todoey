//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 8/25/19.
//  Copyright © 2019 beshoy tharwat. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController  {
    
    var itemArray = ["Beshyo", "Joesph", "yousef",]
    // 3rft user default
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            
            itemArray = items
        }
    }
    
      //MARK - tableview DataSourse Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
   
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return itemArray.count
    }
    
    
    //MARK - tableView Delegate Methods func didselectrow with index
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(itemArray[indexPath.row])
        
        // 3shan a3ml 3lamt el check mark ✓
       // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        // how to remove check mark ✓ if i tap again
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        // lma b3ml select ll row byfd m3lm 3lih blon el rmady ana 3awz y3ml select lon rmady w y5tfi 3latol
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK : add button items :-
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //-- what will happen once the usre click add item button on our Alert
            // ana 3mlt add item mn alertTextField to arrayitem bs mn htzhr 7aga lazm a3ml reload table view
            self.itemArray.append(textField.text!)
            
            self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            
            
        }
        // how to add textField at alter
        alert.addTextField { (alertTextFiled) in
            
            alertTextFiled.placeholder = "Creat New Item"
            textField = alertTextFiled
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

