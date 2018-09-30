//
//  ViewController.swift
//  Sudoku
//
//  Created by Tianzhi Li on 2017/10/30.
//  Copyright © 2017年 Tianzhi Li. All rights reserved.
//

import UIKit

//因为颜色的实例化需要与UI的实例化相互独立，所以单独把颜色放在外面
let lightColor = UIColor.init(red: 250/255, green: 248/255, blue: 236/255, alpha: 1)
let darkColor  = UIColor.init(red: 253/255, green: 224/255, blue: 183/255, alpha: 1)
let errorColor =  UIColor.init(red: 241/255, green: 97/255, blue: 99/255, alpha: 1)
let fillColor = UIColor.init(red: 169/255, green: 228/255, blue: 230/255, alpha: 1)
let selectedColor = UIColor.init(red: 254/255, green: 253/255, blue: 143/255, alpha: 1)
let borderColor = CGColor.init(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [122/255.0,158/255.0,176/255.0,1.0] as [CGFloat])

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.init(red: 241/255, green: 1, blue: 240/255, alpha: 1)
        initUI()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var number: String?     //current selected number
    //数独数表
    var game = [ [0,0,0,0,0,0,0,0,0] , [0,0,0,0,0,0,0,0,0] , [0,0,0,0,0,0,0,0,0] , [0,0,0,0,0,0,0,0,0] , [0,0,0,0,0,0,0,0,0] , [0,0,0,0,0,0,0,0,0] , [0,0,0,0,0,0,0,0,0] , [0,0,0,0,0,0,0,0,0] , [0,0,0,0,0,0,0,0,0] ]
    //数独颜色表
    let cellColor = [[lightColor,lightColor,lightColor,darkColor,darkColor,darkColor,lightColor,lightColor,lightColor] , [lightColor,lightColor,lightColor,darkColor,darkColor,darkColor,lightColor,lightColor,lightColor] , [lightColor,lightColor,lightColor,darkColor,darkColor,darkColor,lightColor,lightColor,lightColor] , [darkColor,darkColor,darkColor,lightColor,lightColor,lightColor,darkColor,darkColor,darkColor] , [darkColor,darkColor,darkColor,lightColor,lightColor,lightColor,darkColor,darkColor,darkColor] , [darkColor,darkColor,darkColor,lightColor,lightColor,lightColor,darkColor,darkColor,darkColor] ,  [lightColor,lightColor,lightColor,darkColor,darkColor,darkColor,lightColor,lightColor,lightColor] , [lightColor,lightColor,lightColor,darkColor,darkColor,darkColor,lightColor,lightColor,lightColor] , [lightColor,lightColor,lightColor,darkColor,darkColor,darkColor,lightColor,lightColor,lightColor]]
    
    private var sudoku = Sudoku()
    private var rowChosen = -1, colChosen = -1
    private var cellEditable = false
    private var noteFlag = false
    private var remainedCellNum = 81
    
    //UI初始化
    func initUI(){
        let frameLength =  UIScreen.main.bounds.size.width * 0.1
        let initX = ((UIScreen.main.applicationFrame.size.width) * (0.05 - 0.1))
        let initY = UIScreen.main.applicationFrame.size.height * 0.382 - UIScreen.main.applicationFrame.size.width * 0.558
        let inter2 = UIScreen.main.applicationFrame.size.width * 0.02
        var x: CGFloat
        var y: CGFloat
        x = initX
        y = initY
        //数独表的初始化
        for i in 0...8{
            if(i%3 == 0){
                y = y+frameLength
                x = initX
            } else{
                y = y+frameLength
                x = initX
            }
            for j in 0...8{
                let button:UIButton = UIButton(type:.system)
                if(j%3 == 0){
                    x = x+frameLength
                } else{
                    x = x+frameLength
                }
                button.frame = CGRect(x: x, y: y, width: frameLength, height: frameLength)
                button.titleLabel?.textAlignment = NSTextAlignment.center
                //设置按钮文字
                button.setTitle("", for:.normal)
                button.backgroundColor = cellColor[i][j]
//                print("\(i) " + "\(j) " + String(describing: cellColor[i][j]))
                button.layer.borderWidth = 2
                button.tag = i*10+j+1
                button.layer.borderColor = borderColor
                button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
                button.setTitleColor(UIColor.black, for: .normal) //普通状态下文字的颜色
                button.setTitleColor(UIColor.green, for: .highlighted) //触摸状态下文字的颜色
                button.setTitleColor(UIColor.gray, for: .disabled)
                button.addTarget(self, action:#selector(setNumber(_:)), for:.touchUpInside)
                self.view.addSubview(button)
            }
        }
        let remainYTop = UIScreen.main.applicationFrame.size.height * 0.382 + UIScreen.main.applicationFrame.size.width * 0.45
        var remainY = UIScreen.main.applicationFrame.size.height - remainYTop
        let frameLength2 =  UIScreen.main.applicationFrame.size.width * 0.124
        x = UIScreen.main.applicationFrame.size.width / 2 - frameLength2 * 3.5 - inter2 * 3
        y = remainYTop + remainY * 0.618 - inter2 / 2 - frameLength2
        //填写表的初始化
        for i in 0...4{
            x = x+frameLength2 + inter2
            let button:UIButton = UIButton(type:.system)
            button.frame = CGRect(x: x, y: y, width: frameLength2, height: frameLength2)
            button.backgroundColor = fillColor
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            button.layer.borderWidth = 2
            //设置按钮文字
            if(i == 0){
                button.setTitle("", for:.normal)
            } else{
                button.setTitle("\(i)", for:.normal)
            }
            button.setTitleColor(UIColor.black, for: .normal) //普通状态下文字的颜色
            button.setTitleColor(UIColor.green, for: .highlighted) //触摸状态下文字的颜色
            button.setTitleColor(UIColor.gray, for: .disabled)
            button.addTarget(self, action:#selector(getNumber(_:)), for:.touchUpInside)
            self.view.addSubview(button)
            //            print(y)
        }
        x = UIScreen.main.applicationFrame.size.width / 2 - frameLength2 * 3.5 - inter2 * 3
        y  = remainYTop + remainY * 0.618 + inter2 / 2
//        print(remainYTop)
//        print(y)
        for i in 5...9{
            x = x+frameLength2 + inter2
            let button:UIButton = UIButton(type:.system)
            button.frame = CGRect(x: x, y: y, width: frameLength2, height: frameLength2)
            button.backgroundColor = fillColor
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.layer.borderWidth = 2
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            //设置按钮文字
            if(i == 0){
                button.setTitle("", for:.normal)
            } else{
                button.setTitle("\(i)", for:.normal)
            }
            button.setTitleColor(UIColor.black, for: .normal) //普通状态下文字的颜色
            button.setTitleColor(UIColor.green, for: .highlighted) //触摸状态下文字的颜色
            button.setTitleColor(UIColor.gray, for: .disabled)
            button.addTarget(self, action:#selector(getNumber(_:)), for:.touchUpInside)
            self.view.addSubview(button)
        }
        
        //设置和读取按钮
        
        remainY =  remainY * 0.618 - inter2 / 2 - frameLength2
        //BUT1获得数独表的情况
        let button1:UIButton = UIButton(type:.system)
        button1.frame = CGRect(x: UIScreen.main.applicationFrame.size.width / 2 - 40, y: remainYTop + remainY * 0.191, width: 80, height: min(remainY * 0.618, 80))
        button1.setTitle("1",for:.normal)
        button1.addTarget(self, action:#selector(getSudoku(_:)), for:.touchUpInside)
        
        self.view.addSubview(button1)
        let button2:UIButton = UIButton(type:.system)
        button2.frame = CGRect(x: UIScreen.main.applicationFrame.size.width / 2 - 150, y: remainYTop + remainY * 0.191, width: 80, height: min(remainY * 0.618, 80))
        button2.setTitle("Note", for:.normal)
        button2.addTarget(self, action:#selector(changeNoteFlag(_:)), for:.touchUpInside)
        self.view.addSubview(button2)
        
        let button3:UIButton = UIButton(type:.system)
        button3.frame = CGRect(x: UIScreen.main.applicationFrame.size.width / 2 + 70, y: remainYTop + remainY * 0.191, width: 80, height: min(remainY * 0.618, 80))
        button3.setTitle("2", for:.normal)
        button3.addTarget(self, action:#selector(solveGame(_:)), for:.touchUpInside)
        self.view.addSubview(button3)
    }
    
    //按填写表的cell
    @IBAction func getNumber(_ sender: UIButton) {
        sudoku.pathStackForRedo.clear()
        if(cellEditable == true){
            number = sender.currentTitle
            let tempTag = rowChosen*10+colChosen+1
            let tempBut = self.view.viewWithTag(tempTag) as! UIButton
            let oriNumber = tempBut.currentTitle
            tempBut.backgroundColor = cellColor[rowChosen][colChosen]
            if(noteFlag == false){
                tempBut.titleLabel?.numberOfLines = 1
                tempBut.setTitle(number, for:.normal)
                if(oriNumber != ""){
                    recordPath(row:rowChosen, col:colChosen, num:Int(oriNumber!)!)
                } else{
                    recordPath(row:rowChosen, col:colChosen, num:0)
                }
                if(number != ""){
                    game[rowChosen][colChosen] = Int(number!)!
                    repaintSudoku()
                    remainedCellNum -= 1
                    print(remainedCellNum)
                    judgeError(row: rowChosen, col: colChosen, num: Int(number!)!)
                } else{
                    game[rowChosen][colChosen] = 0
                    repaintSudoku()
                    remainedCellNum += 1
                    print(remainedCellNum)
                }
                tempBut.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            } else{
                if(number == ""){
                    tempBut.setTitle("", for: .normal)
                } else{
                    tempBut.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                    tempBut.titleLabel?.numberOfLines = 2
                    var tempLabel:String = tempBut.currentTitle!
                    if(tempLabel.contains(number!)){
                        tempLabel.remove(at: tempLabel.index(of: number!.first!)!)
                    } else{
                        tempLabel.append(number!)
                    }
                    tempBut.setTitle(tempLabel, for: .normal)
                }
            }
            cellEditable = false
        }
    }
    
    //按数独的cell
    @IBAction func setNumber(_ sender: UIButton) {
        let tempRow = (sender.tag-1)/10, tempCol = (sender.tag-1)%10
        let changAble  = sudoku.getCha()
        repaintSudoku()
        if(cellEditable == true){
            let tempTag = rowChosen*10+colChosen+1
            let tempBut = self.view.viewWithTag(tempTag) as! UIButton
            tempBut.backgroundColor = cellColor[rowChosen][colChosen]
        }
        if(changAble[tempRow][tempCol] == false){
            cellEditable = false
        } else{
            cellEditable = true
            rowChosen = tempRow
            colChosen = tempCol
            if(sender.currentTitle! != ""){
                if(sender.currentTitle!.count == 1){
                    judgeError(row: tempRow, col: tempCol, num: Int(sender.currentTitle!)!)
                }
            }
            sender.backgroundColor = selectedColor
        }
    }
    
    //根据用户填写的数学表获得整个数独
    @objc func getSudoku(_ sender: Any){
        var tag: Int
        var but = UIButton()
        var temp = 0
        for i in 0...8{
            for j in 0...8{
                tag = i*10+j+1
                but = self.view.viewWithTag(tag) as! UIButton
                if(but.currentTitle != ""){
                    if(Int(but.currentTitle!)! > 0 && Int(but.currentTitle!)! <= 9){
                        temp = Int(but.currentTitle!)!
                        game[i][j] = temp
                        but.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
                    } else{
                        game[i][j] = 0
                        but.setTitle("", for:.normal)
                    }
                } else{
                    game[i][j] = 0
                }
            }
        }
        sudoku.setSheet(game: game)
    }
    
    //获得新题目，设置数独表，或重新开始
    @objc func setSudoku(_ sender: Any){
        var tag: Int
        var but = UIButton()
        repaintSudoku()
        game = sudoku.getSheet()
        let changAble  = sudoku.getCha()
        for i in 0...8{
            for j in 0...8{
                tag = i*10+j+1
                but = self.view.viewWithTag(tag) as! UIButton
                if(game[i][j] != 0){
                    remainedCellNum -= 1
                    print(remainedCellNum)
                    but.setTitle("\(game[i][j])", for:.normal)
                    if(changAble[i][j] == false){
                        but.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
                    }
                } else{
                    but.setTitle("", for:.normal )
                }
            }
        }
    }
    
    //解题
    @objc func solveGame(_ sender: Any){
        if(sudoku.solve()){
            print("YES")
            setSudoku(1)
        } else{
            print("NO RESULT")
        }
    }
    
    //记录解题步骤
    func recordPath(row:Int, col:Int, num:Int){
//        print("row: " + "\(row)" + "col: " + "\(col)" + "num: " + "\(num)")
        sudoku.pathStackForUndo.push(item: (row, col, num))
//        print("size: " + "\(sudoku.pathStackForUndo.size())")
    }
    
    //撤销
     @IBAction func undo(_ sender: Any){
        if(sudoku.pathStackForUndo.size()<=0){
            return
        }
        let tempObj = sudoku.pathStackForUndo.pop()
        let tempRow = tempObj.i, tempCol = tempObj.j, tempNum = tempObj.num
        let tempTag = tempRow*10+tempCol+1
        let tempBut = self.view.viewWithTag(tempTag) as! UIButton
        let curTitle = tempBut.currentTitle
        var curNum = -1
        if(curTitle == ""){
            curNum = 0
        } else{
            curNum = Int(curTitle!)!
        }
        sudoku.pathStackForRedo.push(item: (i: tempRow, j: tempCol, num: curNum))
        if(tempNum != 0){
            tempBut.setTitle("\(tempNum)", for: .normal)
            if(curNum == 0){
                remainedCellNum -= 1
                print(remainedCellNum)
            }
        } else{
            tempBut.setTitle("", for: .normal)
        }
    }

    //反撤销
    @IBAction func redo(_ sender: Any){
        if(sudoku.pathStackForRedo.size()<=0){
            return
        }
        let tempObj = sudoku.pathStackForRedo.pop()
        let tempRow = tempObj.i, tempCol = tempObj.j, tempNum = tempObj.num
        let tempTag = tempRow*10+tempCol+1
        let tempBut = self.view.viewWithTag(tempTag) as! UIButton
        let curTitle = tempBut.currentTitle
        var curNum = -1
        if(curTitle == ""){
            curNum = 0
        } else{
            curNum = Int(curTitle!)!
        }
        sudoku.pathStackForUndo.push(item: (i: tempRow, j: tempCol, num: curNum))
        
//        print("Redo\nrow: " + "\(tempRow)" + "col: " + "\(tempCol)" + "num: " + "\(tempNum)")
        if(tempNum != 0){
            tempBut.setTitle("\(tempNum)", for: .normal)
        } else{
            tempBut.setTitle("", for: .normal)
        }
    }

    //判断错误
    func judgeError(row: Int, col:Int, num:Int){
        let group = row/3*3+col/3
        let startRow = group/3*3, startCol = group%3*3
        var sameNum = 0
        for i in 0...8{
            if(game[row][i] == num){
                sameNum += 1
                let tempTag = row*10+i+1
                let tempBut = self.view.viewWithTag(tempTag) as! UIButton
                tempBut.backgroundColor = errorColor
            }
            if(game[i][col] == num){
                sameNum += 1
                let tempTag = i*10+col+1
                let tempBut = self.view.viewWithTag(tempTag) as! UIButton
                tempBut.backgroundColor = errorColor
            }
        }
        for i in 0...2{
            for j in 0...2{
                if(game[startRow+i][startCol+j] == num){
                    sameNum += 1
                    let tempTag = (startRow+i)*10+(startCol+j)+1
                    let tempBut = self.view.viewWithTag(tempTag) as! UIButton
                    tempBut.backgroundColor = errorColor
                }
            }
        }
        if(sameNum <= 3){
            let tempTag = row*10+col+1
            let tempBut = self.view.viewWithTag(tempTag) as! UIButton
            tempBut.backgroundColor = cellColor[row][col]
        }
    }

    //重绘数独表
    func repaintSudoku(){
        for i in 0...8{
            for j in 0...8{
                let tempTag = i*10+j+1
                let tempBut = self.view.viewWithTag(tempTag) as! UIButton
                tempBut.backgroundColor = cellColor[i][j]
            }
        }
    }
    
    ///更改note属性
    @IBAction func changeNoteFlag(_ sender: UIButton){
        noteFlag = !noteFlag
    }
}

