//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Ben Erekson on 7/26/21.
//

import UIKit

class MedicationTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var isDoneButton: UIButton!
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Properties
    
    //MARK: - Actions
    @IBAction func isDoneButtonTapped(_ sender: Any) {
        print("med has been taken.")
    }
    
    //MARK: - Helper Methods
    func configure(with medication: Medication){
        nameLable.text = medication.name
        timeLable.text = medication.timeOfDay?.dateAsString()
    }

    
}//End Of Class
