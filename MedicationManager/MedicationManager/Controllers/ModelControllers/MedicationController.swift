//
//  MedicationController.swift
//  MedicationManager
//
//  Created by Ben Erekson on 7/26/21.
//

import Foundation
import CoreData

class MedicationController{
    
    static let shared = MedicationController()
    
    var medications: [Medication] = []
    
    private lazy var fetchRequest : NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: "Medication")
        
        request.predicate = NSPredicate(value: true)
        
        return request
    }()
    
    private init(){}
    
    //MARK: - CRUD Functions
    func createMedication(name: String, timeOfDay: Date) {
        let medication = Medication(name: name, timeOfDay: timeOfDay)
        medications.append(medication)
        
        CoreDataStack.saveContext()
    }
    
    func fetchMedications() {
        let medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        print(medications.count)
        self.medications = medications
    }
    
    func updateMedication(medication: Medication, name: String, date: Date) {
        medication.name = name
        medication.timeOfDay = date
        
        CoreDataStack.saveContext()
    }
    
    func deleteMediation() {
        //BEREK
    }
    
    
}
