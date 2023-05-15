import Foundation
import Combine
import SwiftUI

@MainActor
final class PersonListViewModel: NSObject, ObservableObject {
    struct Person: Identifiable {
        let id: Int
        let name: String?
        let email: String?
        let phone: String?
    }

    private let baseUrlString = "https://api.pipedrive.com/v1/"
    private let apiToken = "PLACE YOUR TOKEN HERE"

    @Published public private(set) var items = [Person]()
    private var fetchPersonsTask: AnyCancellable?

    override init() {
        super.init()

        fetchPersonsTask = fetchPersons().sink {
            print ("completion: \($0)")
        } receiveValue: {
            self.items = $0
        }
    }

    private func fetchPersons() -> AnyPublisher<[Person], Error> {
        let urlString = baseUrlString
        + "persons?"
        + "&api_token=\(apiToken)"

        // One might argue for using a forced unwrap here, because maybe we *do* want to crash
        // in case our URL String is somehow badly malformed here.
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: AllPersonsResponse.self, decoder: JSONDecoder())
            .map(\.persons)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}