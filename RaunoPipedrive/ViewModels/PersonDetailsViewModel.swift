import Foundation
import Combine
import SwiftUI

@MainActor
final class PersonDetailsViewModel: NSObject, ObservableObject {
    typealias Person = PersonListViewModel.Person

    @Published public private(set) var details: Person?

    private let baseUrlString = "https://api.pipedrive.com/v1/"
    private let apiToken = "PLACE YOUR TOKEN HERE"

    private var fetchPersonDetailsTask: AnyCancellable?

    func onViewAppeared(id: Int) {
        fetchPersonDetailsTask = fetchPersonDetails(id: id).sink {
            print ("completion: \($0)")
        } receiveValue: {
            self.details = $0
        }
    }

    private func fetchPersonDetails(id: Int) -> AnyPublisher<Person, Error> {
        let urlString = baseUrlString
        + "persons/\(id)"
        + "?api_token=\(apiToken)"
        print(urlString)

        // One might argue for using a forced unwrap here, because maybe we *do* want to crash
        // in case our URL String is somehow badly malformed here.
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PersonDetailsResponse.self, decoder: JSONDecoder())
            .compactMap(\.person)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
