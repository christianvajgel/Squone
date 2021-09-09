//
//  GameView.swift
//  TestSO
//
//  Created by chris on 03/08/21.
//

import UIKit
import AVFoundation

class GameView: UIView {
    
    var board: [[String]]
    
    var dotArray: Array<Dot>
    var lineArray: Array<Line>
    var boxArray: Array<Box>
    var currentLine: Line!
    var lineLayer = CAShapeLayer()
    var counter = 0
    static var player_counter = 0
    static var computer_counter = 0
    var txtField: UITextField = UITextField(frame: CGRect(x: 120.00, y: 80.00, width: 250.00, height: 60.00))
    
    override init(frame: CGRect) {
        
        self.board = []
        
        //print("\nInitializing arrays")
        self.dotArray = Array<Dot>()
        self.lineArray = Array<Line>()
        self.boxArray = Array<Box>()
        super.init(frame: frame)
        
//        var txtField: UITextField = UITextField(frame: CGRect(x: 120.00, y: 80.00, width: 250.00, height: 60.00))
        self.addSubview(txtField)
        
        txtField.borderStyle = UITextField.BorderStyle.none
        txtField.text = "Player \(GameView.player_counter)\nComputer \(GameView.computer_counter)"
        txtField.backgroundColor = UIColor.white
        
        //print("\nSetting background and game variables")
        self.backgroundColor = UIColor.white
        let xCount = 4
        let yCount = 4
        let size = (frame.size.width - 80) / CGFloat(xCount - 1)
//        var y = 80
        var y = 180
        
        //print("\n****** Building board")
        for i in 0  ..< xCount {
            var x = 40
            
            for j in 0  ..< yCount {
                
                let dot = Dot()
                dot.location = CGPoint(x: CGFloat(x), y: CGFloat(y))
                dot.point = CGPoint(x: CGFloat(j), y: CGFloat(i))
                //                //print("dot is \(dot)\n")
                self.dotArray.append(dot)
                //                //print("dotArray is \(self.dotArray)\n")
                x += Int(size)
            }
            y += Int(size)
            
        }
        
        //print("\nCreating lines")
        for i in 0  ..< xCount {
            for j in 0  ..< yCount {
                
                if i < (xCount - 1) {
                    self.createLineFrom(CGPoint(x: CGFloat(i), y: CGFloat(j)), To: CGPoint(x: CGFloat(i+1), y: CGFloat(j)))
                }
                if j < (yCount - 1) {
                    self.createLineFrom(CGPoint(x: CGFloat(i), y: CGFloat(j)), To: CGPoint(x: CGFloat(i), y: CGFloat(j+1)))
                }
            }
        }
        //print("Created lines OK")
        //        //print("\n### LINE ARRAY \n")
        //        //print(lineArray)
        //        //print("\n### DOT ARRAY \n")
        //        //print(dotArray)
        //        //print("\n\n")
        
        //print("\nCreating boxes")
        for i in 0  ..< xCount {
            for j in 0  ..< yCount {
                
                if i < (xCount - 1) && j < (yCount - 1) {
                    self.createBoxFrom(CGPoint(x: CGFloat(i), y: CGFloat(j)))
                }
            }
        }
        //print("Created boxes OK")
        //print("\n****** Build board OK")
        
        //print("\nSetting animation for the lines")
        //NNNN this lines are about line animations:
        self.lineLayer = CAShapeLayer(layer: layer)
        self.lineLayer.backgroundColor = UIColor.clear.cgColor
        self.lineLayer.strokeColor = UIColor.darkGray.cgColor
        self.lineLayer.lineWidth = 8
        self.lineLayer.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.addSublayer(self.lineLayer)
        self.newGame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateLine(_ line: Line) {
        //print("\nFunction: \(#function), line: \(#line)")
        let fromPath = UIBezierPath()
        fromPath.move(to: line.endpoint2.location)
        fromPath.addLine(to: line.endpoint1.location)
        
        let toPath = UIBezierPath()
        toPath.move(to: line.endpoint2.location)
        toPath.addLine(to: line.endpoint2.location)
        let pathAnim = CABasicAnimation(keyPath: "path")
        pathAnim.fromValue = fromPath.cgPath
        pathAnim.toValue = toPath.cgPath
        pathAnim.duration = 0.5
        self.lineLayer.add(pathAnim, forKey: "pathAnimation")
        self.lineLayer.setNeedsDisplay()
    }
    
    @objc func checkGameOver() {
        //print("\nFunction: \(#function), line: \(#line)")
        if self.gameOver() {
            if self.player1Won() {
                //                //print("You won!!")
                self.newGame()
            } else {
                //                //print("I won!!")
                self.newGame()
                
            }
        }
    }
    
    func tapAtPoint(_ point:CGPoint) {
        //print("\nFunction: \(#function), line: \(#line)")
        let line = self.currentLine
        if line != nil && line!.lineType == LineType.lineTypeEmpty {
            line?.lineType = LineType.lineTypePlayer1
            var completed = false
            if self.checkAndSetBoxComplete(line!, playerType: PlayerType.playerType1) {
                completed = true
                self.checkGameOver()
            }
            //            self.setNeedsDisplay()
            
            if !completed {
                self.computerPlay()
            }
        }
    }
    
    func findDot(_ point: CGPoint) -> Dot? {
        //print("\nFunction: \(#function), line: \(#line)")
        for dot in self.dotArray {
            if dot.point.equalTo(point) {
                return dot
            }
        }
        return nil
    }
    
    func findLine(_ p1: CGPoint, To p2: CGPoint) -> Line? {
        //print("\nFunction: \(#function), line: \(#line)")
        for line in self.lineArray {
            if p1.equalTo(line.endpoint1.point) && p2.equalTo(line.endpoint2.point) {
                return line
            }
        }
        return nil
    }
    
    func findLineAtLocation(_ point: CGPoint) -> Line? {
        //print("\nFunction: \(#function), line: \(#line)")
        for line in self.lineArray {
            let rect = line.getTouchRect()
            if rect.contains(point) {
                return line
            }
        }
        return nil
    }
    
    func createLineFrom(_ p1: CGPoint, To p2: CGPoint) {
        //print("\nFunction: \(#function), line: \(#line)")
        
        let line = Line(WithEndpoint1: self.findDot(p1)!, endpoint2: self.findDot(p2)!)
        self.lineArray.append(line)
        //        //print("lineArray is \(self.lineArray)\n")
    }
    
    func createBoxFrom(_ point: CGPoint) {
        //print("\nFunction: \(#function), line: \(#line)")
        let box = Box()
        let p1 = point
        let p2 = CGPoint(x: point.x + 1, y: point.y)
        let p3 = CGPoint(x: point.x + 1, y: point.y + 1)
        let p4 = CGPoint(x: point.x, y: point.y + 1)
        box.top = self.findLine(p1, To: p2)
        box.right = self.findLine(p2, To: p3)
        box.left = self.findLine(p1, To: p4)
        box.bottom = self.findLine(p4, To: p3)
        box.id = String(self.counter)
        self.boxArray.append(box)
        
        //print(self.counter)
        
        self.counter = self.counter + 1
        
        //print(self.counter)
        //        //print("boxArray is \(self.boxArray)\n")
    }
    
    func checkAndSetBoxComplete(_ line: Line, playerType type: PlayerType) -> Bool {
        //print("\nFunction: \(#function), line: \(#line)")
        var completeCount = 0
        for box in boxArray {
            if box.boxType == BoxType.boxTypeEmpty && box.boxContainsLine(line) {
                box.checkAndSetTypeOfCompletedBox(type)
                if box.boxType != BoxType.boxTypeEmpty {
                    completeCount += 1
                }
            }
        }
        txtField.text = "Player \(GameView.player_counter)\nComputer \(GameView.computer_counter)"
        return completeCount > 0
    }
    
    func gameOver() -> Bool {
        //print("\nFunction: \(#function), line: \(#line)")
        for box in self.boxArray {
            if box.boxType == BoxType.boxTypeEmpty {
                return false
            }
        }
        return true
    }
    
    func player1Won() -> Bool {
        //print("\nFunction: \(#function), line: \(#line)")
        var count1 = 0
        var count2 = 0
        for box in self.boxArray {
            if box.boxType == BoxType.boxTypePlayer1 {
                count1 += 1
            } else if box.boxType == BoxType.boxTypePlayer2 {
                count2 += 1
            }
        }
        return count1 >= count2
    }
    
    func newGame() {
        //print("\nFunction: \(#function), line: \(#line)")
        for line in self.lineArray {
            line.lineType = LineType.lineTypeEmpty
        }
        for box in boxArray {
            box.boxType = BoxType.boxTypeEmpty
        }
        
        let stepAnim = CABasicAnimation(keyPath: "position")
        let x = self.layer.frame.size.width/2
        stepAnim.fromValue = NSValue(cgPoint: CGPoint(x: x, y: -(self.layer.frame.size.height / 2.0)))
        stepAnim.toValue = NSValue(cgPoint: CGPoint(x: x, y: (self.layer.frame.size.height / 2.0)))
        stepAnim.duration = 1
        
        GameView.player_counter = 0
        GameView.computer_counter = 0
        txtField.text = "Player \(GameView.player_counter)\nComputer \(GameView.computer_counter)"
        
        self.setNeedsDisplay()
        
        updateBoard()
//        print("Board newGame -> \(self.board)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("\nFunction: \(#function), line: \(#line)")
        let t = touches.first
        let location = t!.location(in: self)
        let line = findLineAtLocation(location)
        if line != nil {
            self.currentLine = line
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("\nFunction: \(#function), line: \(#line)")
        //        //print("touchesEnded")
        let t = touches.first
        let point = t!.location(in: self)
        self.tapAtPoint(point)
        self.currentLine = nil
        self.setNeedsDisplay()
    }
    
    func strokeDot(_ dot: Dot) {
        //print("\nFunction: \(#function), line: \(#line)")
        // Ebony Clay #22313F
        let dotColor = UIColor(red: 34.0/255.0, green: 49/255.0, blue: 62/255.0, alpha: 1)
        dotColor.setFill()
        UIColor.darkGray.setStroke()
        let bp = UIBezierPath()
        bp.lineWidth = 2
        bp.lineCapStyle = CGLineCap.square
        bp.addArc(withCenter: dot.location, radius: 5, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        bp.fill()
        bp.addArc(withCenter: dot.location, radius: 6, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        bp.stroke()
    }
    
    func strokeLine(_ line: Line) {
        //print("\nFunction: \(#function), line: \(#line)")
        let bp = UIBezierPath()
        bp.lineWidth = 8
        bp.lineCapStyle = CGLineCap.round
        bp.move(to: line.endpoint1.location)
        bp.addLine(to: line.endpoint2.location)
        //        UIColor.darkGrayColor().setStroke()
        bp.stroke()
    }
    
    func strokeBox(_ box: Box) {
        //print("\nFunction: \(#function), line: \(#line)")
        let bp = UIBezierPath()
        bp.move(to: box.top.endpoint1.location)
        bp.addLine(to: box.top.endpoint2.location)
        bp.addLine(to: box.right.endpoint2.location)
        bp.addLine(to: box.left.endpoint2.location)
        bp.addLine(to: box.left.endpoint1.location)
        //        UIColor.darkGrayColor().setFill()
        bp.fill()
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        //print("\nFunction: \(#function), line: \(#line)")
        //        //print("drawRect")
        
        for dot in self.dotArray {
            self.strokeDot(dot)
        }
        
        for box in self.boxArray {
            if box.boxType == BoxType.boxTypePlayer1 {
                // Piction Blue #22A7F0
                let boxColor1 = UIColor(red: 34.0/255.0, green: 168.0/255.0, blue: 240.0/255.0, alpha: 1)
                boxColor1.setFill()
                self.strokeBox(box)
            } else if box.boxType == BoxType.boxTypePlayer2 {
                // Fire Bush #EB9532
                let boxColor2 = UIColor(red: 235/255, green: 149/255, blue: 50/255, alpha: 1)
                boxColor2.setFill()
                self.strokeBox(box)
            }
        }
        
        for line in self.lineArray {
            //print("\nFunction: \(#function), line: \(#line)")
            if line.lineType == LineType.lineTypePlayer1 {
                // Jelly Bean #2574A9
                let lineColor1 = UIColor(red: 37/255, green: 116/255, blue: 169/255, alpha: 1)
                lineColor1.setStroke()
                self.strokeLine(line)
            } else if line.lineType == LineType.lineTypePlayer2 {
                // Burnt Orange #D35400
                let lineColor2 = UIColor(red: 211/255, green: 84/255, blue: 0/255, alpha: 1)
                lineColor2.setStroke()
                self.strokeLine(line)
            }
        }
        
        // Ebony Clay #22313F
        let currentLineColor = UIColor(red: 34.0/255, green: 49.0/255, blue: 63.0/255, alpha: 1)
        currentLineColor.setStroke()
        //print("Ebony Clay")
        if self.currentLine != nil {
            self.strokeLine(self.currentLine)
        }

        // MARK: Calling updateBoard()
        updateBoard()
//        print("Board draw -> \(self.board)")
    }
    
    // MARK: Update Board
    func updateBoard() -> Void {
        
        for box in self.boxArray {
            
            if self.board.isEmpty {
                for b in self.boxArray {
                    self.board.append(setBoxState(b))
                }
            }
            
            for index in 0...self.board.count-1 {

                let square = self.board[index]
                
                if box.id == square[0] {
                    self.board[Int(square[0])!] = setBoxState(box)
                }
            }
        }
    }
    
    // MARK: Set Box State on Board
    func setBoxState(_ box: Box) -> [String] {
        
        var boxStateArray: [String] = [box.id]
        
        if box.top.lineType != LineType.lineTypeEmpty {
            boxStateArray.append("top")
        }
        if box.right.lineType != LineType.lineTypeEmpty {
            boxStateArray.append("right")
        }
        if box.bottom.lineType != LineType.lineTypeEmpty {
            boxStateArray.append("bottom")
        }
        if box.left.lineType != LineType.lineTypeEmpty {
            boxStateArray.append("left")
        }
        
        return boxStateArray
    }
    
    // MARK: Computer play
    @objc func computerPlay() {
        //        //print("computerPlay")
        //print("\nFunction: \(#function), line: \(#line)")
        let newLine = self.selectAline()
        if newLine != nil && newLine?.lineType == LineType.lineTypeEmpty {
            self.animateLine(newLine!)
            newLine?.lineType = LineType.lineTypePlayer2
            if self.checkAndSetBoxComplete(newLine!, playerType: PlayerType.playerType2) {
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameView.computerPlay), userInfo: nil, repeats: false)
                if self.gameOver() {
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameView.checkGameOver), userInfo: nil, repeats: false)
                }
            }
            self.setNeedsDisplay()
        }
    }
    
    func getBoxById(_ id: String) -> Box? {
//        print("getBoxById -> Id \(id)")
        for box in boxArray {
            if box.id == id {
                return box
            }
        }
        return nil
    }
    
    func getEmptyLineFromBox(_ id: String) -> [Line?] {
        
//        print("getEmptyLineFromBox -> Id \(id)")
        
        let board = self.board
//        let board = self.board
        let box = getBoxById(id)!
        var lineArray = [Line]()
        
        for square in board {
            
            if square[0] == id {
                
                if box.top.lineType == LineType.lineTypeEmpty {
                    lineArray.append(box.top)
                }
                if box.right.lineType == LineType.lineTypeEmpty {
                    lineArray.append(box.right)
                }
                if box.bottom.lineType == LineType.lineTypeEmpty {
                    lineArray.append(box.bottom)
                }
                if box.left.lineType == LineType.lineTypeEmpty {
                    lineArray.append(box.left)
                }
                
            }
            
        }
        return lineArray
    }
    
    // MARK: Computer's play logic
    func selectAline() -> Line? {
        //print("\nFunction: \(#function), line: \(#line)")
        
        updateBoard()
        
        let boardSorted = self.board
        
        let result = boardSorted.sorted { (a, b) -> Bool in
                    return a.count > b.count
        }
        
        var id = "0"
        var counter = 0
        
        var four: [[String]] = []
        var one: [[String]] = []
        var two: [[String]] = []
        var three: [[String]] = []
        
        while counter < result.count {
            
            switch result[counter].count {
            
            case 4:
                four.append(result[counter])
                break
            case 1:
                one.append(result[counter])
                break
            case 2:
                two.append(result[counter])
                break
            case 3:
                three.append(result[counter])
                break
            default:
                break
            }
            
            counter += 1
        }
        
//        print("***** FOUR: \(four)\n ONE: \(one)\n TWO: \(two)\n THREE: \(three) *****")
        
        if !four.isEmpty {
//            id = four[0][0]
            id = four[Int.random(in: 0..<four.count)][0]
//            print("---- FOUR: \(four)\nID: \(id) ----")
        }
        
        else if !one.isEmpty {
            let box = Int.random(in: 0 ..< one.count)
//            let line = Int.random(in: 0 ..< one[box].count)
            id = one[box][0]
//            print("- ONE: \(one)\nID: \(id) \nBOX: \(box)\nLINE: \(line) -")
            
//            id = one[0][0]
        }
        
        else if !two.isEmpty {
            let box = Int.random(in: 0 ..< two.count)
//            let line = Int.random(in: 0 ..< two[box].count)
            id = two[box][0]
//            print("-- TWO: \(two)\nID: \(id) \nBOX: \(box)\nLINE: \(line) --")
//            id = two[0][0]
        }
            
        else if !three.isEmpty {
//            let box = Int.random(in: 0 ..< three.count-1)
//            let line = Int.random(in: 0 ..< three[box].count-1)
//            id = three[box][line]
            id = three[0][0]
//            print("--- THREE: \(three)\nID: \(id) ---")
            
        }
        
        if four.isEmpty && two.isEmpty && one.isEmpty && three.isEmpty {
            return nil
        }
        
        let lines = getEmptyLineFromBox(id)
        
        let line_id = Int.random(in: 0 ..< lines.count)

        let line = lines[line_id]
        
        return line
        
        
//        var one = [Line]()
//        var two = [Line]()
//        var three = [Line]()
//        var four = [Line]()
//        for box in self.boxArray {
//            var emptyLines = 0
//            if box.top.lineType == LineType.lineTypeEmpty  {
//                emptyLines += 1
//            }
//            if box.left.lineType == LineType.lineTypeEmpty  {
//                emptyLines += 1
//            }
//            if box.right.lineType == LineType.lineTypeEmpty  {
//                emptyLines += 1
//            }
//            if box.bottom.lineType == LineType.lineTypeEmpty  {
//                emptyLines += 1
//            }
//
//            switch emptyLines {
//            case 1:
//                if box.top.lineType == LineType.lineTypeEmpty  {
//                    one.append(box.top)
//                }
//                if box.left.lineType == LineType.lineTypeEmpty  {
//                    one.append(box.left)
//                }
//                if box.right.lineType == LineType.lineTypeEmpty  {
//                    one.append(box.right)
//                }
//                if box.bottom.lineType == LineType.lineTypeEmpty  {
//                    one.append(box.bottom)
//                }
//            case 2:
//                if box.top.lineType == LineType.lineTypeEmpty  {
//                    two.append(box.top)
//                }
//                if box.left.lineType == LineType.lineTypeEmpty  {
//                    two.append(box.left)
//                }
//                if box.right.lineType == LineType.lineTypeEmpty  {
//                    two.append(box.right)
//                }
//                if box.bottom.lineType == LineType.lineTypeEmpty  {
//                    two.append(box.bottom)
//                }
//            case 3:
//                if box.top.lineType == LineType.lineTypeEmpty  {
//                    three.append(box.top)
//                }
//                if box.left.lineType == LineType.lineTypeEmpty  {
//                    three.append(box.left)
//                }
//                if box.right.lineType == LineType.lineTypeEmpty  {
//                    three.append(box.right)
//                }
//                if box.bottom.lineType == LineType.lineTypeEmpty  {
//                    three.append(box.bottom)
//                }
//            case 4:
//                if box.top.lineType == LineType.lineTypeEmpty  {
//                    four.append(box.top)
//                }
//                if box.left.lineType == LineType.lineTypeEmpty  {
//                    four.append(box.left)
//                }
//                if box.right.lineType == LineType.lineTypeEmpty  {
//                    four.append(box.right)
//                }
//                if box.bottom.lineType == LineType.lineTypeEmpty  {
//                    four.append(box.bottom)
//                }
//            default: break
//            }
//
//        }
//
//        var count = one.count
//        if count >= 1 {
//            let index = Int(arc4random_uniform(UInt32(count)))
//            return one[index]
//        }
//        count = four.count
//        if count >= 1 {
//            let index = Int(arc4random_uniform(UInt32(count)))
//            return four[index]
//        }
//        count = three.count
//        if count >= 1 {
//            let index = Int(arc4random_uniform(UInt32(count)))
//            return three[index]
//        }
//        count = two.count
//        if count >= 1 {
//            let index = Int(arc4random_uniform(UInt32(count)))
//            return two[index]
//        }
        return nil
    }
}
