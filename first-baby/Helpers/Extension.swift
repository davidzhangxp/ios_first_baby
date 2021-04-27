//
//  Extension.swift
//  first-baby
//
//  Created by Max Wen on 3/11/21.
//

import Foundation
import UIKit

extension UIView{
    public var width :CGFloat {
        return self.frame.size.width
    }
    public var height : CGFloat {
        return self.frame.size.height
    }
    public var top : CGFloat {
        return self.frame.origin.y
    }
    public var bottom : CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    public var left : CGFloat {
        return self.frame.origin.x
    }
    public var right : CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
}
extension Date{
    func longDate()->String{
        let  dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    func  stringDate()->String{
        let  dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }
    func interval(ofComponent comp: Calendar.Component,fromDate date:Date)->Int{
        let currentCalendar = Calendar.current
        guard  let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else {
            return 0
        }
        return start - end
    }
}
