//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Ben Erekson on 7/26/21.
//

import UIKit

protocol MedicationCellDelegate: AnyObject {
    func isCompleteWasTapped(wasTaken: Bool, medication: Medication)
}

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
    weak var delegate: MedicationCellDelegate?
    var medication: Medication?
    private var wasTakenToday: Bool = false
    
    //MARK: - Actions
    @IBAction func isDoneButtonTapped(_ sender: Any) {
        guard let delegate = delegate,
              let medication = medication else { return }
        wasTakenToday.toggle()
        delegate.isCompleteWasTapped(wasTaken: wasTakenToday, medication: medication)
        CoreDataStack.saveContext()
    }
    
    //MARK: - Helper Methods
    func configure(with medication: Medication){
        self.medication = medication
        wasTakenToday = medication.wasTakenToday()
        
        nameLable.text = medication.name
        timeLable.text = medication.timeOfDay?.dateAsString()
        
        let image = wasTakenToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        isDoneButton.setImage(image, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        medication = nil
        wasTakenToday = false
    }

    
}//End Of Class
