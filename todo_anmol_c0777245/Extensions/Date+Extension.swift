//
//  Date+Extension.swift
//  todo_anmol_c0777245
//
//  Created by Anmol singh on 2020-06-23.
//  Copyright © 2020 Swift Project. All rights reserved.
//

import Foundation

extension Date{
    public func getFormattedDate() -> String
    {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE, d MMM, yyyy"
    
        let formattedDate = dateFormatterPrint.string(from: self)
        return formattedDate
    }
}
