//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Антон Кашников on 18/09/2023.
//

import AppMetricaCore

struct AnalyticsService {
    private enum Constants: String {
        case metricaAPIKey = "e1917001-8f0b-46d2-8928-c08e8a10fe2b"
    }
    
    static func activate() {
        let configuration = AppMetricaConfiguration(apiKey: Constants.metricaAPIKey.rawValue)
        AppMetrica.activate(with: configuration!)
    }
    
    func report(event: String, params: [AnyHashable: Any]) {
        AppMetrica.reportEvent(name: event, parameters: params) { (error) in
            print("DID FAIL TO REPORT EVENT: %@", event)
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
}
