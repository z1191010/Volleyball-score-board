//
//  ViewController.swift
//  Volleyball scorer
//
//  Created by Kai on 2022/11/29.
//

import UIKit


class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    //左邊分數欄位
    @IBOutlet weak var ScoreA: UILabel!
    //右邊分數欄位
    @IBOutlet weak var ScoreB: UILabel!
    //左邊局數欄位
    @IBOutlet weak var RoundA: UILabel!
    //右邊局數欄位
    @IBOutlet weak var RoundB: UILabel!
    //左邊隊伍欄位
    @IBOutlet weak var NameA: UITextField!
    //右邊隊伍欄位
    @IBOutlet weak var NameB: UITextField!
    //左邊隊伍發球權
    @IBOutlet weak var leftBall: UIImageView!
    //右邊隊伍發球權
    @IBOutlet weak var rightBall: UIImageView!
    //Choose Server Button Outlet
    @IBOutlet weak var chooseButton: UIButton!
    //宣告一個 Array 用以記錄發球順序
    var history = [String]()
    
    //全部重置 (包含局數也將歸 0 ，僅用在 resetButton 及 viewDidLoad )
    func resetGame (){
        ScoreA.text = "0"
        ScoreB.text = "0"
        RoundA.text = "0"
        RoundB.text = "0"
        NameA.text = "Team A"
        NameB.text = "Team B"
        history.removeAll()
        //因 chooseButton 點選完後會消失，因此在 reset 中要再讓 button 顯示出來
        chooseButton.isHidden = false
        leftBall.isHidden = true
        rightBall.isHidden = true
    }
    //新的一局（不重置局數，獲勝的局數會延續計算）
    func newGame() {
        ScoreA.text = "0"
        ScoreB.text = "0"
        NameA.text = NameA.self.text
        NameB.text = NameB.self.text
        history.removeAll()
        //因 chooseButton 點選完後會消失，因此在 reset 中要再讓 button 顯示出來
        chooseButton.isHidden = false
        leftBall.isHidden = true
        rightBall.isHidden = true
    }
    //變更球權圖示提醒的 function，用於 changeSide 中。
    func changeServer() {
        if leftBall.isHidden == false {
            leftBall.isHidden = true
            rightBall.isHidden = false
        }
        else if rightBall.isHidden == false {
            leftBall.isHidden = false
            rightBall.isHidden = true
        }
    }
    //變更 History Array 中球權順序的 function，用於 changeSide 中。
    func changeHistory() {
        for i in history.indices {
            if history[i] == "A" {
                history[i] = "B"
            }
            else if history[i] == "B" {
                history[i] = "A"
            }
        }
    }
    //將隊伍名字、局數、分數、發球順序、發球權 換邊
    func changeSide() {
        let name = NameA.text
        NameA.text = NameB.text
        NameB.text = name
        
        let score = ScoreA.text
        ScoreA.text = ScoreB.text
        ScoreB.text = score
        
        let round = RoundA.text
        RoundA.text = RoundB.text
        RoundB.text = round
        changeHistory()
        changeServer()
    }
    //彈出獲勝視窗並提醒交換場地
    func scoreAlert() {
        let controller = UIAlertController(title: "恭喜獲得單局勝利！", message: "請雙方互換場地。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "繼續", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true)
        //跳出視窗後運行 newGame function 開新局 (局數不會重置)
        newGame()
    }
    //彈出三戰兩勝獲勝晉級視窗
    func roundAlert() {
        let controller = UIAlertController(title: "恭喜取得晉級資格。", message: "🏆🏆🏆🏆🏆🏆", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "重新開始", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true)
        //跳出三戰兩勝獲勝視窗後，運行 resetGame function 重置所有資料
        resetGame()
    }
    //檢查 TeamA round 是否有達到三戰兩勝的賽末點
    func checkRoundForTeamA() {
        //宣告2個常數將 String 轉為 Int 以利比較判斷
        let introundA = Int(RoundA.text!) ?? 0
        let introundB = Int(RoundB.text!) ?? 0
        //一般來說排球賽制以三戰二勝為主，因此當 TeamA 局數等於 0 且 TeamB 局數小於 2 時，TeamA 局數 +1 且 changeSide 並 執行 newGame
        if introundA == 0 && introundB < 2 {
            scoreAlert()
            let leftRound = Int(RoundA.text!) ?? 0
            let roundA = leftRound + 1
            RoundA.text = String(roundA)
            changeSide()
        //當 TeamA 局數等於 1 時，局數再 +1 便以三戰二勝勝出晉級，因此會跳出 roundAlert 視窗並執行 resetGame
        } else if introundA == 1 && introundB < 2 {
            let leftRound = Int(RoundA.text!) ?? 0
            let roundA = leftRound + 1
            RoundA.text = String(roundA)
            roundAlert()
        }
    }
    //檢查 TeamB round 是否有達到三戰兩勝的賽末點
    func checkRoundForTeamB() {
        //宣告2個常數將 String 轉為 Int 以利比較判斷
        let introundA = Int(RoundA.text!) ?? 0
        let introundB = Int(RoundB.text!) ?? 0
        //一般來說排球賽制以三戰二勝為主，因此當 TeamB 局數等於 0 且 TeamA 局數小於 2 時，TeamB 局數 +1 且 changeSide 並 執行 newGame
        if introundB == 0 && introundA < 2 {
            scoreAlert()
            let rightRound = Int(RoundB.text!) ?? 0
            let roundB = rightRound + 1
            RoundB.text = String(roundB)
            changeSide()
        //當 TeamB 局數等於 1 時，局數再 +1 便以三戰二勝勝出晉級，因此會跳出 roundAlert 視窗並執行 resetGame
        } else if introundB == 1 && introundA < 2 {
            let rightRound = Int(RoundB.text!) ?? 0
            let roundB = rightRound + 1
            RoundB.text = String(roundB)
            roundAlert()
        }
    }
    
    //檢查單局是否獲勝
    func checkWin() {
        //宣告2個常數將 String 轉為 Int 以利比較判斷
        let intscoreA = Int(ScoreA.text!) ?? 0
        let intscoreB = Int(ScoreB.text!) ?? 0
        //判斷 Team A 是否獲勝，依照排球規則先取得 25 分為且領先對手 2 分時獲勝
        if intscoreA == 25 && intscoreB <= 23 {
            checkRoundForTeamA()
        }
        //判斷 Team A 在 Duce（分數在 24 : 24 ） 的情況下需連得兩分才可獲勝，當 TeamA 分數減 2 等於 TeamB 分數時，即為 A 隊獲勝
        else if intscoreA > 25 && intscoreA - 2 == intscoreB{
            checkRoundForTeamA()
        }
        //判斷 Team B 在 Duce（分數在 24 : 24 ） 的情況下需連得兩分才可獲勝，當 TeamB 分數減 2 等於 TeamA 分數時，即為 B 隊獲勝
        else if intscoreB == 25 && intscoreA <= 23 {
            checkRoundForTeamB()
        }
        //判斷 Team B 在 Duce 的情況下需連得兩分才可獲勝
        else if intscoreB > 25 && intscoreB - 2 == intscoreA{
            checkRoundForTeamB()
        }
    }
    //建立使用資訊的 function，用於 info button，點選 button 後會跳 Alert 視窗供使用者參閱訊息
    func info() {
        let controller = UIAlertController(title: "Infomation", message: "\n點選 Team A 及 Team B 可輸入變更隊名\n\n請先點選 Choose Server 選擇發球方\n\nChange Side：兩隊資訊互換\n\nReduce Score：回上一動\n\nReset：重置所有隊伍名稱、分數、局數", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "我瞭解了", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true)
    }
    
    // viewDidLoad 中進行重置資料、隱藏兩邊的球權圖示提醒
    override func viewDidLoad() {
        resetGame()
        leftBall.isHidden = true
        rightBall.isHidden = true
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // ChangeSideButton 直接套用前面定義的 function。
    @IBAction func ChangeSide(_ sender: Any) {
        changeSide()
    }
    
    // 預設左邊隊伍增加分數，同時每點一下都會執行 checkwin 的 function 判斷是否獲勝
    @IBAction func addScoreA (_ sender: Any) {
        let leftScore = Int(ScoreA.text!) ?? 0
        let scoreA = leftScore + 1
        ScoreA.text = String(scoreA)
        leftBall.isHidden = false
        rightBall.isHidden = true
        checkWin()
        //同時每點一下 History Array 都會記錄一筆 String 為 "A" 的資料，以作為後續球權變更的依據
        history.append("A")
        //這邊取出 Array 值僅是要確認球權是否有正確轉移
        print(history)
    }
    
    // 預設右邊隊伍增加分數，同時每點一下都會執行 checkwin 的 function 判斷是否獲勝。
    @IBAction func addScoreB(_ sender: Any) {
        let rightScore = Int(ScoreB.text!) ?? 0
        let scoreB = rightScore + 1
        ScoreB.text = String(scoreB)
        leftBall.isHidden = true
        rightBall.isHidden = false
        checkWin()
        //同時每點一下 History Array 都會記錄一筆 String 為 "B" 的資料，以作為後續球權變更的依據
        history.append("B")
        //這邊取出 Array 值僅是要確認球權是否有正確轉移
        print(history)
    }
    
    // 點空白處收鍵盤。
    @IBAction func finishTyping(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // ResetButton 直接套用前面定義的 function。
    @IBAction func reset(_ sender: Any) {
        resetGame()
    }
    
    //開場時選擇球權的 button （儘管使用者懶惰不選，開始加分後還是會跳出球權顯示）
    @IBAction func chooseServer(_ sender: Any) {
        let nameA = String(NameA.text!)
        let nameB = String(NameB.text!)
        //以 actionSheet 的方式呈現
        let controller = UIAlertController(title: "請選擇發球方", message: "", preferredStyle: .actionSheet)
        //由 TeamA 優先發球的選項內容
        let leftServerAction = UIAlertAction(title: "由 \(nameA) 先發球", style: .default) { _ in
            //不隱藏 TeamA 的球權圖示提醒
            self.leftBall.isHidden = false
            //隱藏 TeamB 的球權圖示提醒
            self.rightBall.isHidden = true
            //此按鈕一場只會使用一次，因此選取完後讓此 button 隱藏
            self.chooseButton.isHidden = true
        }
        //新增 TeamA 優先發球的選項至 actionSheet 上
        controller.addAction(leftServerAction)
        //由 TeamB 優先發球的選項內容
        let rightServerAction = UIAlertAction(title: "由 \(nameB) 先發球", style: .default) { _ in
            //隱藏 TeamA 的球權圖示提醒
            self.leftBall.isHidden = true
            //隱藏 TeamB 的球權圖示提醒
            self.rightBall.isHidden = false
            //此按鈕一場只會使用一次，因此選取完後讓此 button 隱藏
            self.chooseButton.isHidden = true
        }
        //新增 TeamB 優先發球的選項至 actionSheet 上
        controller.addAction(rightServerAction)
        present(controller, animated: true)
        
    }
    //回復到上一動作的 button
    @IBAction func reduce(_ sender: Any) {
        //宣告2個變數將 String 轉為 Int 以利比較判斷
        var leftScore = Int(ScoreA.text!) ?? 0
        var rightScore = Int(ScoreB.text!) ?? 0
        //球權 Array 最後一筆資料若為 "A" 則代表 TeamA 剛加分，因此獲得球權
        if history.last == "A" && leftScore > 0 {
            //因此要將 TeamA 分數減 1
            leftScore = leftScore - 1
            ScoreA.text = String(leftScore)
            //同時要將 Array 最後一筆資料移除
            history.removeLast()
            //這邊取出 Array 值僅是要確認球權是否有正確移除
            print(history)
            //除了考慮到 Array 外還要將球權圖示提醒同步變換
            if  history.last == "A"{
                leftBall.isHidden = false
                rightBall.isHidden = true
            }
            else if history.last == "B" {
                leftBall.isHidden = true
                rightBall.isHidden = false
            }
        //球權 Array 最後一筆資料若為 "B" 則代表 TeamB 剛加分，因此獲得球權
        } else if history.last == "B" && rightScore > 0 {
            //因此要將 TeamB 分數減 1
            rightScore = rightScore - 1
            ScoreB.text = String(rightScore)
            //同時要將 Array 最後一筆資料移除
            history.removeLast()
            //這邊取出 Array 值僅是要確認球權是否有正確移除
            print(history)
            //除了考慮到 Array 外還要將球權圖示提醒同步變換
            if history.last == "A" {
                print(history)
                leftBall.isHidden = false
                rightBall.isHidden = true
            }
            else if history.last == "B" {
                leftBall.isHidden = true
                rightBall.isHidden = false
            }
        }
    }
    // info button 套用 info function
    @IBAction func info(_ sender: Any) {
        info()
    }
//
//    @IBAction func backgroundcolor(_ sender: Any) {
//        let controllor = UIColorPickerViewController()
//        controllor.delegate = self
//        present(controllor, animated: true)
//    }
//        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
//            view.backgroundColor = color
//        }
}

