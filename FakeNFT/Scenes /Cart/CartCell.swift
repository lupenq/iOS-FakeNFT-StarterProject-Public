//
//  CartCell.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 18.06.2026.
//

import UIKit

class CartCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Initialisers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
