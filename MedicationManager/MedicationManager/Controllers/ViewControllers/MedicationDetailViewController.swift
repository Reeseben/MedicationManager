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

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = medicationTextField.text, !name.isEmpty else { return }
        if let medication = medication {
            MedicationController.shared.updateMedication(medication: medication, name: name, date: datePicker.date)
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

}//End Of Class
