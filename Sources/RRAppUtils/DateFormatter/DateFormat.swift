//
//  DateFormats.swift
//  RRAppBaseFrameworks
//
//  Created by Raj S on 25/12/24.
//

import Foundation
enum DateFormats : String {
    case dayMonthDateYear = "E MMM d, yyyy"
    case monthDayYearWithSpaces = "MM dd YYYY"
    case fullFormatWithMilliSeconds = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case fullFormatWithoutMilliSeconds = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    case fullFormat  = "yyyy-MM-dd'T'HH:mm"
    case yearMonthDayWithDashes = "yyyy-MM-dd"
    case monthDayYearWithSlashes =  "MM/dd/yyyy"
    case dayMonthYearWithSlashes =  "dd/MM/yyyy"
    case monthDayYearWithDashes =  "MM-dd-YYYY"
    case hourMinute12hr = "hh:mm a"
    case hourMinuteSeconds24hr = "HH:mm:ss"
    case hourMinute24hr = "HH:mm"
}
