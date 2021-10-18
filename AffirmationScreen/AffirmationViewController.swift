//
//  ViewController.swift
//  AffirmationDays
//
//  Created by Oleg Pogosian on 14.10.2021.
//

import UIKit

class AffirmationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var affirmationTextLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    
    // MARK: - Properties
    //    var affirmations = ["I am the architect of my life; I build its foundation and choose its contents.", "Today, I am brimming with energy and overflowing with joy.", "My body is healthy; my mind is brilliant; my soul is tranquil.", "I am superior to negative thoughts and low actions.", "I have been given endless talents which I begin to utilize today.", "I forgive those who have harmed me in my past and peacefully detach from them.", "A river of compassion washes away my anger and replaces it with love.", "I am guided in my every step by Spirit who leads me towards what I must know and do.", "If you're married My marriage is becoming stronger, deeper, and more stable each day."]
    var category = Categories()
    var currentAffirmationIndex = 0
    var currentDay = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSwipeGestures()
        currentDay = Int(category.currentDay)
        affirmationTextLabel.text = category.affirmations?[Int(category.currentDay)][currentAffirmationIndex]
        countLabel.text = "\(currentAffirmationIndex + 1)/\(category.affirmations?[currentDay].count ?? 0)"
        closeButton.viewCorner(closeButton.frame.height / 2)
        dayButton.viewCorner(dayButton.frame.height / 2)
        dayButton.setTitle("Day \(currentDay + 1)", for: .normal)
    }
    
    private func setupSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    // MARK: - Actions
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            showAffirmation(swipeGesture.direction)
        }
    }
    
    private func showAffirmation(_ direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .left, .up:
            if currentAffirmationIndex == (category.affirmations?[currentDay].count ?? 0) - 1 {
//                self.currentDay += 1
                if self.currentDay == category.currentDay {
                    category.currentDay += 1
                    setupEndAlert()
                }
                DatabaseHelper().save()
                
                return
            }
            currentAffirmationIndex += 1
            animateChangingText()
        case .right, .down:
            if currentAffirmationIndex == 0 {
                return
            }
            currentAffirmationIndex -= 1
            animateChangingText()
        default:
            break
        }
    }
    
    private func animateChangingText() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.affirmationTextLabel.transform = .init(scaleX: 0.5, y: 0.5)
            self.affirmationTextLabel.alpha = 0
        }) { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.affirmationTextLabel.text =
                    self.category.affirmations?[self.currentDay][self.currentAffirmationIndex]
                self.affirmationTextLabel.alpha = 1
                self.affirmationTextLabel.transform = .identity
                self.countLabel.text = "\(self.currentAffirmationIndex + 1)/\(self.category.affirmations?[Int(self.currentDay)].count ?? 0)"
            })
        }
    }
    
    private func setupEndAlert() {
        let customAlert: CompleteDayAlertView = .fromNib()
        customAlert.alpha = 0
        customAlert.frame = self.view.frame
        customAlert.center = self.view.center
        customAlert.bigTextLabel.text = "You’ve complieted Day \(self.currentDay + 1)!"
        customAlert.smallTextLabel.text = "Keep up and come back tomorrow for a new set of motivation and inspiration!"
        
        self.view.addSubview(customAlert)
        
        customAlert.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.4) {
            customAlert.alpha = 1
            customAlert.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - IBActions
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func dayButtonAction(_ sender: Any) {
        
        var alertActions: [UIAlertAction] = []
        for number in 0...category.currentDay {
            let day = number + 1
            alertActions.append(UIAlertAction(title: "Day \(day)", style: .default, handler: { _ in
                
                if self.category.currentDay < number {
                    self.showAlert(title: "This day is locked", message: "You cant open this day", completion: nil)
                    
                    return
                }
                
                self.dayButton.setTitle("Day \(day)", for: .normal)
                self.currentDay = Int(number)
                self.affirmationTextLabel.text = self.category.affirmations?[self.currentDay][0]
                self.currentAffirmationIndex = 0
                self.countLabel.text = "\(self.currentAffirmationIndex + 1)/\(self.category.affirmations?[Int(number)].count ?? 0)"
            }))
        }
        
        alertActions.append(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.choiceAlert(title: "Pick Day", message: nil, customAction: alertActions)
    }
    
}


//struct CategoryAffirm {
//    var categoryName: String
//    var currentDay: Int
//    var isFinished: Bool
//    var affirmations: [Affrimation]
//}
//
//struct Affrimation {
//    var affirmationsArray: [String]
//    var isCompleted: Bool
//}
