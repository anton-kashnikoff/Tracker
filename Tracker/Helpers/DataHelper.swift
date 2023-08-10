//
//  DataHelper.swift
//  Tracker
//
//  Created by Антон Кашников on 07.08.2023.
//

import Foundation

final class DataHelper {
    var trackersViewController: TrackersViewController?
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) {
        guard let trackersViewController else {
            print("addTracker - Unable to find TrackersViewController")
            return
        }
        
        // If the created category already exists
        if let indexOfExistingCategory = trackersViewController.categories.firstIndex(where: { trackerCategory in
            trackerCategory.name == category.name
        }) {
            trackersViewController.categories[indexOfExistingCategory].trackers.append(tracker)
        } else {
            trackersViewController.categories.append(category)
        }
    }
    
    func checkTrackerRecordForDate(_ date: Date, id: UUID) -> TrackerRecordState {
        guard let trackersViewController else {
            print("checkTrackerRecordForDate - Unable to find TrackersViewController")
            return .notExist
        }
        
        let listOfDatesForTracker = trackersViewController.datesForCompletedTrackers[id]
        
        print("date = \(date)") // текущая дата в пикере
        
        // if array of dates for this tracker already exists (for one or several dates this tracker has been completed)
        if let listOfDatesForTracker {
            
            // если listOfDatesForTracker содержит текущую дату, то
            // при отображении кнопка-галочка, текст = кол-во дат в массиве для этого трекера
            // при нажатии кнопку нужно поменять на плюс, удалить запись для этой даты и поменять текст на актуальное кол-во дат в массиве для этого трекера
            
            
            // if this tracker has been already mapped as completed for this date
            if listOfDatesForTracker.contains(date) {
                return .existForDate
                
            // if this tracker has been mapped as completed for another date
            } else {
                
                // если listOfDatesForTracker не содержит текущую дату, но содержит какие-то другие даты, то
                // при отображении кнопка-плюсик, текст = кол-во дат в массиве для этого трекера
                // при нажатии поменять кнопку на галочку, сделать запись для этой даты и поменять текст на актуальное кол-во дат в массиве для этого трекера
                
                return .existForAnotherDate
            }
        
        }
        // if this tracker never mapped as completed (for any date)
        
        // если listOfDatesForTracker не содержит ни одной записи для этого трекера, то
        // при отображении кнопка-плюсик, текст = кол-во дат в массиве для этого трекера, то есть 0
        // при нажатии кнопку поменять на галочку, сделать запись для этой даты и поменять текст на актуальное кол-во дат в массиве для этого трекера, то есть 1
        return .notExist
    }
    
    func toggleTrackerRecord(_ trackerRecord: TrackerRecord, trackerRecordState: TrackerRecordState) {
        guard let trackersViewController else {
            print("toggleTrackerRecord - Unable to find TrackersViewController")
            return
        }
        
        switch trackerRecordState {
        case .existForDate:
            // удалять нужно не весь трекер, а только одну дату (текущую)
            if var listOfDatesForTracker = trackersViewController.datesForCompletedTrackers[trackerRecord.id] {
                guard let indexOfDateToRemove = listOfDatesForTracker.firstIndex(where: { date in
                    date == trackerRecord.date
                }) else {
                    print("Unable to find index of date to remove")
                    return
                }
                
                listOfDatesForTracker.remove(at: indexOfDateToRemove)
                trackersViewController.datesForCompletedTrackers[trackerRecord.id] = listOfDatesForTracker
            }
            
            print("Removed record for this date")
        case .existForAnotherDate:
            if var listOfDatesForTracker = trackersViewController.datesForCompletedTrackers[trackerRecord.id] {
                listOfDatesForTracker.append(trackerRecord.date)
                trackersViewController.datesForCompletedTrackers.updateValue(listOfDatesForTracker, forKey: trackerRecord.id)
                print("Added record for this date")
            }
            
        case .notExist:
            trackersViewController.datesForCompletedTrackers.updateValue([trackerRecord.date], forKey: trackerRecord.id)
            print("Added first record for this tracker")
        }
        
        
        for (key, value) in trackersViewController.datesForCompletedTrackers {
            for date in value {
                print("Tracker ID: \(key). Date: \(date)")
            }
        }
    }
    
    func getCountOfCompletedDaysForTracker(_ trackerID: UUID) -> Int? {
        guard let trackersViewController else {
            print("getCountOfCompletedDaysForTracker - Unable to find TrackersViewController")
            return nil
        }
        
        guard let trackerElement = trackersViewController.datesForCompletedTrackers.first(where: { key, value in
            key == trackerID
        }) else {
            print("Unable to find element for tracker id = \(trackerID)")
            return nil
        }
        
        return trackerElement.value.count
    }
    
    func fillArray(for date: Date) {
        guard let trackersViewController else {
            print("fillArray - Unable to find TrackersViewController")
            return
        }
        
        let dayOfWeek = Calendar.current.dateComponents([.weekday], from: date).weekday ?? -1
        trackersViewController.categoriesToShow.removeAll()
        
        for category in trackersViewController.categories {
            var trackers = [Tracker]()
            
            for tracker in category.trackers {
                for day in tracker.schedule.daysOfWeek {
                    if day.getNumberOfDay() == dayOfWeek {
                        trackers.append(tracker)
                    }
                }
            }
            
            if !trackers.isEmpty {
                trackersViewController.categoriesToShow.append(TrackerCategory(name: category.name, trackers: trackers))
            }
        }
        
        print("SHOWTRACKERFORDATE")
        print("categories")
        print(trackersViewController.categories)
        print("categoriesToShow")
        print(trackersViewController.categoriesToShow)
        print("searchedCategories")
        print(trackersViewController.searchedCategories)
        
    }
    
    func fillArray(for text: String) {
        guard let trackersViewController else {
            print("fillArray - Unable to find TrackersViewController")
            return
        }
        
        trackersViewController.searchedCategories.removeAll()
        
        for category in trackersViewController.categoriesToShow {
            var trackers = [Tracker]()
            
            for tracker in category.trackers {
                if tracker.name.lowercased().starts(with: text.lowercased()) {
                    trackers.append(tracker)
                }
            }
            
            if !trackers.isEmpty {
                trackersViewController.searchedCategories.append(TrackerCategory(name: category.name, trackers: trackers))
            }
        }
        
        print("SHOWSEARCHEDTRACKERS")
        print("categories")
        print(trackersViewController.categories)
        print("categoriesToShow")
        print(trackersViewController.categoriesToShow)
        print("searchedCategories")
        print(trackersViewController.searchedCategories)
    }
}
