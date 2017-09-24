//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Fei Liang on 9/23/17.
//  Copyright © 2017 Fei Liang. All rights reserved.
//
//

import Foundation
import CoreData


public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()

        self.created_date = NSDate()
    }

    

}
