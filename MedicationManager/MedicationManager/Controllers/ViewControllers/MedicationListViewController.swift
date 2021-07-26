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
    
    //MARK: - LifeCycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        MedicationController.shared.fetchMedications()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Medication Manager"
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    //MARK: - Helper Methods
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        if segue.identifier == "toEditMedication"{
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? MedicationDetailViewController else { return }
            let medicaiton = MedicationController.shared.medications[indexPath.row]
            destination.medication = medicaiton
        
        }
    }

}

extension MedicationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MedicationController.shared.medications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell else { return UITableViewCell() }
        
        let medication = MedicationController.shared.medications[indexPath.row]
        
        cell.nameLable.text = medication.name
        cell.timeLable.text = medication.timeOfDay?.dateAsString()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}//End of Extension
