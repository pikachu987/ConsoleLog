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
import WebKit

public enum ConsoleLogType {
    case `default`
    case todayLog
    case log
    case info
    var title: String {
        switch self {
        case .todayLog:
            return ConsoleLog.shared.consoleOptions.consoleLogTitle.todayLog
        case .log:
            return ConsoleLog.shared.consoleOptions.consoleLogTitle.log
        case .info:
            return ConsoleLog.shared.consoleOptions.consoleLogTitle.info
        case .default:
            return ""
        }
    }
}

class ConsoleLogView: UIView {
    
    private lazy var statusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        self.addConstraints(self.constraint(view, top: 0, left: 0, right: 0))
        view.addConstraints(view.constraint(height: UIApplication.shared.statusBarFrame.height, heightPriority: 900))
        return view
    }()
    
    private lazy var navigationBar: UINavigationBar = {
        let navigationController = UINavigationController()
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: navigationController.navigationBar.frame.height))
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(navigationBar)
        self.addConstraints(self.constraint(navigationBar, left: 0, right: 0))
        self.addConstraint(self.statusView.constraint(navigationBar, attribute: .bottom, toItemAttribute: .top))
        navigationBar.addConstraints(navigationBar.constraint(height: navigationController.navigationBar.frame.height, heightPriority: 900))
        return navigationBar
    }()
    
    private lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        self.addConstraints(self.constraint(view, left: 0, bottom: 0, right: 0))
        self.addConstraint(self.navigationBar.constraint(view, attribute: .bottom, toItemAttribute: .top))
        return view
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        self.view.addConstraints(self.view.constraint(webView, top: 0, left: 0, bottom: 0, right: 0))
        return webView
    }()
    
    private var type = ConsoleLogType.log
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.origin.y = UIScreen.main.bounds.height
        self.isHidden = true
        self.backgroundColor = .black
        self.view.backgroundColor = .black
        
        self.statusView.backgroundColor = ConsoleLog.shared.consoleOptions.naviagationOptions.barColor
        self.navigationBar.barTintColor = ConsoleLog.shared.consoleOptions.naviagationOptions.barColor
        self.navigationBar.backgroundColor = ConsoleLog.shared.consoleOptions.naviagationOptions.barColor
        self.navigationBar.tintColor = ConsoleLog.shared.consoleOptions.naviagationOptions.barTintColor
        self.navigationBar.isTranslucent = false
        
        if self.navigationBar.topItem == nil {
            self.navigationBar.setItems([UINavigationItem(title: "")], animated: true)
        }
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.backAction(_:)))
        self.navigationBar.topItem?.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareAction(_:)))
        ]
        
        self.webView.backgroundColor = ConsoleLog.shared.consoleOptions.webViewOptions.backgroundColor
        self.webView.scrollView.backgroundColor = ConsoleLog.shared.consoleOptions.webViewOptions.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ type: ConsoleLogType, animated: Bool) {
        self.type = type
        self.navigationBar.topItem?.title = type.title
        self.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(self)
        self.webView.scrollView.setContentOffset(CGPoint.zero, animated: false)
        self.webView.scrollView.setZoomScale(1, animated: false)
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.frame.origin.y = 0
            }
        } else {
            self.frame.origin.y = 0
        }
        self.webView.loadHTMLString(self.makeHtml(""), baseURL: URL(string: ""))
        self.webView.loadHTMLString(self.makeHtml(self.readLog()), baseURL: URL(string: ""))
    }
    
    private func readLog() -> String{
        if self.type == .log {
            return ConsoleLog.shared.readWebView
        } else if self.type == .todayLog {
            return ConsoleLog.shared.todayReadWebView
        } else if self.type == .info {
            var text = ""
            if ConsoleLog.shared.consoleOptions.infoOptions.isLanguage {
                let language = Locale.current.languageCode ?? ""
                text += "language: \(language)\n"
            }
            if ConsoleLog.shared.consoleOptions.infoOptions.isLocale {
                let locale = Locale.current.regionCode ?? ""
                text += "locale: \(locale)\n"
            }
            if ConsoleLog.shared.consoleOptions.infoOptions.isPreferredLanguages {
                let preferredLanguages = Locale.preferredLanguages
                text += "preferredLanguages: \(preferredLanguages)\n"
            }
            if ConsoleLog.shared.consoleOptions.infoOptions.isVersion {
                let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
                text += "version: \(version)\n"
            }
            if ConsoleLog.shared.consoleOptions.infoOptions.isBulid {
                let bulid = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
                text += "bulid: \(bulid)\n"
            }
            if ConsoleLog.shared.consoleOptions.infoOptions.isUUID {
                let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
                text += "uuid: \(uuid)\n"
            }
            text += ConsoleLog.shared.consoleOptions.infoOptions.addText
            return text
        }
        return ""
    }
    
    private func makeHtml(_ text: String) -> String {
        let backgroundColor = "#\(ConsoleLog.shared.consoleOptions.webViewOptions.backgroundColor.toHexString)"
        let textColor = "#\(ConsoleLog.shared.consoleOptions.webViewOptions.textColor.toHexString)"
        let fontSize = ConsoleLog.shared.consoleOptions.webViewOptions.fontSize
        var html = ""
        html.append("<!DOCTYPE html>")
        html.append("<html>")
        html.append("<head>")
        html.append("<meta http-equiv='content-type' content='text/html; charset=utf-8'>")
        html.append("<meta name='viewport' content='width=device-width, initial-scale=1'>")
        html.append("<style type='text/css'> body { font-size: \(fontSize)px; font-family: Sans-serif; color: \(textColor); background-color: \(backgroundColor); } </style>")
        html.append("</head>")
        html.append("<body><pre>\(text.replacingOccurrences(of: "\n", with: "<br/>"))</pre></body>")
        html.append("</html>")
        return html
    }
    
    func hide(_ animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.frame.origin.y = UIScreen.main.bounds.height
            }) { (_) in
                self.isHidden = true
                self.removeFromSuperview()
            }
        } else {
            self.frame.origin.y = UIScreen.main.bounds.height
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    @objc private func backAction(_ sender: UIBarButtonItem) {
        self.hide(true)
    }
    
    @objc private func shareAction(_ sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [self.readLog()], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        let activityWindow = UIWindow(frame: UIScreen.main.bounds)
        activityWindow.rootViewController = UIViewController()
        guard let window = UIApplication.shared.windows.last else { return }
        activityWindow.windowLevel = window.windowLevel + 1
        activityViewController.completionWithItemsHandler = { activityType, success, items, error in
            activityWindow.isHidden = true
            activityWindow.windowLevel = window.windowLevel - 1
            activityWindow.removeFromSuperview()
        }
        activityWindow.makeKeyAndVisible()
        activityWindow.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
}
