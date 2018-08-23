import UIKit

public class ConsoleLog: NSObject {
    public static let shared = ConsoleLog()
    
    public enum Level: Int {
        case verbose = 0
        case debug = 1
        case info = 2
        case warning = 3
        case error = 4
    }
    
    public static var defaultPoint = CGPoint(x: UIScreen.main.bounds.width - 44*4 - 20, y: 60)
    
    private lazy var consoleView: ConsoleView = {
        let consoleView = ConsoleView(frame: CGRect(origin: ConsoleLog.defaultPoint, size: CGSize(width: 44, height: 44)))
        consoleView.backgroundColor = UIColor.clear
        consoleView.layer.cornerRadius = 2
        return consoleView
    }()
    
    private override init() {
        
    }
    
    public func custom(level: ConsoleLog.Level, message: Any) {
        
    }
    
    
    public func show(_ point: CGPoint = ConsoleLog.defaultPoint) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.consoleView.removeFromSuperview()
            self.consoleView.frame.origin = point
            UIApplication.shared.keyWindow?.addSubview(self.consoleView)
        }
    }
    
    public func hide() {
        
    }
}

class ConsoleFile: NSObject {
    static let shared = ConsoleFile()
    
    private var baseURL: String {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.absoluteString ?? ""
    }
    private var logFileURL: String {
        return self.baseURL.appending("console.log")
    }
    
    private override init() {
        
    }
}

class ConsoleView: UIView {
    private lazy var consoleButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("콘솔", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        self.addConstraints(self.constraint(button, top: 0, left: 0))
        self.addConstraint(self.constraint(button, attribute: .bottom, priority: 500))
        self.addConstraint(self.constraint(button, attribute: .right, priority: 500))
        button.addConstraints(button.constraint(width: 44, height: 44))
        return button
    }()
    
    private lazy var tLogButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("t로그", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        self.addConstraint(self.consoleButton.constraint(button, attribute: .bottom, toItemAttribute: .top))
        self.addConstraints(self.constraint(button, left: 0, bottom: 0))
        button.addConstraints(button.constraint(width: 44, height: 44, heightPriority: 500))
        return button
    }()
    
    private lazy var logButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("로그", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        self.addConstraint(self.consoleButton.constraint(button, attribute: .bottom, toItemAttribute: .top))
        self.addConstraint(self.tLogButton.constraint(button, attribute: .trailing, toItemAttribute: .leading))
        self.addConstraints(self.constraint(button, bottom: 0))
        button.addConstraints(button.constraint(width: 44, height: 44, heightPriority: 500))
        return button
    }()
    
    private lazy var crashButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("크래시", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        self.addConstraint(self.consoleButton.constraint(button, attribute: .bottom, toItemAttribute: .top))
        self.addConstraint(self.logButton.constraint(button, attribute: .trailing, toItemAttribute: .leading))
        self.addConstraints(self.constraint(button, bottom: 0))
        button.addConstraints(button.constraint(width: 44, height: 44, heightPriority: 500))
        return button
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("내정보", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        self.addConstraint(self.consoleButton.constraint(button, attribute: .bottom, toItemAttribute: .top))
        self.addConstraint(self.crashButton.constraint(button, attribute: .trailing, toItemAttribute: .leading))
        self.addConstraints(self.constraint(button, bottom: 0))
        button.addConstraints(button.constraint(width: 44, height: 44, heightPriority: 500))
        return button
    }()
    
    private let consoleLineView = ConsoleLineView(frame: UIScreen.main.bounds)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panGestureAction(_:))))
        self.consoleButton.addTarget(self, action: #selector(self.consoleAction(_:)), for: .touchUpInside)
        self.tLogButton.addTarget(self, action: #selector(self.tLogAction(_:)), for: .touchUpInside)
        self.logButton.addTarget(self, action: #selector(self.logAction(_:)), for: .touchUpInside)
        self.crashButton.addTarget(self, action: #selector(self.crashAction(_:)), for: .touchUpInside)
        self.infoButton.addTarget(self, action: #selector(self.infoAction(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func panGestureAction(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: UIApplication.shared.keyWindow)
        self.frame.origin = CGPoint(x: point.x - 44/2, y: point.y - 44/2)
    }
    
    @objc private func consoleAction(_ sender: UIButton) {
        if self.frame.height == 44 {
            UIView.animate(withDuration: 0.3) {
                self.frame.size.width = 44*4
                self.frame.size.height = 44*2
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.frame.size.width = 44
                self.frame.size.height = 44
            }
        }
    }
    
    @objc private func tLogAction(_ sender: UIButton) {
        self.consoleLineView.show(.todayLog, animated: true)
    }
    
    @objc private func logAction(_ sender: UIButton) {
        self.consoleLineView.show(.log, animated: true)
    }
    
    @objc private func crashAction(_ sender: UIButton) {
        self.consoleLineView.show(.crash, animated: true)
    }
    
    @objc private func infoAction(_ sender: UIButton) {
        self.consoleLineView.show(.info, animated: true)
    }
}

enum ConsoleLineType {
    case todayLog
    case log
    case crash
    case info
}

class ConsoleLineView: UIView {
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
        let navigationBar = UINavigationBar()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.origin.y = UIScreen.main.bounds.height
        self.isHidden = true
        self.backgroundColor = .black
        self.view.backgroundColor = .black
        
        self.statusView.backgroundColor = UIColor(white: 230/255, alpha: 1)
        self.navigationBar.barTintColor = UIColor(white: 230/255, alpha: 1)
        self.navigationBar.backgroundColor = UIColor(white: 230/255, alpha: 1)
        self.navigationBar.isTranslucent = false
        
        if self.navigationBar.topItem == nil {
            self.navigationBar.setItems([UINavigationItem(title: "")], animated: true)
        }
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.backAction(_:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ type: ConsoleLineType, animated: Bool) {
        self.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(self)
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.frame.origin.y = 0
            }
        } else {
            self.frame.origin.y = 0
        }
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
    
}

private extension UIView {
    func constraint(_ toItem: UIView, attribute: NSLayoutAttribute, toItemAttribute: NSLayoutAttribute? = nil, relatedBy: NSLayoutRelation = NSLayoutRelation.equal, constant: CGFloat = 0, priority: CGFloat = 1000) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relatedBy, toItem: toItem, attribute: toItemAttribute ?? attribute, multiplier: 1, constant: constant)
        constraint.priority = UILayoutPriority(Float(priority))
        return constraint
    }
    func constraint(width: CGFloat? = nil, widthPriority: CGFloat = 1000, height: CGFloat? = nil, heightPriority: CGFloat = 1000) -> [NSLayoutConstraint] {
        var array = [NSLayoutConstraint]()
        if let width = width {
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: width)
            constraint.priority = UILayoutPriority(Float(widthPriority))
            array.append(constraint)
        }
        if let height = height {
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: height)
            constraint.priority = UILayoutPriority(Float(heightPriority))
            array.append(constraint)
        }
        return array
    }
    func constraint(_ toItem: UIView, top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> [NSLayoutConstraint] {
        var array = [NSLayoutConstraint]()
        if let top = top {
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: toItem, attribute: NSLayoutAttribute.top, multiplier: 1, constant: top)
            array.append(constraint)
        }
        if let left = left {
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: .equal, toItem: toItem, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: left)
            array.append(constraint)
        }
        if let right = right {
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: .equal, toItem: toItem, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: right)
            array.append(constraint)
        }
        if let bottom = bottom {
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: .equal, toItem: toItem, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: bottom)
            array.append(constraint)
        }
        return array
    }
}
