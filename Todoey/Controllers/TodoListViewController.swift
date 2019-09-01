//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 8/25/19.
//  Copyright © 2019 beshoy tharwat. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category?{
        didSet{
            
            loadItems()
        }
        
    }
    
  
     // how to creat context from AppDelegate class and make appdelegate to object to use in todoVC
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
      // creat file path
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      
// how to load items from plist to upadte the tableview on screen
        
               
        
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
        
        
    
        // 3shan delete row from table view i hv to delete first from context then remove it from itemarray el bt3t3'l 3la el table view
//        context.delete(itemArray[indexPath.row]) // delete from context mn data model el esmo Item
//        itemArray.remove(at: indexPath.row) // remove it from itemarray elli b3mlha dispalytableview
        
        
        // el coda da how nfas el code bt3 if done == false el done = true el f commit t7t
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
     
        
        tableView.reloadData()
        

        
        // lma b3ml select ll row byfd m3lm 3lih blon el rmady ana 3awz y3ml select lon rmady w y5tfi 3latol
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK : add button items :-
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            //-- what will happen once the usre click add item button on our Alert
           
            
           
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        
       
        
        do{
             try context.save()
            
        }catch{
            
          print("Error Saving context , \(error)")
        }
            self.tableView.reloadData()
    }
    
    
    // for read data from datamodel (Item) to table view
    // 3mlt func loaditms edtha 1 parameter wa7d lih esmin wa7d internal el hwa request w el tanty 5argi lma a3ml call ll func f ay mkan tany zay el call eli f func el searchbar
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
       let catPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate  = predicate{
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate, addtionalPredicate])
        }else{
            
            request.predicate = catPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate, predicate])
//        request.predicate = compoundPredicate
        
        do{
        itemArray = try context.fetch(request)
            
        }catch{
            
            print("Error fetchData \(error)")

        }
        tableView.reloadData()
    }
    
}

// MARK: Search bar methods

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // query the database//
        // 1 2olth creat el request gbli el database mn intaty (Item)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // 2 3mlt el query f3alt el query w creat el query w add el searchbar
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // 3 farz el data el htgbha el query mn el searchbar
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        // nw w hv to fetch the data
        
        loadItems(with: request, predicate: predicate)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
