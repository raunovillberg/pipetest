import SwiftUI

@main
struct RaunoPipedriveApp: App {
    static let baseUrlString = "https://api.pipedrive.com/v1/"
    static let apiToken = "PLACE YOUR TOKEN HERE"

    var body: some Scene {
        WindowGroup {
            PersonListView()
        }
    }
}
