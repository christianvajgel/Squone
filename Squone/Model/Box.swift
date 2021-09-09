//
//  Box.swift
//  Squone
//
//  Created by chris on 30/07/21.
//

import UIKit

enum BoxType {
   case boxTypeEmpty,
        boxTypePlayer1,
        boxTypePlayer2
}

class Box: NSObject {
    
    var top: Line!
    var right: Line!
    var bottom: Line!
    var left: Line!
    var boxType: BoxType!
    
    // 0 - top / 1 - right / 2 - bottom / 3 - left
    // var boxState = []
    var id: String!
    
    func boxContainsLine(_ line: Line) -> Bool {
        
        if (line == self.top) {
            return true;
        } else if (line == self.right) {
            return true;
        } else if (line == self.bottom) {
            return true;
        } else if (line == self.left) {
            return true;
        }
        return false;
    }
    
    func checkAndSetTypeOfCompletedBox(_ playerType: PlayerType) {
        
        if self.top.lineType != LineType.lineTypeEmpty && self.right.lineType != LineType.lineTypeEmpty && self.left.lineType != LineType.lineTypeEmpty && self.bottom.lineType != LineType.lineTypeEmpty {
            
            if playerType == PlayerType.playerType1 {
                self.boxType = BoxType.boxTypePlayer1
                GameView.player_counter += 1
            } else  if playerType == PlayerType.playerType2 {
                self.boxType = BoxType.boxTypePlayer2
                GameView.computer_counter += 1
            }
        }
    }
    
    override var description : String {
        
        return "Box type \(self.boxType) at top \(self.top)"
    }
    
}
