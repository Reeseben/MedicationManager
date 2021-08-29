//
//  ViewController.swift
//  MedicationManager
//
//  Created by Aaron Martinez on 12/20/20.
//

import UIKit

class MedicationListViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moodButton: UIButton!
    
    //MARK: - Variability Arrays
    let messages = ["Welcome Back", "Medication Manager", "How are you today?", "Its a good day"]
    
    //MARK: - LifeCycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        MedicationController.shared.fetchMedications()
        MoodSurveyController.shared.fetchMoodSurvey()
        updateMoodSurvey()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Medication Manager"
        tableView.delegate = self
        tableView.dataSource = self
        self.title = messages.randomElement()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired), name: Notification.Name(StringConstants.reminderReceivedNotificationName), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name(UIApplication.didBecomeActiveNotification.rawValue), object: nil)
        
    }
    
    //MARK: - Actions
    @IBAction func moodButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        guard let moodSurveyVC = storyboard.instantiateViewController(identifier: "todayIFeelViewController") as? TodayIFeelViewController else { return }
        moodSurveyVC.modalPresentationStyle = .popover
        moodSurveyVC.delegate = self
        navigationController?.present(moodSurveyVC, animated: true)
    }
    
    //MARK: - Helper Methods
    func updateMoodSurvey(){
        if let todaysMood = MoodSurveyController.shared.todaysMoodSurvey?.mentalState {
        moodButton.setTitle(todaysMood, for: .normal)
        } else {
            moodButton.setTitle("❓", for: .normal)
        }
    }
    
    @objc func reminderFired(){
        tableView.backgroundColor = .cyan
        view.backgroundColor = .cyan
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.tableView.backgroundColor = .systemBackground
            self.view.backgroundColor = .systemBackground
        }
    }
    
    @objc func reloadTableView(){
        MedicationController.shared.fetchMedications()
        tableView.reloadData()
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        if segue.identifier == "toEditMedication"{
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? MedicationDetailViewController else { return }
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            destination.medication = medication
        
        }
    }

}

extension MedicationListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return MedicationController.shared.sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Not Taken"
        } else if section == 1 {
            return "Taken"
        } else {
            return "Other"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MedicationController.shared.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell else { return UITableViewCell() }
        
        let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
        
        cell.configure(with: medication)
        
        cell.medication = medication
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let medicationToDelete = MedicationController.shared.sections[indexPath.section][indexPath.row]
            MedicationController.shared.deleteMedication(medication: medicationToDelete)
            MedicationController.shared.fetchMedications()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}//End of Extension

extension MedicationListViewController: MedicationCellDelegate{
    func isCompleteWasTapped(wasTaken: Bool, medication: Medication) {
        MedicationController.shared.updateMedicationStatus(wasTaken, medication: medication)
        tableView.reloadData()
    }
    
    
}

extension MedicationListViewController: TodayIFeelDelegate {
    func moodButtonTapped(with emoji: String) {
        moodButton.setTitle(emoji, for: .normal)
    }
    
    
}
