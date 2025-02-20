//
//  DataHelper.swift
//  Tracker
//
//  Created by Антон Кашников on 16/09/2023.
//

import UIKit

enum DataHelperError: Error {
    case failedToCreateTracker
    case failedToGetCategory
    case failedToFindDaysOfWeek
}

struct TrackerData {
    var id: UUID?
    var name: String?
    var color: UIColor?
    var emoji: String?
    var schedule: Schedule?
}

struct DayOfWeek: Hashable {
    let index: Int
    let day: Schedule.DayOfWeek
    let isSelected: Bool
}

final class DataHelper {
    private var tracker = TrackerData()
    private var category: TrackerCategoryCoreData?
    private var daysOfWeek: Set<DayOfWeek>?
    
    func addCategory(_ category: TrackerCategoryCoreData?) {
        self.category = category
    }
    
    func addID() {
        if tracker.id == nil {
            tracker.id = UUID()
        }
    }
    
    func addName(_ name: String?) {
        tracker.name = name
    }
    
    func addColor(color: UIColor?) {
        tracker.color = color
    }
    
    func addEmoji(emoji: String?) {
        tracker.emoji = emoji
    }
    
    func addSchedule(schedule: Schedule) {
        tracker.schedule = schedule
    }
    
    func getTracker() throws -> Tracker {
        guard let id = tracker.id, let name = tracker.name, let color = tracker.color, let emoji = tracker.emoji, let schedule = tracker.schedule else {
            throw DataHelperError.failedToCreateTracker
        }
        
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
    }
    
    func isDataForTrackerReady(_ trackerType: TrackerType) -> Bool {
        switch trackerType {
        case .habit:
            return tracker.name != nil && tracker.emoji != nil && tracker.color != nil && tracker.schedule != nil && category?.name != nil
        case .irregularEvent:
            return tracker.name != nil && tracker.emoji != nil && tracker.color != nil && category?.name != nil
        }
    }
    
    func getCategoryObject() throws -> TrackerCategoryCoreData {
        guard let category else {
            throw DataHelperError.failedToGetCategory
        }
        
        return category
    }
    
    func getCategoryName() throws -> String {
        guard let categoryName = category?.name else {
            throw DataHelperError.failedToGetCategory
        }
        
        return categoryName
    }
    
    func fillEmptyDaysOfWeek() {
        daysOfWeek = []
        for i in 0...6 {
            daysOfWeek?.insert(DayOfWeek(index: i, day: Schedule.DayOfWeek.allCases[i], isSelected: false))
        }
    }
    
    func getDaysOfWeekString() throws -> String {
        var selectedDays = [String]()
        
        guard let daysOfWeek else {
            throw DataHelperError.failedToFindDaysOfWeek
        }
        
        for day in daysOfWeek {
            if day.isSelected {
                selectedDays.append(day.day.getBriefDayOfWeek())
            }
        }
        
        return selectedDays.count == 7 ? NSLocalizedString("newTracker.schedule.everyDay", comment: "String for all selected days of week") : selectedDays.joined(separator: ", ")
    }
    
    func addDaysOfWeekFromTracker(_ days: Set<Schedule.DayOfWeek>) {
        for dayCase in Schedule.DayOfWeek.allCases {
            daysOfWeek?.insert(DayOfWeek(index: dayCase.getIndexOfCase(), day: dayCase, isSelected: days.contains(dayCase)))
        }
    }
    
    func createSchedule() throws -> Set<Schedule.DayOfWeek> {
        guard let daysOfWeek else {
            throw DataHelperError.failedToFindDaysOfWeek
        }
        
        var selectedDays = Set<Schedule.DayOfWeek>()
        
        for day in daysOfWeek {
            if day.isSelected {
                selectedDays.insert(day.day)
            }
        }
        
        return selectedDays
    }
    
    func getDayOfWeek(_ index: Int) throws -> DayOfWeek {
        guard let dayOfWeek = daysOfWeek?.first(where: {
            $0.index == index
        }) else {
            throw DataHelperError.failedToFindDaysOfWeek
        }
        
        return dayOfWeek
    }
    
    func addDayOfWeek(index: Int, isSelected: Bool) {
        guard let dayToRemove = daysOfWeek?.first(where: { dayOfWeek in
            dayOfWeek.index == index
        }) else {
            return
        }
        
        daysOfWeek?.remove(dayToRemove)
        daysOfWeek?.insert(DayOfWeek(index: index, day: Schedule.DayOfWeek.allCases[index], isSelected: isSelected))
    }
}
