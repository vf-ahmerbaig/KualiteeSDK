//
//  KualiteeCanvas.swift
//  DeepLinkTest
//
//  Created by VF on 07/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import UIKit

class KualiteeCanvas: UIView {
    
    var lines: [CanvasPoint] = []
    
    var currentColor: UIColor = UIColor.black
    var currentBrushWidth: CGFloat = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.drawOnCurrentContext()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(CanvasPoint.init(color: self.currentColor, points: [], width: self.currentBrushWidth))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        
        guard var lastLine = lines.popLast() else {
            return
        }
        
        lastLine.points.append(point)
        lines.append(lastLine)
        self.setNeedsDisplay()
    }
    
    fileprivate func drawOnCurrentContext() {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setLineCap(.round)
        
        for line in lines {
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(line.width)
            for (i, p) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            context.strokePath()
        }
    }
    
    func updateBrushColor(with color: UIColor) {
        self.currentColor = color
    }
    
    func updateBrushWidth(with width: CGFloat) {
        self.currentBrushWidth = width
    }
    
    func undoChanges() {
        _ = self.lines.popLast()
        self.setNeedsDisplay()
    }
    
    func clearAll() {
        self.lines.removeAll()
        self.setNeedsDisplay()
    }
}
