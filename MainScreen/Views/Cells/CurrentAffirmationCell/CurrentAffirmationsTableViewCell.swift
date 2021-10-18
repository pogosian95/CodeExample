//
//  CurrentAffirmationsTableViewCell.swift
//  AffirmationDays
//
//  Created by Oleg Pogosian on 14.10.2021.
//

import UIKit

protocol CurrentAffirmationsTableViewCellProtocol {
    func display(image: String, currentDay: Int, name: String)
}

class CurrentAffirmationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var affirmImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet var dayViews: [DayView]!
    
    // MARK: - Private Properties
    var currentDay = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetContent()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetContent()
    }
     
    private func resetContent() {
        for element in dayViews {
            element.backgroundColor = .white
            element.viewBorder(color: .clear, width: 1)
        }
    }
    
    private func setupView() {
        bgView.viewCorner(20)
    }
    
    override func layoutSubviews() {
        for (index, view) in dayViews.enumerated() {
            view.textLabel.text = "\(index + 1)"
            
            if (index + 1) == currentDay {
                view.backgroundColor = .white
                view.viewBorder(color: .appColor(.selectedAppColor), width: 1)
            }
            
            if (index + 1) < currentDay {
                view.backgroundColor = .appColor(.selectedAppColor)
                view.textLabel.textColor = .white
            } else {
                view.textLabel.textColor = .appColor(.selectedAppColor)
            }
            
        }
    }
    
}

extension CurrentAffirmationsTableViewCell: CurrentAffirmationsTableViewCellProtocol {
    
    func display(image: String, currentDay: Int, name: String) {
//        affirmImage.image = .appImage(image)
        self.currentDay = currentDay + 1
        nameLabel.text = name
        self.layoutIfNeeded()
    }
    
}
