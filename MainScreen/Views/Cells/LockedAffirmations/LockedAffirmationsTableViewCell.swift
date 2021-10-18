//
//  LockedAffirmationsTableViewCell.swift
//  AffirmationDays
//
//  Created by Oleg Pogosian on 15.10.2021.
//

import UIKit

protocol LockedAffirmationsTableViewCellProtocol {
    func display(image: String, name: String)
}

class LockedAffirmationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var affirmImage: UIImageView!
    @IBOutlet weak var affirmName: UILabel!
    
    
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
        
    }
    
    private func setupView() {
        
    }
    
}

extension LockedAffirmationsTableViewCell: LockedAffirmationsTableViewCellProtocol {
    
    func display(image: String, name: String) {
        affirmImage.image = .appImage(.textAffirmIcon)
        affirmName.text = name
    }
    
}
