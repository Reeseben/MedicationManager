//
//  MoodSurvey+Convenience.swift
//  MedicationManager
//
//  Created by Ben Erekson on 7/28/21.
//

import CoreData

extension MoodSurvey{
    
    @discardableResult
    convenience init(date: Date = Date(), mentalState: String, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        self.mentalState = mentalState
        self.date = date
    }
    
}
