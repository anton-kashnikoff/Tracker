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
        
        // if array of dates for this tracker already exists (for one or several dates this tracker has been completed)
        if let listOfDatesForTracker {
            if listOfDatesForTracker.contains(date) {
                return .existForDate
                
            // if this tracker has been mapped as completed for another date
            } else {
                return .existForAnotherDate
            }
        
        }
        // if this tracker never mapped as completed (for any date)
        return .notExist
    }
    
    func toggleTrackerRecord(_ trackerRecord: TrackerRecord, trackerRecordState: TrackerRecordState) {
        guard let trackersViewController else {
            print("toggleTrackerRecord - Unable to find TrackersViewController")
            return
        }
        
        switch trackerRecordState {
        case .existForDate:
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
    }
}
