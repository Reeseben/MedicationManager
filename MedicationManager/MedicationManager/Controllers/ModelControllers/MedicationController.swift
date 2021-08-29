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
    let notificationScheduler = NotificationScheduler()
    
    ///Index 0 == notTaken, Index 1 == Taken
    var sections: [[Medication]] { [notTakenMeds, takenMeds] }
    var notTakenMeds: [Medication] = []
    var takenMeds: [Medication] = []
    
    private lazy var fetchRequest : NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: "Medication")
        
        request.predicate = NSPredicate(value: true)
        
        return request
    }()
    
    private init(){}
    
    //MARK: - CRUD Functions
    func createMedication(name: String, timeOfDay: Date) {
        let medication = Medication(name: name, timeOfDay: timeOfDay)
        notTakenMeds.append(medication)
        
        CoreDataStack.saveContext()
        
        notificationScheduler.scheduleNotification(for: medication)
    }
    
    func fetchMedications() {
        let medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        
        takenMeds = medications.filter { $0.wasTakenToday() }
        notTakenMeds = medications.filter { !$0.wasTakenToday() }
        
    }
    
    func updateMedicationDetails(medication: Medication, name: String, date: Date) {
        medication.name = name
        medication.timeOfDay = date
        
        CoreDataStack.saveContext()
        if !medication.wasTakenToday(){
            notificationScheduler.scheduleNotification(for: medication)
        }
    }
    
    func updateMedicationStatus(_ wasTaken: Bool, medication: Medication){
        if wasTaken {
            TakenDate(medication: medication)
            guard let index = notTakenMeds.firstIndex(of: medication) else { return }
            takenMeds.append(medication)
            notTakenMeds.remove(at: index)
            notificationScheduler.clearNotifications(for: medication)
        } else {
            let mutableTakenDates = medication.mutableSetValue(forKey: "takenDates")
            
            if let takenDate = (mutableTakenDates as? Set<TakenDate>)?.first(where: {
                takenDate in
                guard let date = takenDate.date else { return false}
                
                return Calendar.current.isDate(date, inSameDayAs: Date())
            }){
                mutableTakenDates.remove(takenDate)
                if let index = takenMeds.firstIndex(of: medication) {
                    takenMeds.remove(at: index)
                    notTakenMeds.append(medication)
                    notificationScheduler.scheduleNotification(for: medication)
                }
            }
            CoreDataStack.saveContext()
        }
    }
    
    func deleteMedication(medication: Medication) {
        if medication.wasTakenToday(){
            guard let index = takenMeds.firstIndex(of: medication) else { return }
            takenMeds.remove(at: index)
        } else {
            guard let index = notTakenMeds.firstIndex(of: medication) else { return }
            notTakenMeds.remove(at: index)
        }
        
        CoreDataStack.context.delete(medication)
        CoreDataStack.saveContext()
        
        notificationScheduler.clearNotifications(for: medication)
    }
    
    func markMedication(with id: String){
        guard let uuid = UUID(uuidString: id),
              let medication = notTakenMeds.first(where: { $0.id == uuid }) else { return }
        TakenDate(medication: medication)
        CoreDataStack.saveContext()
    }
    
}
