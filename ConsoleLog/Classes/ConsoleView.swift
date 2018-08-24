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

class ConsoleView: UIView {
    private lazy var consoleButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("Console", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
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
        button.setTitle("TodayLog", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        self.addSubview(button)
        self.addConstraint(self.consoleButton.constraint(button, attribute: .bottom, toItemAttribute: .top))
        self.addConstraints(self.constraint(button, left: 0, bottom: 0))
        button.addConstraints(button.constraint(width: 44, height: 44, heightPriority: 500))
        return button
    }()
    
    private lazy var logButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("AllLog", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        self.addSubview(button)
        self.addConstraint(self.consoleButton.constraint(button, attribute: .bottom, toItemAttribute: .top))
        self.addConstraint(self.tLogButton.constraint(button, attribute: .trailing, toItemAttribute: .leading))
        self.addConstraints(self.constraint(button, bottom: 0))
        button.addConstraints(button.constraint(width: 44, height: 44, heightPriority: 500))
        return button
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("Info", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        self.addSubview(button)
        self.addConstraint(self.consoleButton.constraint(button, attribute: .bottom, toItemAttribute: .top))
        self.addConstraint(self.logButton.constraint(button, attribute: .trailing, toItemAttribute: .leading))
        self.addConstraints(self.constraint(button, bottom: 0))
        button.addConstraints(button.constraint(width: 44, height: 44, heightPriority: 500))
        return button
    }()
    
    private let consoleLineView = ConsoleLogView(frame: UIScreen.main.bounds)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panGestureAction(_:))))
        self.consoleButton.addTarget(self, action: #selector(self.consoleAction(_:)), for: .touchUpInside)
        self.tLogButton.addTarget(self, action: #selector(self.tLogAction(_:)), for: .touchUpInside)
        self.logButton.addTarget(self, action: #selector(self.logAction(_:)), for: .touchUpInside)
        self.infoButton.addTarget(self, action: #selector(self.infoAction(_:)), for: .touchUpInside)
        
        ConsoleLog.shared.makeButtonHandler?(self.consoleButton, .default)
        ConsoleLog.shared.makeButtonHandler?(self.tLogButton, .todayLog)
        ConsoleLog.shared.makeButtonHandler?(self.logButton, .log)
        ConsoleLog.shared.makeButtonHandler?(self.infoButton, .info)
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
                self.frame.size.width = 44*3
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
    
    @objc private func infoAction(_ sender: UIButton) {
        self.consoleLineView.show(.info, animated: true)
    }
}
