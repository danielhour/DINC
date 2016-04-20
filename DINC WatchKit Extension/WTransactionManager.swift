//
//  WTransactionManager.swift
//  DINC
//
//  Created by dhour on 4/16/16.
//  Copyright © 2016 DHour. All rights reserved.
//

import Foundation
import RealmSwift
import Timepiece


/**
 *
 */
class WTransactionManager: NSObject {
    
    
    //---------------------------------------------------------------------------------------------------------
    
    //MARK: - Fetch Methods

    /**
     Fetches ALL `WTransactions` in Realm database
     
     - returns: Results<Purchase>
     */
    static func allTransactions() -> Results<WTransaction> {
        let realm = try! Realm()
        return realm.objects(WTransaction)
    }
    
    
    /**
     Fetches all of today's `WTransaction`s
     
     - returns: `[WTransaction]`
     */
    static func todaysTransactions() -> [WTransaction] {
        let realm = try! Realm()
        let today = NSDate()
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", today.beginningOfDay, today.endOfDay)
        let transactions = realm.objects(WTransaction).filter(predicate).sorted("date", ascending: true)

        return transactions.map{WTransaction(transaction: $0)}
    }
    
    
    /**
     Fetches the most recent transaction
     */
    static func mostRecentTransaction() -> WTransaction? {
        let realm = try! Realm()
        guard let last = realm.objects(WTransaction).last else {
            return nil
        }
        
        return WTransaction(transaction: last)
    }
    
    
    /**
     Fetches all transactions and adds their total amount
     
     - returns: `Double`
     */
    static func moneySpent() -> Double {
        let realm = try! Realm()
        let all = realm.objects(WTransaction)
        
        return all.map{WTransaction(transaction: $0).amount}.reduce(0, combine: +)
    }

    
    //---------------------------------------------------------------------------------------------------------
    
    //MARK: - Add / Delete Methods
    
    /**
     Adds a new `WTransaction` to the Realm database
     
     - parameter date: NSDate
     - parameter amount: Double
     */
    static func addNewPurchase(date: NSDate, amount: Double) {
        let realm = try! Realm()
        
        try! realm.write { () -> Void in
            let transaction = WTransaction()
            transaction.date = date
            transaction.amount = amount
            realm.add(transaction)
        }
    }
    
    
    /**
     Delete the selected purchase
     
     - parameter row: `Int`
     */
    static func deletePurchase(row: Int) {
        let realm = try! Realm()
        let today = NSDate()
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", today.beginningOfDay, today.endOfDay)
        let todaysTransactions = realm.objects(WTransaction).filter(predicate).sorted("date", ascending: true)

        
        try! realm.write {
            realm.delete(todaysTransactions[row])
        }
    }
    
    
    /**
     Deletes all `WTransaction` objects from Realm database
     */
    static func resetDataForNewMonth() {
        let realm = try! Realm()
        let lastMonth = realm.objects(WTransaction)
        
        try! realm.write {
            realm.delete(lastMonth)
        }
    }
    
    
    
}