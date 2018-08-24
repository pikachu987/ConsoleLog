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

import UIKit

// MARK: LevelString
public struct LevelString {
    var verbose = "💜 VERBOSE"
    var debug = "💚 DEBUG"
    var info = "💙 INFO"
    var warning = "💛 WARNING"
    var error = "❤️ ERROR"
    var verboseColor = UIColor(red: 173/255, green: 58/255, blue: 243/255, alpha: 1)
    var debugColor = UIColor(red: 64/255, green: 198/255, blue: 41/255, alpha: 1)
    var infoColor = UIColor(red: 9/255, green: 99/255, blue: 246/255, alpha: 1)
    var warningColor = UIColor(red: 252/255, green: 210/255, blue: 62/255, alpha: 1)
    var errorColor = UIColor(red: 255/255, green: 55/255, blue: 43/255, alpha: 1)
}

// MARK: NavigationOptions
public struct NavigationOptions {
    var barColor = UIColor(white: 230/255, alpha: 1)
    var barTintColor = UIColor.black
}

// MARK: WebViewOptions
public struct WebViewOptions {
    var backgroundColor = UIColor.black
    var textColor = UIColor(red: 192/255, green: 192/255, blue: 186/255, alpha: 1)
    var fontSize: CGFloat = 10
}

// MARK: InfoOptions
public struct InfoOptions {
    var isLanguage = true
    var isPreferredLanguages = true
    var isLocale = true
    var isVersion = true
    var isBulid = true
    var isUUID = true
    var addText = ""
}

// MARK: ConsoleLogTitle
public struct ConsoleLogTitle {
    var todayLog = "Today Log"
    var log = "All Log"
    var info = "Info"
}

// MARK: ConsoleOptions
public struct ConsoleOptions {
    var levelString = LevelString()
    var naviagationOptions = NavigationOptions()
    var webViewOptions = WebViewOptions()
    var consoleLogTitle = ConsoleLogTitle()
    var infoOptions = InfoOptions()
    var dateFormat = "yyyy-MM-dd HH:mm:ss"
    var line = "------------------------------------------------------------"
    var ascending = false
}

public class ConsoleLog: NSObject {
    public static let shared = ConsoleLog()
    public var makeButtonHandler: ((UIButton, ConsoleLogType) -> Void)? = nil
    
    public var consoleOptions = ConsoleOptions()
    public var defaultPoint = CGPoint(x: UIScreen.main.bounds.width - 44*3 - 60, y: 60)
    public var logFileURL: URL? {
        return ConsoleFile.shared.logFileURL
    }
    
    // MARK: level
    public enum Level: Int {
        case verbose = 0
        case debug = 1
        case info = 2
        case warning = 3
        case error = 4
        
        var color: String {
            switch self {
            case .verbose:
                return "#"+ConsoleLog.shared.consoleOptions.levelString.verboseColor.toHexString
            case .debug:
                return "#"+ConsoleLog.shared.consoleOptions.levelString.debugColor.toHexString
            case .info:
                return "#"+ConsoleLog.shared.consoleOptions.levelString.infoColor.toHexString
            case .warning:
                return "#"+ConsoleLog.shared.consoleOptions.levelString.warningColor.toHexString
            case .error:
                return "#"+ConsoleLog.shared.consoleOptions.levelString.errorColor.toHexString
            }
        }
        
        var levelString: String {
            switch self {
            case .verbose:
                return ConsoleLog.shared.consoleOptions.levelString.verbose
            case .debug:
                return ConsoleLog.shared.consoleOptions.levelString.debug
            case .info:
                return ConsoleLog.shared.consoleOptions.levelString.info
            case .warning:
                return ConsoleLog.shared.consoleOptions.levelString.warning
            case .error:
                return ConsoleLog.shared.consoleOptions.levelString.error
            }
        }
    }
    
    public var readArray: [ConsoleVO] {
        var items = ConsoleFile.shared.read()
            .components(separatedBy: "},")
            .compactMap({ ConsoleVO.console($0+"}") })
        if !self.consoleOptions.ascending {
            items.reverse()
        }
        return items
    }
    
    public var read: String {
        return self.readArray
            .map({ $0.description })
            .reduce("", { "\($0)\($1)\n\(self.consoleOptions.line)\n" })
    }
    
    public var todayReadArray: [ConsoleVO] {
        let date = Date().currentDate()
        return self.readArray.filter({ $0.date.currentDate() == date })
    }
    
    public var todayRead: String {
        return self.todayReadArray
            .map({ $0.description })
            .reduce("", { "\($0)\($1)\n\(self.consoleOptions.line)\n" })
    }
    
    private var queue: DispatchQueue?
    
    private lazy var consoleView: ConsoleView = {
        let consoleView = ConsoleView(frame: CGRect(origin: self.defaultPoint, size: CGSize(width: 44, height: 44)))
        consoleView.backgroundColor = UIColor.clear
        consoleView.layer.cornerRadius = 2
        return consoleView
    }()
    
    private override init() { }
    
    // MARK: write
    public func custom(level: ConsoleLog.Level, message: Any) {
        self.queue = DispatchQueue(label: "consolelog-queue-\(NSUUID().uuidString)", target: self.queue)
        self.queue?.async {
            let text = ConsoleVO(
                message: self.replacingMessage(message),
                logLevel: level,
                dateFormat: self.consoleOptions.dateFormat
                ).JSONStringify
            ConsoleFile.shared.write(text)
        }
    }
    
    public func verbose(_ message: Any) {
        self.custom(level: .verbose, message: message)
    }
    
    public func debug(_ message: Any) {
        self.custom(level: .debug, message: message)
    }
    
    public func info(_ message: Any) {
        self.custom(level: .info, message: message)
    }
    
    public func warning(_ message: Any) {
        self.custom(level: .warning, message: message)
    }
    
    public func error(_ message: Any) {
        self.custom(level: .error, message: message)
    }
    
    // MARK: remove
    @discardableResult
    public func remove() -> Bool {
        return ConsoleFile.shared.delete()
    }
    
    // MARK: show
    public func show(_ point: CGPoint? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.consoleView.removeFromSuperview()
            self.consoleView.frame.origin = point ?? self.defaultPoint
            UIApplication.shared.keyWindow?.addSubview(self.consoleView)
        }
    }
    
    // MARK: hide
    public func hide() {
        self.consoleView.removeFromSuperview()
    }
}


extension ConsoleLog {
    var todayReadWebView: String {
        return self.todayReadArray
            .map({ $0.descriptionWebView })
            .reduce("", { "\($0)\($1)\n\(self.consoleOptions.line)\n" })
    }
    
    var readWebView: String {
        return self.readArray
            .map({ $0.descriptionWebView })
            .reduce("", { "\($0)\($1)\n\(self.consoleOptions.line)\n" })
    }
    
    private func replacingMessage(_ message: Any) -> String {
        let line = "    "
        if let message = message as? [Any] {
            var text = message.reduce("") { (result, value) -> String in
                var text = "\(line)\(value)"
                if let value = value as? [AnyHashable: Any] {
                    text = value.reduce("") { (result, value) -> String in
                        return result == "" ? "\(line)\(line)\(value.key): \(value.value)" : "\(result),\n\(line)\(line)\(value.key): \(value.value)"
                    }
                    text = "\(line)[\n\(text)\n\(line)]"
                }
                return result == "" ? "\(text)" : "\(result),\n\(text)"
            }
            text = "[\n\(text)\n]"
            return text
        } else if let message = message as? [AnyHashable: Any] {
            var text = message.reduce("") { (result, value) -> String in
                return result == "" ? "\(line)\(value.key): \(value.value)" : "\(result),\n\(line)\(value.key): \(value.value)"
            }
            text = "[\n\(text)\n]"
            return text
        } else {
            return  "\(message)"
        }
    }
}
