//
//  TodayIFeelViewController.swift
//  MedicationManager
//
//  Created by Ben Erekson on 7/28/21.
//

import UIKit

protocol TodayIFeelDelegate: AnyObject {
    func moodButtonTapped(with emoji: String)
}

class TodayIFeelViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var mehButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    
    //MARK: - Properties
    weak var delegate: TodayIFeelDelegate?
    
    
    //MARK: - Reaction Arrays
    let good = ["😀","😁","😊","🙂","😎","🤩","🥳","😃","👍","🦄"]
    let meh = ["😐","😑","😬","😮","🤐","😶","🤨","😕","🤨","🙃"]
    let bad = ["😡","😠","🤬","☹️","😵","😧","🤮","🤢","👎","🤕"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goodButton.setTitle("😮", for: .highlighted)
        mehButton.setTitle("😮", for: .highlighted)
        badButton.setTitle("😮", for: .highlighted)
        
        goodButton.setTitle(good.randomElement(), for: .normal)
        mehButton.setTitle(meh.randomElement(), for: .normal)
        badButton.setTitle(bad.randomElement(), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired), name: Notification.Name(StringConstants.reminderReceivedNotificationName), object: nil)
    }
    
    //MARK: - Actions
    
    @IBAction func CloseButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moodButtonTapped(_ sender: UIButton) {
        guard let emotion = sender.title(for: .normal) else { return }
        delegate?.moodButtonTapped(with: emotion)
        MoodSurveyController.shared.didTapMoodEmoji(emotion)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Methods
    @objc func reminderFired() {
        view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .systemBackground
        }
    }
    

}
