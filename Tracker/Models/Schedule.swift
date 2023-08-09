//
//  Schedule.swift
//  Tracker
//
//  Created by Антон Кашников on 02.08.2023.
//

struct Schedule {
    enum DayOfWeek: String, CaseIterable {
        case monday = "Понедельник"
        case tuesday = "Вторник"
        case wednesday = "Среда"
        case thursday = "Четверг"
        case friday = "Пятница"
        case saturday = "Суббота"
        case sunday = "Воскресенье"
        
        func getNumberOfDay() -> Int? {
            let index = Self.allCases.firstIndex {
                self == $0
            } ?? -1
            
            if index == 6 {
                return 1
            }
            
            return index + 2
        }
    }
    
    enum BriefDayOfWeek: String, CaseIterable {
        case monday = "Пн"
        case tuesday = "Вт"
        case wednesday = "Ср"
        case thursday = "Чт"
        case friday = "Пт"
        case saturday = "Сб"
        case sunday = "Вс"
    }
    
    let daysOfWeek: Set<DayOfWeek>
}
