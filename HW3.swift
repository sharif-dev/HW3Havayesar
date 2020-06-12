import Foundation
import Glibc
 



class Node{
    var isFinished: Bool = false
    var childs = [Node?]()

    init(){
        for _ in 1...26{
            childs.append(nil)
        }
        
    }
    
}    


    


func trieInsert(node: Node, str: String, index: Int){
    if index == str.count{
        node.isFinished = true
        return;
    }
    let e: Int = Int(charToIndex(char: str[str.index(str.startIndex, offsetBy: index)]))
    if node.childs[e] == nil{
        node.childs[e] = Node()
    }
    trieInsert(node: node.childs[e]!, str: str, index: index+1)
}


func trieSearch(node: Node, str: String, index: Int) -> Bool{
    if index == str.count{
        return node.isFinished
    }
    let e: Int = Int(charToIndex(char: str[str.index(str.startIndex, offsetBy: index)]))
    if node.childs[e] == nil{
        return false
    }
    return trieSearch(node: node.childs[e]!, str: str, index: index+1)
}

func trieDelete(node: Node, str: String, index: Int){
    if index == str.count{
        node.isFinished = false
        return;
    }
    let e: Int = Int(charToIndex(char: str[str.index(str.startIndex, offsetBy: index)]))
    if node.childs[e] == nil{
        return;
    }
    trieDelete(node: node.childs[e]!, str: str, index: index + 1)
}

func charToIndex(char: Character) -> UInt8{
    return char.asciiValue! - Character("A").asciiValue!
}


func findWords(node: Node, trie: Node, arr: [[String]], room: Int, row: Int, col: Int, s: String, flags: [Bool]) -> (flag: Bool, word: String){
    let e: Int = Int(charToIndex(char: Character(arr[room / col][room % col])))
    
    if trie.childs[e] != nil{
  	//print(arr[room / col][room % col])
	
        if trieSearch(node: node, str: s, index: 0) {
            return (true, s)
        }
	var secondryFlags = [Bool]()
	for f in flags{
	    secondryFlags.append(f)
	}
        secondryFlags[room] = true
        let successors = getSuccessors(room: room, m: row, n: col)
        for temp in successors{
	    if flags[temp] == false{
            	let x = findWords(node: node, trie: trie.childs[e]!, arr: arr, room: temp, row: row, col: col, s: s + String(arr[temp / col][temp % col]), flags: secondryFlags)
		if x.flag && x.word != ""{
		    return (true, x.word)
		}
	    }
        }
	return (false, "")
    }else{
        return (false, "")
    }
}



func getSuccessors(room: Int, m: Int, n: Int) -> [Int]{
    var successors = [Int]()
    
    if (room % n) > 0{
        successors.append(room-1)
    }
   
    if room % n < n-1{
        successors.append(room + 1)
    }

    if (room / n) > 0{
        successors.append(room - n)
    }
    
    if (room / n) < m-1{
        successors.append(room + n)
    }
    
    if (((room % n) > 0) && ((room / n) > 0)) {
        successors.append(room - 1 - n)
    }
    
    if (((room % n) > 0) && ((room / n) < m-1)) {
        successors.append(room - 1 + n)
    }
    if (((room % n) < n-1 ) && ((room / n) > 0)) {
        successors.append(room + 1 - n)
    }
    
    if (((room % n) < n-1) && ((room / n) < m-1)) {
        successors.append(room + 1 + n)
    }
    
    return successors
}
var trie: Node = Node()
/*trieInsert(node: trie, str: "HASSAN", index: 0)
trieInsert(node: trie, str: "HASSA", index: 0)
print(trieSearch(node: trie, str: "HASSAN", index: 0))
trieDelete(node: trie, str: "HASSAN", index: 0)
print(trieSearch(node: trie, str: "HASSAN", index: 0))*/


var s = readLine()
let words = s!.split(separator: " ")
for word in words{
    trieInsert(node: trie, str: String(word), index: 0)
}


s = readLine()
let sizes = s!.split(separator: " ")
let m = Int(sizes[0])
let n = Int(sizes[1])
var arr: [[String]] = Array(repeating: Array(repeating: "", count: n!), count: m!)
for i in 1...m! {
    s = readLine()
    let row = s!.split(separator: " ")
    for j in 1...row.count {
	arr[i-1][j-1] = String(row[j-1])
    }
}


var flags = [Bool]()
for _ in 1...(m! * n!) {
    flags.append(false)
}



var k = 0;
var size = (m! * n!)
for i in 1..<(m! * n!){
	let x = findWords(node: trie, trie: trie, arr: arr, room: i - k, row: m!, col: n!, s: String(arr[(i - k) / n!][(i - k) % n!]), flags: flags)

	
	if x.flag{
	    print(x.word)
	    trieDelete(node: trie, str: x.word, index: 0)
	    k = k + 1
	    size += 1
	}

}



