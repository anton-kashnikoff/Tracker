//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Антон Кашников on 18/09/2023.
//

import YandexMobileMetrica

struct AnalyticsService {
    private enum Constants: String {
        case yandexMetricaAPIKey = "e1917001-8f0b-46d2-8928-c08e8a10fe2b"
    }
    
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: Constants.yandexMetricaAPIKey.rawValue) else {
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
