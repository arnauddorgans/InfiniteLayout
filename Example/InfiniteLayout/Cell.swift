//
//  Cell.swift
//  InfiniteLayout_Example
//
//  Created by Arnaud Dorgans on 21/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: CellView!
    
    func update(index: Int) {
        cellView.update(index: index)
    }
}

enum CellStyle {
    case circular
    case `default`
    
    static let all = [circular, `default`]
}

@IBDesignable class CellView: UIView {
    
    let titleLabel = UILabel()
    
    let colors = [#colorLiteral(red: 0.5254901961, green: 0.6901960784, blue: 0.9137254902, alpha: 1), #colorLiteral(red: 0.5254901961, green: 0.6196078431, blue: 0.9137254902, alpha: 1), #colorLiteral(red: 0.6078431373, green: 0.5254901961, blue: 0.9137254902, alpha: 1), #colorLiteral(red: 0.9137254902, green: 0.5254901961, blue: 0.8392156863, alpha: 1), #colorLiteral(red: 0.9137254902, green: 0.5254901961, blue: 0.6, alpha: 1), #colorLiteral(red: 0.9137254902, green: 0.6784313725, blue: 0.5254901961, alpha: 1), #colorLiteral(red: 0.9137254902, green: 0.9058823529, blue: 0.5254901961, alpha: 1), #colorLiteral(red: 0.5254901961, green: 0.9137254902, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.5254901961, green: 0.8, blue: 0.9137254902, alpha: 1)]
    
    @IBInspectable var styleIndex: Int {
        get { return CellStyle.all.index(of: style)! }
        set { style = CellStyle.all[newValue % CellStyle.all.count] }
    }
    
    var style: CellStyle = .default {
        didSet {
            updateStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func sharedInit() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        self.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func update(index: Int) {
        self.titleLabel.text = String(index + 1)
        self.backgroundColor = colors[index % colors.count]
    }
    
    func updateStyle() {
        switch style {
        case .default:
            self.layer.cornerRadius = 8
        case .circular:
            self.layer.cornerRadius = self.frame.height / 2
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }

    override func prepareForInterfaceBuilder() {
        self.update(index: 0)
    }
}
