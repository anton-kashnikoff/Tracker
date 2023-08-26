//
//  DataHelper.swift
//  Tracker
//
//  Created by Антон Кашников on 07.08.2023.
//

import Foundation
//
//final class DataHelper {
//    weak var trackersViewController: TrackersViewController?
    
//    func addTracker(_ tracker: Tracker, to category: TrackerCategory) {
//        guard let trackersViewController else {
//            print("addTracker - Unable to find TrackersViewController")
//            return
//        }
//        
//        // If the created category already exists
//        if let indexOfExistingCategory = trackersViewController.categories.firstIndex(where: { trackerCategory in
//            trackerCategory.name == category.name
//        }) {
//            trackersViewController.categories[indexOfExistingCategory].trackers.append(tracker)
//        } else {
//            trackersViewController.categories.append(category)
//        }
//    }
    
//    func toggleTrackerRecord(_ trackerRecord: TrackerRecord, trackerRecordState: TrackerRecordState) {
//        guard let trackersViewController else {
//            print("toggleTrackerRecord - Unable to find TrackersViewController")
//            return
//        }
//        
//        switch trackerRecordState {
//        case .existForDate:
//            if var listOfDatesForTracker = trackersViewController.datesForCompletedTrackers[trackerRecord.id] {
//                guard let indexOfDateToRemove = listOfDatesForTracker.firstIndex(where: { date in
//                    date == trackerRecord.date
//                }) else {
//                    print("Unable to find index of date to remove")
//                    return
//                }
//                
//                listOfDatesForTracker.remove(at: indexOfDateToRemove)
//                trackersViewController.datesForCompletedTrackers[trackerRecord.id] = listOfDatesForTracker
//            }
//            
//            print("Removed record for this date")
//        case .existForAnotherDate:
//            if var listOfDatesForTracker = trackersViewController.datesForCompletedTrackers[trackerRecord.id] {
//                listOfDatesForTracker.append(trackerRecord.date)
//                trackersViewController.datesForCompletedTrackers.updateValue(listOfDatesForTracker, forKey: trackerRecord.id)
//                print("Added record for this date")
//            }
//            
//        case .notExist:
//            trackersViewController.datesForCompletedTrackers.updateValue([trackerRecord.date], forKey: trackerRecord.id)
//            print("Added first record for this tracker")
//        }
//    }
    
//    func getCountOfCompletedDaysForTracker(_ trackerID: UUID) -> Int? {
//        guard let trackersViewController else {
//            print("getCountOfCompletedDaysForTracker - Unable to find TrackersViewController")
//            return nil
//        }
//        
//        guard let trackerElement = trackersViewController.datesForCompletedTrackers.first(where: { key, value in
//            key == trackerID
//        }) else {
//            print("Unable to find element for tracker id = \(trackerID)")
//            return nil
//        }
//        
//        return trackerElement.value.count
//    }
//}
