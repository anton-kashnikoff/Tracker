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
    
    func createTrackerRecord(for tracker: Tracker, date: Date) {
        guard let trackersViewController else {
            print("createTrackerRecord - Unable to find TrackersViewController")
            return
        }
        
        // If the created tracker record already exists
        if trackersViewController.completedTrackers.firstIndex(where: { trackerRecord in
            trackerRecord.id == tracker.id && trackerRecord.date == date
        }) == nil {
            trackersViewController.completedTrackers.append(TrackerRecord(id: tracker.id, date: date))
        }
    }
    
    func deleteTrackerRecord(for tracker: Tracker, date: Date) {
        guard let trackersViewController else {
            print("deleteTrackerRecord - Unable to find TrackersViewController")
            return
        }
        
        if let indexToRemove = trackersViewController.completedTrackers.firstIndex(where: { trackerRecord in
            trackerRecord.id == tracker.id && trackerRecord.date == date
        }) {
            trackersViewController.completedTrackers.remove(at: indexToRemove)
        }
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
