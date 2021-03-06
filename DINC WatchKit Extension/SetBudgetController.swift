//
//  SetBudgetController.swift
//  DINC
//
//  Created by dhour on 4/15/16.
//  Copyright © 2016 DHour. All rights reserved.
//


import WatchKit
import Foundation


/**
 * Controller that allows a user to update their daily budget amount
 */
class SetBudgetController: WKInterfaceController {
    
    //---------------------------------------------------------------------------------------------------------
    //MARK: - Properties
    
    ///the current device's screen height
    let screenHeight = WKInterfaceDevice.current().screenBounds.height
    
    var items = [WKPickerItem]()
    
    var dailyBudget: Int!
    var displayedCategories = [String]()
    
    @IBOutlet var editBudgetGroup: WKInterfaceGroup!
    @IBOutlet var dailyBudgetPicker: WKInterfacePicker!
    @IBOutlet var saveButton: WKInterfaceButton!
    
    @IBOutlet var confirmationGroup: WKInterfaceGroup!
    @IBOutlet var confirmationImage: WKInterfaceImage!
    @IBOutlet var confirmationLabel: WKInterfaceLabel!
    
    
    //---------------------------------------------------------------------------------------------------------
    //MARK: - View Life Cycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.configureUI()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
    //---------------------------------------------------------------------------------------------------------
    //MARK: - IBActions
    
    @IBAction func selectPickerItem(_ value: Int) {
        var dailyBudgetString = items[value].title!
        dailyBudgetString.remove(at: dailyBudgetString.startIndex)
        dailyBudget = Int(dailyBudgetString)
    }
    
    @IBAction func saveButtonAction() {
        self.saveToUserDefaultsAndPresentCategoryTable()
    }
    
    
    //---------------------------------------------------------------------------------------------------------
    //MARK: - Helper Methods
    
    
    /**
     Configures and shows the PickerView UI & hides the confirmation table
     
     - returns: Void
     */
    func configureUI() {
        let db = UserDefaults.standard.integer(forKey: userDefaults.dailyBudget)
        if db > 0 {
            self.setTitle("Cancel")
        } else {
            self.setTitle("")
        }

        self.setGroupHeight(screenHeight, confirmation: 0)
        self.dailyBudgetPicker.focus()
        
        for index in 0...200 {
            let item = WKPickerItem()
            item.title = "\(index)".currencyNoDecimals
            items.append(item)
        }
        
        dailyBudgetPicker.setItems(items)
        dailyBudgetPicker.setSelectedItemIndex(1)
    }
    
    
    /**
     Helper method to set group heights
     
     - parameter editBudget: a `CGFloat` height of the edit budget group
     - parameter confirmation: a `CGFloat` height of the confirmation group
     - parameter table: a `CGFloat` height of the category table
     
     - returns: Void
     */
    func setGroupHeight(_ editBudget: CGFloat, confirmation: CGFloat) {
        editBudgetGroup.setHeight(editBudget)
        confirmationGroup.setHeight(confirmation)
    }
    
    
    /**
     Saves dailyBudget as `Int` in watch's nsuserdefault, shows confirmation screen, and then dismisses controller
     */
    func saveToUserDefaultsAndPresentCategoryTable() {
        UserDefaults.standard.set(dailyBudget, forKey: Constants.UserDefaults.dailyBudget)
        UserDefaults.standard.synchronize()
        
        self.animate(withDuration: 0.4) { () -> Void in
            self.setGroupHeight(0, confirmation: self.screenHeight)
        }
        
        Utilities.delay(1) { () in
            self.dismiss()
        }
    }

    

}
