//
//  TakenDate+Convenience.swift
//  MedicationManager
//
//  Created by Ben Erekson on 7/27/21.
//

import Foundation
import CoreData

extension TakenDate {
    
    @discardableResult
    convenience init(takenDate: Date = Date(), context: NSManagedObjectContext = CoreDataStack.context, medication: Medication){
        self.init(context: context)
        self.date = takenDate
        self.medication = medication
    }
    
}//End of Extension
