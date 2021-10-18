//
//  DayView.swift
//  AffirmationDays
//
//  Created by Oleg Pogosian on 15.10.2021.
//

import UIKit

protocol DayViewProtocol: class {
    
}

@IBDesignable
final class DayView: UIView {
    
    let textLabel = UILabel()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUpTheView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTheView()
    }
    @IBInspectable var lableTextColor: UIColor = .black {
        didSet {
            textLabel.textColor = lableTextColor
        }
    }
    @IBInspectable var labelBorderWidth: CGFloat = 5 {
        didSet {
            textLabel.layer.borderWidth = labelBorderWidth
        }
    }
    @IBInspectable var randomCustomVariable: Bool = false
    private func setUpTheView() -> Void {
        self.backgroundColor = .white
        textLabel.text = "Hey, magic!"
        textLabel.textColor = lableTextColor
        textLabel.font = UIFont.systemFont(ofSize: 12)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        addSubview(textLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.frame = bounds
        self.viewCorner()
        self.syncWithIB()
    }
    
    /* override func prepareForInterfaceBuilder() {
     self.syncWithIB();
     }*/
    func syncWithIB(){
        self.backgroundColor = .white
        
        if(randomCustomVariable == true) {
            textLabel.text = "Wow, this works too"
        }
    }
    
}
