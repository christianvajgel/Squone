//
//  Dot.swift
//  Squone
//
//  Created by chris on 28/07/21.
//

import UIKit

class Dot: NSObject {
    
    var point: CGPoint!
    var location: CGPoint!
    
    override var description : String {
        
        return "(\(self.point.x),\(self.point.y))"
    }
}
