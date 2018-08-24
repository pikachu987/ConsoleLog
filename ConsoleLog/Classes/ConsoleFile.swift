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

class ConsoleFile: NSObject {
    static let shared = ConsoleFile()
    
    private var baseURL: URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    var logFileURL: URL? {
        return self.baseURL?.appendingPathComponent("consolelog.log", isDirectory: false)
    }
    
    private override init() {
        
    }
    
    @discardableResult
    func write(_ message: String) -> Bool{
        guard let url = self.logFileURL else { return false }
        do {
            if !FileManager.default.fileExists(atPath: url.path) {
                try message.write(to: url, atomically: true, encoding: .utf8)
            } else {
                let fileHandle = try FileHandle(forUpdating: url)
                _ = fileHandle.seekToEndOfFile()
                if let data = message.data(using: .utf8) {
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            }
            return true
        } catch {
            print("ConsoleLog File Destination could not write to file \(url).")
            return false
        }
    }
    
    @discardableResult
    func delete() -> Bool {
        guard let logFileUrl = self.logFileURL else { return false }
        if FileManager.default.fileExists(atPath: logFileUrl.path) {
            do {
                try FileManager.default.removeItem(at: logFileUrl)
                return true
            } catch {
                print("ConsoleLog File Destination could not remove file \(logFileUrl).")
                return false
            }
        } else { return true }
    }
    
    func read() -> String {
        guard let logFileUrl = self.logFileURL else { return "" }
        do {
            return try String(contentsOf: logFileUrl)
        } catch {
            print("ConsoleLog File Destination could not read file \(logFileUrl).")
            return ""
        }
    }
}
