//
//  Schedule.swift
//  Tracker
//
//  Created by Антон Кашников on 02.08.2023.
//

import Foundation

struct Schedule {
    enum DayOfWeek: String, CaseIterable {
        case monday = "Понедельник"
        case tuesday = "Вторник"
        case wednesday = "Среда"
        case thursday = "Четверг"
        case friday = "Пятница"
        case saturday = "Суббота"
        case sunday = "Воскресенье"
        
        func getIndexOfCase() -> Int {
            return Self.allCases.firstIndex {
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
    
    static func getNameOfDay(_ number: Int) -> String {
        switch number {
        case 1:
            return "Воскресенье"
        case 2:
            return "Понедельник"
        case 3:
            return "Вторник"
        case 4:
            return "Среда"
        case 5:
            return "Четверг"
        case 6:
            return "Пятница"
        case 7:
            return "Суббота"
        default:
            return ""
        }
    }
}
