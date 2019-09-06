//
//  Category.swift
//  Todoey
//
//  Created by Mac on 9/1/19.
//  Copyright © 2019 beshoy tharwat. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    // creat constant  itme htshil list of item objects then  initialize it as empaty list 
    let items = List<Item>()
}
