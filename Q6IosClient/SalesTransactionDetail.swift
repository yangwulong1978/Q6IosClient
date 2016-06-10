//
//  SalesTransactionDetail.swift
//  Q6IosClient
//
//  Created by yang wulong on 10/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation

public class SalesTransactionsDetail
{
    var AccountID = String?()
    var Amount = Double()
    var Description = String?()
    var Discount = Double?()
    var InventoryID = String?()
    var IsDeleted: Bool = false
    var Quantity = Double()
    
    var SalesTransactionsDetailID = NSUUID().UUIDString
    var SalesTransactionsHeaderID = NSUUID().UUIDString
    
    var SortNo = Int()
    
    var TaxCodeID = String?()
    
    var UnitPrice = Double()
    
    
    
    
    
}
