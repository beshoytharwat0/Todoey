//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 8/25/19.
//  Copyright © 2019 beshoy tharwat. All rights reserved.
//

import UIKit
class TodoListViewController: UITableViewController  {
    
    var itemArray = [Item]()
    
    // creat file path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        print(dataFilePath)
        
       
// how to load items from plist to upadte the tableview on screen
        
        loadItems()
    }
    
      //MARK - tableview DataSourse Methods
    
 override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let item = itemArray[indexPath.row]
    
    
       // let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
        cell.textLabel?.text = item.title
    
    // how to opertor this code to make it short this if item.done
     cell.accessoryType = item.done ? .checkmark : .none
    
//    if item.done == true {
//        cell.accessoryType = .checkmark
//
//    }else{
//
//        cell.accessoryType = .none
//    }
    
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
        
        // el coda da how nfas el code bt3 if done == false el done = true el f commit t7t
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        // how to remove check mark ✓ if i tap again
//
//        if itemArray[indexPath.row].done == false{
//
//            itemArray[indexPath.row].done = true
//        }else{
//
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.reloadData()
        
//        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
//
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
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
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
           
            
          self.saveItems()
            
            
        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(dismissAction)
        // how to add textField at alter
        alert.addTextField { (alertTextFiled) in
            
            alertTextFiled.placeholder = "Creat New Item"
            textField = alertTextFiled
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model  save items methods
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try  data.write(to: dataFilePath!)
        }catch{
            
            print("Error encoding items array,\(error)")
        }
            self.tableView.reloadData()
    }
    
    func loadItems(){
        
        if  let data = try? Data(contentsOf: dataFilePath!){
        
      let decoder = PropertyListDecoder()
        do{
        itemArray = try decoder.decode([Item].self, from: data   )
            
        }catch{
            
            print("Error decoding item array ,\(error)")
            }
    
        }
    
    }
    
    
}
