//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Антон Кашников on 18/09/2023.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "e1917001-8f0b-46d2-8928-c08e8a10fe2b") else {
            return
        }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: String, params: [AnyHashable: Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
}
