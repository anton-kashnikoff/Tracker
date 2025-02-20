//
//  Schedule.swift
//  Tracker
//
//  Created by Антон Кашников on 02.08.2023.
//

import Foundation

struct Schedule {
    enum DayOfWeek: String, CaseIterable {
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
        
        func getIndexOfCase() -> Int {
            Self.allCases.firstIndex {
                self == $0
            } ?? -1
        }
        
        func getNumberOfDay() -> Int? {
            let index = getIndexOfCase()
            
            if index == 6 {
                return 1
            }
            
            return index + 2
        }
        
        func getBriefDayOfWeek() -> String {
            let index = getIndexOfCase()
            
            switch index {
            case 0:
                return NSLocalizedString("schedule.briefDayOfWeek.monday", comment: "Brief string for Monday")
            case 1:
                return NSLocalizedString("schedule.briefDayOfWeek.tuesday", comment: "Brief string for Tuesday")
            case 2:
                return NSLocalizedString("schedule.briefDayOfWeek.wednesday", comment: "Brief string for Wednesday")
            case 3:
                return NSLocalizedString("schedule.briefDayOfWeek.thursday", comment: "Brief string for Thursday")
            case 4:
                return NSLocalizedString("schedule.briefDayOfWeek.friday", comment: "Brief string for Friday")
            case 5:
                return NSLocalizedString("schedule.briefDayOfWeek.saturday", comment: "Brief string for Saturday")
            case 6:
                return NSLocalizedString("schedule.briefDayOfWeek.sunday", comment: "Brief string for Sunday")
            default:
                return ""
            }
        }
    }
    
    let daysOfWeek: Set<DayOfWeek>
}

extension Schedule {
    static func getNameOfDay(_ number: Int) -> String {
        switch number {
        case 1:
            return NSLocalizedString("schedule.dayOfWeek.sunday", comment: "Full name of Sunday")
        case 2:
            return NSLocalizedString("schedule.dayOfWeek.monday", comment: "Full name of Monday")
        case 3:
            return NSLocalizedString("schedule.dayOfWeek.tuesday", comment: "Full name of Tuesday")
        case 4:
            return NSLocalizedString("schedule.dayOfWeek.wednesday", comment: "Full name of Wednesday")
        case 5:
            return NSLocalizedString("schedule.dayOfWeek.thursday", comment: "Full name of Thursday")
        case 6:
            return NSLocalizedString("schedule.dayOfWeek.friday", comment: "Full name of Friday")
        case 7:
            return NSLocalizedString("schedule.dayOfWeek.saturday", comment: "Full name of Saturday")
        default:
            return ""
        }
    }
    
    static func getDay(by index: Int) -> DayOfWeek? {
        DayOfWeek.allCases.first {
            $0.getIndexOfCase() == index
        }
    }
}
