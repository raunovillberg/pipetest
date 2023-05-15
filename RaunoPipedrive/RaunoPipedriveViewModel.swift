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
    private let decoder = JSONDecoder()

    @Published public private(set) var items = [Person]()
    private var fetchPersonsTask: AnyCancellable?
    private var fetchPersonDetailsTask: AnyCancellable?

    override init() {
        super.init()

        fetchPersonsTask = fetchPersons().sink {
            print ("completion: \($0)")
        } receiveValue: {
            self.items = $0
        }
    }

    private func fetchPersons(start: Int = 0) -> AnyPublisher<[Person], Error> {
        let urlString = baseUrlString
        + "persons?"
        + "start=\(start)"
        + "&api_token=\(apiToken)"

        // One might argue for using a forced unwrap here, because maybe we *do* want to crash
        // in case our URL String is somehow badly malformed here.
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: AllPersonsResponse.self, decoder: decoder)
            .map(\.persons)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func onContactTapped(_ person: Person) {
        print("onContactTapped: \(person)")

        fetchPersonDetailsTask = fetchPersonDetails(id: person.id).sink {
            print ("completion: \($0)")
        } receiveValue: {
            print("TODO: Open detail view")
            print($0)
        }
    }

    private func fetchPersonDetails(id: Int) -> AnyPublisher<Person, Error> {
        let urlString = baseUrlString
        + "persons?"
        + "id=\(id)"
        + "&api_token=\(apiToken)"
        print(urlString)

        // One might argue for using a forced unwrap here, because maybe we *do* want to crash
        // in case our URL String is somehow badly malformed here.
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PersonDetailsResponse.self, decoder: decoder)
            .compactMap(\.person)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
