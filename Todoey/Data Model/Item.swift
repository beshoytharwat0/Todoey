//
//  Item.swift
//  Todoey
//
//  Created by Mac on 9/1/19.
//  Copyright © 2019 beshoy tharwat. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {

    @objc dynamic var title : String  = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreat : Date?
    
    // Category not fromtype but to make type we add classname.self (Category.self) and make realtion between category and item 
    
   var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
