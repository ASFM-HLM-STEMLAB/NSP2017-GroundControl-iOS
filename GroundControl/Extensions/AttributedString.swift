//
//  AttributedStringExtensions.swift
//  GroundControl
//
//  Created by Francisco Lobo on 1/16/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        
        guard let attributedString = try?  NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString: attributedString)
    }
    
}
