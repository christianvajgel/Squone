//
//  GameView.swift
//  TestSO
//
//  Created by chris on 03/08/21.
//

import UIKit
import AVFoundation

class GameView: UIView {
    
    var timer = Timer()
    var logo: UIImage!
    var logoImageView: UIImageView!
    var buttonRefresh: UIButton!
    
    var board: [[String]]
    
    var dotArray: Array<Dot>
    var lineArray: Array<Line>
    var boxArray: Array<Box>
    var currentLine: Line!
    var lineLayer = CAShapeLayer()
    var counter = 0
    
    static var player_counter = 0
    static var computer_counter = 0
    
    var scorePlayer: UILabel = UILabel(frame: CGRect(x: 120.00, y: 120.00, width: 250.00, height: 60.00))
    static var scorePlayerCounter: UILabel = UILabel(frame: CGRect(x: 120.00, y: 120.00, width: 250.00, height: 60.00))
    
    var scoreComputer: UILabel = UILabel(frame: CGRect(x: 120.00, y: 120.00, width: 250.00, height: 60.00))
    static var scoreComputerCounter: UILabel = UILabel(frame: CGRect(x: 120.00, y: 120.00, width: 250.00, height: 60.00))
    
    var dotColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
    
    var computerBoxColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 0.75)
    var computerLineColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
    var computerAnimationLineColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
    
    var playerBoxColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.70)
    var playerLineColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.70)
    
    let lightThemeBackground = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    let darkThemeBackground = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
    
    override init(frame: CGRect) {
        
        self.board = []
        
        // Initializing arrays
        self.dotArray = Array<Dot>()
        self.lineArray = Array<Line>()
        self.boxArray = Array<Box>()
        super.init(frame: frame)
        
        
        // getting device (frame) width and height in pixels
        let deviceWidth = frame.size.width
        
        // setting dotColor according with the actual theme
        dotColor = traitCollection.userInterfaceStyle == .light ? UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1) : UIColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
        
        
        // MARK: Logo Image View
        
        let logoWidth = CGFloat(125.00)
        let logoHeight = CGFloat(125.00)
        
        let screenPercentHorizontalLogo = CGFloat(0.400700934579)
        
        let logoPositionHorizontal = CGFloat(deviceWidth - (deviceWidth - (deviceWidth * screenPercentHorizontalLogo)))
        let logoPositionVertical = CGFloat(50.00)
        
        logo = traitCollection.userInterfaceStyle == .light ? UIImage(named: "squone_light_theme.png") : UIImage(named: "squone_dark_theme.png")
        logoImageView = UIImageView(frame: CGRect(x: logoPositionHorizontal, y: logoPositionVertical, width: logoWidth, height: logoHeight))
        logoImageView.contentMode = UIView.ContentMode.scaleAspectFit
        logoImageView.image = logo
        
        self.addSubview(logoImageView)
        
        
        // MARK: Label Player
        
        let screenPercentHorizontalScorePlayer = CGFloat(0.848130841121)
        
        let scorePlayerPositionHorizontal = CGFloat(deviceWidth - (deviceWidth * screenPercentHorizontalScorePlayer))
        let scorePlayerPositionVertical = CGFloat(logoImageView.frame.maxY + 10)
        
        scorePlayer = UILabel(frame: CGRect(x: scorePlayerPositionHorizontal, y: scorePlayerPositionVertical, width: 250.00, height: 60.00))
        self.addSubview(scorePlayer)
        
        scorePlayer.text = "player"
        scorePlayer.textColor = traitCollection.userInterfaceStyle == .light ? UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.70) : UIColor(red: 86/255, green: 86/255, blue: 86/255, alpha: 1.0)
        scorePlayer.font = UIFont(name: "Poppins-Light", size: 22)
        
        
        // MARK: Label Player Counter
        
        let screenPercentHorizontalScorePlayerCounter = CGFloat(0.789719626168)
        
        let scorePlayerCounterPositionHorizontal = CGFloat(deviceWidth - (deviceWidth * screenPercentHorizontalScorePlayerCounter))
        let scorePlayerCounterPositionVertical = CGFloat(logoImageView.frame.maxY + 45)
        
        GameView.scorePlayerCounter = UILabel(frame: CGRect(x: scorePlayerCounterPositionHorizontal, y: scorePlayerCounterPositionVertical, width: 250.00, height: 60.00))
        self.addSubview(GameView.scorePlayerCounter)
        
        GameView.scorePlayerCounter.text = "\(GameView.player_counter)"
        GameView.scorePlayerCounter.textColor = traitCollection.userInterfaceStyle == .light ? UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.70) : UIColor(red: 86/255, green: 86/255, blue: 86/255, alpha: 1.0)
        GameView.scorePlayerCounter.font = UIFont(name: "Poppins-Light", size: 22)
        
        
        // MARK: Button Refresh
        
        let screenPercentHorizontalButtonRefresh = CGFloat(0.380841121495)
        
        let buttonRefreshPositionHorizontal = CGFloat(deviceWidth - (deviceWidth - (deviceWidth * screenPercentHorizontalButtonRefresh)))
        let buttonRefreshPositionVertical = CGFloat(logoImageView.frame.maxY + 30)
        
        buttonRefresh = UIButton(frame: CGRect(x: buttonRefreshPositionHorizontal, y: buttonRefreshPositionVertical, width: 100, height: 50))
        buttonRefresh.backgroundColor = .clear
        buttonRefresh.setImage(UIImage(systemName: "arrow.clockwise"),for: .normal)
        buttonRefresh.tintColor = dotColor
        
        buttonRefresh.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.addSubview(buttonRefresh)
        
        
        // MARK: Label Robot
        
        let screenPercentHorizontalScoreComputer = CGFloat(0.292056074766)
        
        let scoreComputerPositionHorizontal = CGFloat(deviceWidth - (deviceWidth * screenPercentHorizontalScoreComputer))
        let scoreComputerPositionVertical = CGFloat(logoImageView.frame.maxY + 10)
        
        scoreComputer = UILabel(frame: CGRect(x: scoreComputerPositionHorizontal, y: scoreComputerPositionVertical, width: 250.00, height: 60.00))
        self.addSubview(scoreComputer)
        
        scoreComputer.text = "robot"
        scoreComputer.textColor = traitCollection.userInterfaceStyle == .light ? UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 0.75) : UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1.0)
        scoreComputer.font = UIFont(name: "Poppins-Light", size: 22)
        
        
        // MARK: Label Robot Counter
        
        let screenPercentHorizontalScoreComputerCounter = CGFloat(0.239485981308)
        
        let scoreComputerCounterPositionHorizontal = CGFloat(deviceWidth - (deviceWidth * screenPercentHorizontalScoreComputerCounter))
        let scoreComputerCounterPositionVertical = CGFloat(logoImageView.frame.maxY + 45)
        
        GameView.scoreComputerCounter = UILabel(frame: CGRect(x: scoreComputerCounterPositionHorizontal, y: scoreComputerCounterPositionVertical, width: 250.00, height: 60.00))
        self.addSubview(GameView.scoreComputerCounter)
        
        GameView.scoreComputerCounter.text = "\(GameView.computer_counter)"
        GameView.scoreComputerCounter.textColor = traitCollection.userInterfaceStyle == .light ? UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 0.75) : UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1.0)
        GameView.scoreComputerCounter.font = UIFont(name: "Poppins-Light", size: 22)
        
        
        // setting background and game variables
        self.backgroundColor = traitCollection.userInterfaceStyle == .light ? lightThemeBackground : darkThemeBackground
        let xCount = 4
        let yCount = 4
        let size = (frame.size.width - 80) / CGFloat(xCount - 1)
        
        // MARK: Vertical position of board
        // defined by 'y'
        
        var y = Int(GameView.scorePlayerCounter.frame.maxY) + 50
        
        // building board
        for i in 0  ..< xCount {
            var x = 40
            
            for j in 0  ..< yCount {
                
                let dot = Dot()
                dot.location = CGPoint(x: CGFloat(x), y: CGFloat(y))
                dot.point = CGPoint(x: CGFloat(j), y: CGFloat(i))
                self.dotArray.append(dot)
                x += Int(size)
            }
            y += Int(size)
            
        }
        
        // creating lines
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
        
        // creating boxes
        for i in 0  ..< xCount {
            for j in 0  ..< yCount {
                
                if i < (xCount - 1) && j < (yCount - 1) {
                    self.createBoxFrom(CGPoint(x: CGFloat(i), y: CGFloat(j)))
                }
            }
        }
        
        // setting animation for the lines
        // this lines are about line animations
        self.lineLayer = CAShapeLayer(layer: layer)
        self.lineLayer.backgroundColor = UIColor.clear.cgColor
        self.lineLayer.strokeColor = computerAnimationLineColor.cgColor
        self.lineLayer.lineWidth = 8
        self.lineLayer.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.addSublayer(self.lineLayer)
        self.newGame()
        
        // MARK: Timer to start the watcher for theme switch
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.checkForDisplayedTheme()
        })
    }
    
    // MARK: Check and set Color Pallete
    func checkForDisplayedTheme() {
        
        if traitCollection.userInterfaceStyle == .light {
            
            self.backgroundColor = lightThemeBackground
            
            logo = UIImage(named: "squone_light_theme.png")
            logoImageView.image = logo
            
            playerBoxColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.70)
            playerLineColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.70)
            
            scorePlayer.textColor = playerBoxColor
            GameView.scorePlayerCounter.textColor = playerBoxColor
            
            computerBoxColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 0.75)
            computerLineColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
            
            scoreComputer.textColor = computerBoxColor
            GameView.scoreComputerCounter.textColor = computerBoxColor
            
            dotColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
            
            buttonRefresh.tintColor = dotColor
            
        }
        
        else {
            
            self.backgroundColor = darkThemeBackground
            
            logo = UIImage(named: "squone_dark_theme.png")
            logoImageView.image = logo
            
            playerBoxColor = UIColor(red: 86/255, green: 86/255, blue: 86/255, alpha: 1.0)
            playerLineColor = UIColor(red: 56/255, green: 56/255, blue: 56/255, alpha: 1.0)
            
            scorePlayer.textColor = playerBoxColor
            GameView.scorePlayerCounter.textColor = playerBoxColor
            
            computerBoxColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1.0)
            computerLineColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
            
            scoreComputer.textColor = computerBoxColor
            GameView.scoreComputerCounter.textColor = computerBoxColor
            
            dotColor = UIColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
            
            buttonRefresh.tintColor = dotColor
        }
    }
    
    // MARK: Refresh icon on-click response
    @objc func buttonAction(sender: UIButton!) {
        newGame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateLine(_ line: Line) {
        let fromPath = UIBezierPath()
        fromPath.move(to: line.endpoint2.location)
        fromPath.addLine(to: line.endpoint1.location)
        
        let toPath = UIBezierPath()
        toPath.move(to: line.endpoint2.location)
        toPath.addLine(to: line.endpoint2.location)
        let pathAnim = CABasicAnimation(keyPath: "path")
        pathAnim.fromValue = fromPath.cgPath
        pathAnim.toValue = toPath.cgPath
        // MARK: Line animation duration
        pathAnim.duration = 0.75 // 0.5
        self.lineLayer.add(pathAnim, forKey: "pathAnimation")
        // MARK: Line animation width
        self.lineLayer.lineWidth = 6
        self.lineLayer.setNeedsDisplay()
    }
    
    // MARK: Check game over and alert funny messages
    @objc func checkGameOver() {
        if self.gameOver() {
            
            if self.player1Won() {
                
                let funnyTitles = ["Parabéns! 👏🏻",
                                   "Sexxxxxxtou! 🍾",
                                   "1. Vencer um robô corretamente 🏆",
                                   "Só tiro pro alto! 🔫"]
                
                let funnyMessages = ["Você venceu do robô por \(GameView.player_counter) a \(GameView.computer_counter)!",
                                     "Ou pelo menos voce ganhou alguma coisa hoje...",
                                     "O(a) aluno(a) venceu 'corretamente' um robô que não consegue levantar um copo d'água e só joga em quatro posições diferentes?",
                                     "Venceu pela terceira vez?"]
                
                let funnyButtons = ["Postar no LinkedIn 📱",
                                    "É a vida né... é o que tem 👌🏻",
                                    "Demonstrou o item de rubrica ✅",
                                    "Pedir música no Fantástico 🎼"]
                
                let random = Int.random(in: 0 ..< funnyMessages.count)
                
                let alert = UIAlertController(title: funnyTitles[random],
                                              message: funnyMessages[random],
                                              preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title:funnyButtons[random],
                                              style:UIAlertAction.Style.default,handler: nil))
                
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                
                self.newGame()
                
            } else {
                
                let difference = GameView.computer_counter - GameView.player_counter
                
                let square = difference > 1 ? "squares" : "square"
                
                let funnyTitles = ["Hasta la vista, baby! 🔫",
                                   "You shall not pass! 🧙🏻‍♂️",
                                   "I am Megatron! 🦾",
                                   "Red pill or blue pill? 💊"]
                
                let funnyMessages = ["You lost for a difference of \(difference) \(square) for Terminator! But don't get upset, robots can't even easily lift a beer.\nCheers for you! 🍺",
                                     "Yeah we all know this is from Lord of Rings and Gandalf isn't a robot. Whatever... you still lost with a difference of \(difference) \(square) for a robot with four simple rules! Here is a ring to make you feel better! 💍",
                                     "Congratulations Intern for unfreezing Megatron!\nGreat job on loosing for a difference of \(difference) \(square)!\nHold this cube for me and Sam get to the building! 🧊",
                                     "Neither one! You deserve the pill of shame for losing with a difference of \(difference) \(square)! Come on Neo... flying and dodging of bullets aren't cool as beat The Matrix here.\nGrab this new suit and try again. 🥼"]
                
                let funnyButtons = ["Let's drink, ops... play again!",
                                    "Tell Frodo you got the ring and try again!",
                                    "Call Optimus Prime and come on, Decepticon punk!",
                                    "Get Trinity, resurrect and try for the fourth time!"]
                
                let random = Int.random(in: 0 ..< funnyMessages.count)
                
                let alert = UIAlertController(title: funnyTitles[random],
                                              message: funnyMessages[random],
                                              preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title:funnyButtons[random],
                                              style:UIAlertAction.Style.destructive,handler: nil))
                
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                
                self.newGame()
                
            }
        }
    }
    
    // response for player tap
    func tapAtPoint(_ point:CGPoint) {
        let line = self.currentLine
        if line != nil && line!.lineType == LineType.lineTypeEmpty {
            line?.lineType = LineType.lineTypePlayer1
            var completed = false
            if self.checkAndSetBoxComplete(line!, playerType: PlayerType.playerType1) {
                completed = true
                self.checkGameOver()
            }
            if !completed {
                self.computerPlay()
            }
        }
    }
    
    func findDot(_ point: CGPoint) -> Dot? {
        for dot in self.dotArray {
            if dot.point.equalTo(point) {
                return dot
            }
        }
        return nil
    }
    
    func findLine(_ p1: CGPoint, To p2: CGPoint) -> Line? {
        for line in self.lineArray {
            if p1.equalTo(line.endpoint1.point) && p2.equalTo(line.endpoint2.point) {
                return line
            }
        }
        return nil
    }
    
    func findLineAtLocation(_ point: CGPoint) -> Line? {
        for line in self.lineArray {
            let rect = line.getTouchRect()
            if rect.contains(point) {
                return line
            }
        }
        return nil
    }
    
    func createLineFrom(_ p1: CGPoint, To p2: CGPoint) {
        let line = Line(WithEndpoint1: self.findDot(p1)!, endpoint2: self.findDot(p2)!)
        self.lineArray.append(line)
    }
    
    func createBoxFrom(_ point: CGPoint) {
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
        
        // MARK: Box counter add
        self.counter = self.counter + 1
    }
    
    func checkAndSetBoxComplete(_ line: Line, playerType type: PlayerType) -> Bool {
        var completeCount = 0
        for box in boxArray {
            if box.boxType == BoxType.boxTypeEmpty && box.boxContainsLine(line) {
                box.checkAndSetTypeOfCompletedBox(type)
                if box.boxType != BoxType.boxTypeEmpty {
                    completeCount += 1
                }
            }
        }
        GameView.scorePlayerCounter.text = "\(GameView.player_counter)"
        GameView.scoreComputerCounter.text = "\(GameView.computer_counter)"
        
        return completeCount > 0
    }
    
    func gameOver() -> Bool {
        for box in self.boxArray {
            if box.boxType == BoxType.boxTypeEmpty {
                return false
            }
        }
        return true
    }
    
    func player1Won() -> Bool {
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
        
        GameView.scorePlayerCounter.text = "\(GameView.player_counter)"
        GameView.scoreComputerCounter.text = "\(GameView.computer_counter)"
        
        self.setNeedsDisplay()
        
        updateBoard()
    }
    
    // when player touch starts
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        let location = t!.location(in: self)
        let line = findLineAtLocation(location)
        if line != nil {
            self.currentLine = line
        }
    }
    
    // when player touches end
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        let point = t!.location(in: self)
        self.tapAtPoint(point)
        self.currentLine = nil
        self.setNeedsDisplay()
    }
    
    func strokeDot(_ dot: Dot) {
        let dotColor = self.dotColor
        dotColor.setFill()
        UIColor.darkGray.setStroke()
        let bp = UIBezierPath()
        // MARK: Dot radius drawed
        bp.lineWidth = 0 // 2
        bp.lineCapStyle = CGLineCap.square
        bp.addArc(withCenter: dot.location, radius: 5, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        bp.fill()
        bp.addArc(withCenter: dot.location, radius: 6, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        bp.stroke()
    }
    
    func strokeLine(_ line: Line) {
        let bp = UIBezierPath()
        // MARK: Line Width Drawed
        bp.lineWidth = 6 // 8
        bp.lineCapStyle = CGLineCap.round
        bp.move(to: line.endpoint1.location)
        bp.addLine(to: line.endpoint2.location)
        bp.stroke()
    }
    
    func strokeBox(_ box: Box) {
        let bp = UIBezierPath()
        bp.move(to: box.top.endpoint1.location)
        bp.addLine(to: box.top.endpoint2.location)
        bp.addLine(to: box.right.endpoint2.location)
        bp.addLine(to: box.left.endpoint2.location)
        bp.addLine(to: box.left.endpoint1.location)
        bp.fill()
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        for dot in self.dotArray {
            self.strokeDot(dot)
        }
        
        for box in self.boxArray {
            if box.boxType == BoxType.boxTypePlayer1 {
                let boxColor1 = playerBoxColor
                boxColor1.setFill()
                self.strokeBox(box)
            } else if box.boxType == BoxType.boxTypePlayer2 {
                let boxColor2 = computerBoxColor
                boxColor2.setFill()
                self.strokeBox(box)
            }
        }
        
        for line in self.lineArray {
            if line.lineType == LineType.lineTypePlayer1 {
                let lineColor1 = playerLineColor
                lineColor1.setStroke()
                self.strokeLine(line)
            } else if line.lineType == LineType.lineTypePlayer2 {
                let lineColor2 = computerLineColor
                lineColor2.setStroke()
                self.strokeLine(line)
            }
        }
        
        let currentLineColor = UIColor.clear
        currentLineColor.setStroke()
        if self.currentLine != nil {
            self.strokeLine(self.currentLine)
        }
        
        // MARK: Calling updateBoard
        updateBoard()
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
        for box in boxArray {
            if box.id == id {
                return box
            }
        }
        return nil
    }
    
    func getEmptyLineFromBox(_ id: String) -> [Line?] {
        
        let board = self.board
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
        
        if !four.isEmpty {
            id = four[Int.random(in: 0..<four.count)][0]
        }
        
        else if !one.isEmpty {
            let box = Int.random(in: 0 ..< one.count)
            id = one[box][0]
            
        }
        
        else if !two.isEmpty {
            let box = Int.random(in: 0 ..< two.count)
            id = two[box][0]
        }
        
        else if !three.isEmpty {
            id = three[0][0]
            
        }
        
        if four.isEmpty && two.isEmpty && one.isEmpty && three.isEmpty {
            return nil
        }
        
        let lines = getEmptyLineFromBox(id)
        
        let line_id = Int.random(in: 0 ..< lines.count)
        
        let line = lines[line_id]
        
        return line
    }
}
