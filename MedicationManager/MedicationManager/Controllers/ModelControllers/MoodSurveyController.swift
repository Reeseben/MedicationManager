//
//  MoodSurveyController.swift
//  MedicationManager
//
//  Created by Ben Erekson on 7/28/21.
//

import CoreData

class MoodSurveyController{
    static let shared = MoodSurveyController()
    
    var todaysMoodSurvey: MoodSurvey?
    
    private lazy var fetchRequest: NSFetchRequest<MoodSurvey> = {
        
        let request = NSFetchRequest<MoodSurvey>(entityName: "MoodSurvey")
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()
        
        let afterPredicate = NSPredicate(format: "date > %@", startOfDay as NSDate)
        let beforePredicate = NSPredicate(format: "date < %@", endOfDay as NSDate)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [afterPredicate, beforePredicate])
        
        return request
    }()
    
    func didTapMoodEmoji(_ emoji: String){
        if let todaysMoodSurvey = todaysMoodSurvey{
            update(moodSurvey: todaysMoodSurvey, moodEmoji: emoji)
        } else {
            createMoodSurvey(with: emoji)
        }
    }
    
    //MARK: - CRUD Functions
    
    func fetchMoodSurvey() {
        let todaysMoodSurvey = ((try? CoreDataStack.context.fetch(fetchRequest)) ?? []).first
        
        self.todaysMoodSurvey = todaysMoodSurvey
    }
    
    private func createMoodSurvey(with moodEmoji: String) {
        let moodSurvey = MoodSurvey(mentalState: moodEmoji)
        todaysMoodSurvey = moodSurvey
        
        CoreDataStack.saveContext()
    }
    
    private func update(moodSurvey: MoodSurvey, moodEmoji: String) {
        moodSurvey.mentalState = moodEmoji
        
        CoreDataStack.saveContext()
    }
    
    
    
}//End Of Class
