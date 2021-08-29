//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Ben Erekson on 7/26/21.
//

import UIKit

class MedicationDetailViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var medicationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK: - Properties
    var medication: Medication?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired), name: Notification.Name(StringConstants.reminderReceivedNotificationName), object: nil)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = medicationTextField.text, !name.isEmpty else { return }
        if let medication = medication {
            MedicationController.shared.updateMedicationDetails(medication: medication, name: name, date: datePicker.date)
        } else {
            MedicationController.shared.createMedication(name: name, timeOfDay: datePicker.date)
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Methods
    func updateViews(){
        guard let medication = medication else { return }
        medicationTextField.text = medication.name
        datePicker.date = medication.timeOfDay ?? Date()
    }
    
    @objc func reminderFired() {
        view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .systemBackground
        }
    }

}//End Of Class
