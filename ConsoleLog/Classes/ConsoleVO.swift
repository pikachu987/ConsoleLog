//Copyright (c) 2018 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import Foundation

public struct ConsoleVO {
    var message: String
    var logLevel: ConsoleLog.Level
    var date: Date
    var dateFormat: String
    
    var JSONStringify: String {
        let console = [
            "message": self.message,
            "logLevel": "\(self.logLevel.rawValue)",
            "date": "\(self.date.timeIntervalSince1970)",
            "dateFormat": self.dateFormat,
        ]
        return "\(console.JSONStringify),"
    }
    
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.dateFormat
        let date = dateFormatter.string(from: self.date)
        
        let text = "\(self.logLevel.levelString) \(date)\n\(self.message.replacingOccurrences(of: "consolelog_replacing_1", with: "},"))"
        return text
    }
    
    var descriptionWebView: String {
        return "<div style='color:\(self.logLevel.color)'>\(self.description)</div>"
    }
    
    init(message: String, logLevel: ConsoleLog.Level, dateFormat: String) {
        self.message = message.replacingOccurrences(of: "},", with: "consolelog_replacing_1")
        self.logLevel = logLevel
        self.dateFormat = dateFormat
        self.date = Date()
    }
    
    private init(_ map: [String: String]) {
        if let value = map["message"] {
            self.message = value
        } else {
            self.message = ""
        }
        if let value = map["logLevel"],
            let logRawValue = Int(value),
            let logLevel = ConsoleLog.Level(rawValue: logRawValue) {
            self.logLevel = logLevel
        } else {
            self.logLevel = .info
        }
        if let value = map["date"], let dateValue = TimeInterval(value) {
            self.date = Date(timeIntervalSince1970: dateValue)
        } else {
            self.date = Date(timeIntervalSince1970: 0)
        }
        if let value = map["dateFormat"] {
            self.dateFormat = value
        } else {
            self.dateFormat = ""
        }
    }
    
    static func console(_ value: String) -> ConsoleVO? {
        if value == "" { return nil }
        guard let map = value.parseJSON as? [String: String] else { return nil }
        return ConsoleVO(map)
    }
}
