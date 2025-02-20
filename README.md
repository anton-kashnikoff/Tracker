# Tracker

Tracker is an iOS application designed to help users build and maintain good habits by tracking their progress over time.

## Features & Goals
- **Daily Habit Tracking** – Users can schedule and monitor habits on specific days of the week.
- **Progress Monitoring** – The app provides statistics to visualize habit completion trends.

## Screenshots
<img src="https://github.com/user-attachments/assets/252b0e2a-38e0-4ad5-bf84-056e89c81619" width="250">
<img src="https://github.com/user-attachments/assets/ef10ebc3-ed35-43ed-baaf-f934179c3aff" width="250">
<img src="https://github.com/user-attachments/assets/adf990af-36a9-470b-8e14-a1f1b778befa" width="250">
<img src="https://github.com/user-attachments/assets/9ec5332b-0ad5-4dc3-bad0-f989946ec5ed" width="250">
<img src="https://github.com/user-attachments/assets/07c5e693-3d0b-4417-8fb7-e7fd170f9a70" width="250">

## App Overview
- The app consists of **tracker cards** created by the user. Each tracker includes a **name, category, and schedule**. Users can also customize their trackers with **emojis and colors**.
- **Trackers are categorized** for easy navigation. Users can **search and filter** trackers to quickly find what they need.
- A built-in **calendar** allows users to view their planned habits for specific days.
- The **statistics section** provides insights into progress, success rates, and averages.

## Installation Guide
To enable crash tracking, add the following dependency to your project's `Podfile`:

```ruby
pod 'AppMetricaCore', '~> 5.9.0'
```
Then, run:

```bash
pod install
```
System Requirements
* Swift 5+
* iOS 13.4+

**Dependencies:**
* [AppMetrica](https://github.com/appmetrica/appmetrica-sdk-ios)
* [swift-syntax](https://github.com/apple/swift-syntax.git)
* [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing)

**Technology Stack:**
* UIKit: UICollectionView, UITabBarController, UINavigationController
* Concurrency: GCD (Grand Central Dispatch)
* Networking: HTTP requests (URLSession), REST API
* Architecture: MVVM
* Persistence: CoreData
* Testing: Snapshot tests (swift-snapshot-testing)
* Analytics: AppMetrica

**Future Improvements:**
* Widget support for quick habit tracking
* iCloud sync for cross-device habit tracking
* Dark mode support
* Customizable notifications for reminders
