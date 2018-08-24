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

extension UIView {
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

extension String {
    var parseJSON: AnyObject {
        guard let data = (self).data(using: String.Encoding.utf8) else{ return "" as AnyObject }
        do {
            return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        } catch {
            return "" as AnyObject
        }
    }
}

extension Dictionary {
    var JSONStringify: String {
        if JSONSerialization.isValidJSONObject(self) {
            do{
                let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
                return (NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "") as String
            }catch { }
        }
        return ""
    }
}

extension UIColor {
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}

extension Date{
    func currentDate(_ calendar : Calendar = Calendar.current) -> (String, String, String){
        let calendar = Calendar.current
        let year = "\(calendar.component(.year, from: self))"
        let month = calendar.component(.month, from: self)
        let monthValue = month < 10 ? "0\(month)" : "\(month)"
        let day = calendar.component(.day, from: self)
        let dayValue = day < 10 ? "0\(day)" : "\(day)"
        return (year, monthValue, dayValue)
    }
}
