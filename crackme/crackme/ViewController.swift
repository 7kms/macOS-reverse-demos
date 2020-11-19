//
//  ViewController.swift
//  crackme
//
//  Created by 公里柒 on 2020/11/16.
//  Copyright © 2020 km7. All rights reserved.
//

import Cocoa
import Arcane

class ViewController: NSViewController {
    var window: NSWindow?
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var snTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear() {
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "username") != nil) && (defaults.object(forKey: "sn") != nil) {
            let username = defaults.object(forKey: "username") as! String
            let sn = defaults.object(forKey: "sn") as! String
            snTextField.stringValue = sn
            nameTextField.stringValue = username
            
            if true == checkSN(username, sn: sn) {
                self.window?.title = "crackme registerd by " + (username as String)
                self.nameTextField.stringValue = (username as String)
                self.snTextField.stringValue = (sn as String)
                
            }
        }else{
            self.window?.title = "crackme unregisterd"
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func alert(_ msg: String) {
        let alert = NSAlert()
        alert.messageText = msg
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    @IBAction func onAboutClick(_ sender: NSButton) {
    }
    
    @IBAction func onCleanClick(_ sender: NSButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "sn")
        
        window?.title = "crackme unregisterd"
        nameTextField.stringValue = ""
        snTextField.stringValue = ""
    }
    @IBAction func onRegister(_ sender: NSButton) {
        let username = nameTextField.stringValue
        if username.isEmpty {
            nameTextField.becomeFirstResponder()
            alert("username is empty!")
            return
        }
        let sn = snTextField.stringValue
        if sn.isEmpty{
            snTextField.becomeFirstResponder()
            alert("serial number is empty!")
            return
        }
       
        if (sn.count != 19) ||
            (sn[4...4] != "-") ||
            (sn[9...9] != "-") ||
            (sn[14...14] != "-") {
            snTextField.becomeFirstResponder()
            alert("serial number format is wrong!")
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: "username")
        defaults.set(sn.uppercased(), forKey: "sn")
        
        if true == checkSN(username, sn: sn) {
            window?.title = "crackme registerd by " + username
            
            alert("serial ok!")
            
        } else {
            window?.title = "crackme unregisterd"
            alert("serial number error!")
        }
    }
    
    func checkSN(_ username: String, sn: String) -> Bool {

        let md5 = Hash.MD5(username)!
        let sha1 = Hash.SHA1(username)!
        let hmacmd5 = HMAC.MD5(username, key: "crackme!")!
        let hmacsha1 = HMAC.SHA1(username, key: "crackme!")!

        let v0 = md5[0...0]
        let v1 = md5[4...4]
        let v2 = md5[8...8]
        let v3 = md5[12...12]
        
        let v4 = sha1[0...0]
        let v5 = sha1[4...4]
        let v6 = sha1[8...8]
        let v7 = sha1[12...12]
        
        let v8 = hmacmd5[0...0]
        let v9 = hmacmd5[4...4]
        let v10 = hmacmd5[8...8]
        let v11 = hmacmd5[12...12]
        
        let v12 = hmacsha1[0...0]
        let v13 = hmacsha1[4...4]
        let v14 = hmacsha1[8...8]
        let v15 = hmacsha1[12...12]
        
        var hash = v0 + v1 + v2 + v3
        hash += "-"
        hash += v4 + v5 + v6 + v7
        hash += "-"
        hash += v8 + v9 + v10 + v11
        hash += "-"
        hash += v12 + v13 + v14 + v15
        
        //NSLog("hash: " + hash.uppercaseString)
        
        return (sn.uppercased() == hash.uppercased())
    }
}


extension String {
    
    /**
     Enables passing in negative indices to access characters
     starting from the end and going backwards.
     if num is negative, then it is added to the
     length of the string to retrieve the true index.
     */
    func negativeIndex(_ num: Int) -> Int {
        return num < 0 ? num + self.count : num
    }
    
    func strOpenRange(index i: Int) -> Range<String.Index> {
        let j = negativeIndex(i)
        return strOpenRange(j..<(j + 1), checkNegative: false)
    }
    
    func strOpenRange(
        _ range: Range<Int>, checkNegative: Bool = true
        ) -> Range<String.Index> {
        
        var lower = range.lowerBound
        var upper = range.upperBound
        
        if checkNegative {
            lower = negativeIndex(lower)
            upper = negativeIndex(upper)
        }
        
        let idx1 = index(self.startIndex, offsetBy: lower)
        let idx2 = index(self.startIndex, offsetBy: upper)
        
        return idx1..<idx2
    }
    
    func strClosedRange(
        _ range: CountableClosedRange<Int>, checkNegative: Bool = true
        ) -> ClosedRange<String.Index> {
        
        var lower = range.lowerBound
        var upper = range.upperBound
        
        if checkNegative {
            lower = negativeIndex(lower)
            upper = negativeIndex(upper)
        }
        
        let start = self.index(self.startIndex, offsetBy: lower)
        let end = self.index(start, offsetBy: upper - lower)
        
        return start...end
    }
    
    // MARK: - Subscripts
    
    /**
     Gets and sets a character at a given index.
     Negative indices are added to the length so that
     characters can be accessed from the end backwards
     
     Usage: `string[n]`
     */
    subscript(_ i: Int) -> String {
        get {
            return String(self[strOpenRange(index: i)])
        }
        set {
            let range = strOpenRange(index: i)
            replaceSubrange(range, with: newValue)
        }
    }
    
    
    /**
     Gets and sets characters in an open range.
     Supports negative indexing.
     
     Usage: `string[n..<n]`
     */
    subscript(_ r: Range<Int>) -> String {
        get {
            return String(self[strOpenRange(r)])
        }
        set {
            replaceSubrange(strOpenRange(r), with: newValue)
        }
    }
    
    /**
     Gets and sets characters in a closed range.
     Supports negative indexing
     
     Usage: `string[n...n]`
     */
    subscript(_ r: CountableClosedRange<Int>) -> String {
        get {
            return String(self[strClosedRange(r)])
        }
        set {
            replaceSubrange(strClosedRange(r), with: newValue)
        }
    }
    
    /// `string[n...]`. See PartialRangeFrom
    subscript(r: PartialRangeFrom<Int>) -> String {
        
        get {
            return String(self[strOpenRange(r.lowerBound..<self.count)])
        }
        set {
            replaceSubrange(strOpenRange(r.lowerBound..<self.count), with: newValue)
        }
    }
    
    /// `string[...n]`. See PartialRangeThrough
    subscript(r: PartialRangeThrough<Int>) -> String {
        
        get {
            let upper = negativeIndex(r.upperBound)
            return String(self[strClosedRange(0...upper, checkNegative: false)])
        }
        set {
            let upper = negativeIndex(r.upperBound)
            replaceSubrange(
                strClosedRange(0...upper, checkNegative: false), with: newValue
            )
        }
    }
    
    /// `string[...<n]`. See PartialRangeUpTo
    subscript(r: PartialRangeUpTo<Int>) -> String {
        
        get {
            let upper = negativeIndex(r.upperBound)
            return String(self[strOpenRange(0..<upper, checkNegative: false)])
        }
        set {
            let upper = negativeIndex(r.upperBound)
            replaceSubrange(
                strOpenRange(0..<upper, checkNegative: false), with: newValue
            )
        }
    }
    
    
}
