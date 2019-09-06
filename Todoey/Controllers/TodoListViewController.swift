//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 8/25/19.
//  Copyright © 2019 beshoy tharwat. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    // creat new constant for realm
    let realm = try! Realm()
    
    
    var selectedCategory : Category?{
        didSet{
            
          loadItems()
            
        }
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
       
        
    }
    // this view display before view didlodad before the user see anything on the screen
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let colourHex = selectedCategory?.color{
            
            title = selectedCategory!.name
            
            guard let navigBar = navigationController?.navigationBar else{fatalError("Navigation controller does not exist")}
            
            if let NavigBarColour = UIColor(hexString: colourHex){
                
                navigBar.barTintColor = NavigBarColour
//                navigBar.tintColor = ContrastColorOf(NavigBarColour, returnFlat: true)
                
                searchBar.barTintColor = NavigBarColour
            }
            
        }
        

    }
    
      //MARK - tableview DataSourse Methods
    
 override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
   
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title

   if let colour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
            
            cell.backgroundColor = colour
            
            cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
        }
        
        
      
        
        // how to opertor this code to make it short this if item.done
        cell.accessoryType = item.done ? .checkmark : .none
        
    }else{
        
        cell.textLabel?.text = "No Items Added"
    }
    
    
        return cell
    }
   
    
    
 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return todoItems?.count ?? 1
    }
    
    
    //MARK - tableView Delegate Methods func didselectrow with index
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // update thr realm and order to chekc and uncheck items
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
            
            }
            }catch{
                
                print("Errer Saving Done Status,\(error)")
            }
        }
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
           
            if let currentCategory = self.selectedCategory{
                do {
               
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreat = Date()
                    currentCategory.items.append(newItem)
                    
            }
                }catch{
                    
                    print("Error saving new items,\(error)")
                }
            }
            
            self.tableView.reloadData()
            
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
    
    func saveItems(item : Item){
        
        do{
            
            try realm.write {
                realm.add(item)
            }
        }catch{
            
            print("Error Saving data\(error)")
        }
        
  
            self.tableView.reloadData()
    }
    
    
    // for read data from datamodel (Item) to table view
    // 3mlt func loaditms edtha 1 parameter wa7d lih esmin wa7d internal el hwa request w el tanty 5argi lma a3ml call ll func f ay mkan tany zay el call eli f func el searchbar
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreat", ascending: true)


        tableView.reloadData()
    }
    
    // MARK : - Update Model
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let deleteCat = todoItems?[indexPath.row]{
            do{
             try realm.write {
                realm.delete(deleteCat)
            }
            }catch{
                
                print("Error item Not deleted it\(error)")
            }
        }
        
    }
    
}

// MARK: Search bar methods

extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreat", ascending: true)
        
        tableView.reloadData()
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
