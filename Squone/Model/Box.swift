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
                
                UIView.transition(with: GameView.scorePlayerCounter, duration: 0.5, options: .transitionCrossDissolve, animations:
                                    {
                                        GameView.scorePlayerCounter.textColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.70)
                                    }, completion: nil)
                
            } else  if playerType == PlayerType.playerType2 {
                
                self.boxType = BoxType.boxTypePlayer2
                
                GameView.computer_counter += 1
                
                UIView.transition(with: GameView.scoreComputerCounter, duration: 0.5, options: .transitionCrossDissolve, animations:
                                    {
                                        GameView.scoreComputerCounter.textColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
                                    }, completion: nil)
            }
        }
    }
    
    override var description : String {
        
        return "Box type \(String(describing: self.boxType)) at top \(String(describing: self.top))"
    }
    
}
