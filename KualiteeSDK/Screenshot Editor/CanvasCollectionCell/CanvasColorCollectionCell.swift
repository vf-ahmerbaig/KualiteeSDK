//
//  CanvasColorCollectionCell.swift
//  KualiteeSDKSwift
//
//  Created by VF on 07/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import UIKit

class CanvasColorCollectionCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.getRounded(cornerRadius: self.frame.width/2)
    }
    
    deinit {
        print("CanvasColorCollectionCell deinit")
    }
}
