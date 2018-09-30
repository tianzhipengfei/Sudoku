//
//  Sudoku.swift
//  Sudoku
//
//  Created by Tianzhi Li on 2017/10/30.
//  Copyright © 2017年 Tianzhi Li. All rights reserved.
//

import Foundation
struct Stack<T> {
    var items = [T]()
    mutating func push(item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        if(items.count>=0){
            return items.removeLast()
        } else{
            return (-1,-1,-1) as! T
        }
    }
    func isEmpty() -> Bool {
        return items.isEmpty
    }
    mutating func clear(){
        items.removeAll()
    }
    func size() -> Int{
        return items.count
    }
}

struct Sudoku{
    public var pathStackForUndo = Stack<(i:Int, j:Int, num:Int)>()
    public var pathStackForRedo = Stack<(i:Int, j:Int, num:Int)>()
    private var sheet = [ [0,4,8,0,0,1,5,7,0,0] , [1,2,0,8,0,0,0,0,0,0] , [6,0,0,9,0,2,0,0,1,0] , [3,7,0,0,0,0,2,8,5,0] , [0,0,0,0,0,0,0,0,4,0] , [4,0,0,2,8,0,3,6,0,0] , [0,3,1,6,0,0,0,0,8,0] , [0,0,6,0,2,8,0,0,0,0] , [0,0,0,0,9,0,7,0,6,0] ,[0,0,0,0,0,0,0,0,0,0] ]
    private var ans = [[0,0,0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0,0,0]]
    private var cols = [ [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] ]
    private var rows = [ [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] ]
    private var blocks = [ [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] , [false,false,false,false,false,false,false,false,false] ]
    //用户定义数独后判断cell是否可继续更改
    private var changable = [ [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true]  ]
    private var remainCellNum = 81
    private var ansNum = 0
    private var complete : Bool  = false
    
    public mutating func getSheet() -> [[Int]]{
        setProperty()
        return sheet
    }
    
    public func gerRow()-> [[Bool]]{
        return rows
    }
    
    public func gerCol()-> [[Bool]]{
        return cols
    }
    
    public func gerBlo()-> [[Bool]]{
        return blocks
    }
    
    public func getCha()-> [[Bool]]{
        return changable
    }
    
    public mutating func setSheet(game: [[Int]]){
        for i in 0...8{
            for j in 0...8{
                sheet[i][j] = game[i][j]
            }
        }
        setProperty()
    }
    
//    public func judgeSudoku(i: Int, j: Int, num: Int) -> (judType: Int, judRow: Int, judCol: Int, judBlo: Int) {
//
//
//    }
    
    //更改可否改变属性、
    private mutating func setProperty(){
        changable = [ [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true] , [true,true,true,true,true,true,true,true,true]  ]
        remainCellNum = 81
        ansNum = 0
        complete = false
        for i in 0...8 {
            for j in 0...8 {
                if (sheet[i][j] != 0) {
                    let k = i / 3 * 3 + j / 3// 划分九宫格,这里以行优先，自己也可以列优先
                    let val = sheet[i][j] - 1
                    rows[i][val] = true
                    cols[j][val] = true
                    blocks[k][val] = true
                    changable[i][j] = false
                    remainCellNum -= 1
                }
            }
        }
    }
    
    public mutating func solve() -> Bool{
        setProperty()
        ans = sheet
        if(DFS()){
            if(ansNum == 1){
                return true
            } else{
                return false
            }
        }
        return false
    }
    
    public mutating func DFS ( ) -> Bool{
        for i in 0...8 {
            for j in 0...8 {
                if (ans[i][j] == 0) {
                    let k = i / 3 * 3 + j / 3;
                    for l in 0...8 {
                        if (!cols[j][l] && !rows[i][l] && !blocks[k][l]) {// l对于的数字l+1没有在行列块中出现
                            rows[i][l] = true
                            cols[j][l] = true
                            blocks[k][l] = true
                            ans[i][j] = 1 + l// 下标加1
                            if (DFS()){
                                return true// 递进则返回true
                            }
                            rows[i][l] = false
                            cols[j][l] = false
                            blocks[k][l] = false// 递进失败则回溯
                            ans[i][j] = 0
                        }
                    }
                    return false// a[i][j]==0时，l发现都不能填进去
                }// the end of a[i][j]==0
            }
        }
        return true// 没有a[i][j]==0,则返回true
    }
}
