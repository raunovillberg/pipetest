import Foundation
import Combine
import SwiftUI
import Network

@MainActor
final class PersonListViewModel: NSObject, ObservableObject {
    struct ListItem: Identifiable, Codable {
        let id: Int
        let name: String
    }

    // Wrapper object to easily save an array
    struct CachedListItems: Codable {
        let items: [ListItem]
    }

    @Published public private(set) var items: [ListItem]?
    @Published public private(set) var usingCachedData = false
    private var fetchPersonsTask: AnyCancellable?

    private let networkMonitor = NWPathMonitor()

    override init() {
        super.init()

        networkMonitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.items = nil
                    self.usingCachedData = false

                    self.fetchPersonsTask = self.fetchPersons().sink {
                        print ("completion: \($0)")
                    } receiveValue: {
                        self.items = $0
                        self.saveToFile($0)
                    }
                }
            } else if path.status == .unsatisfied {
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.items = self.loadFromCache()
                    self.usingCachedData = true
                }
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        networkMonitor.start(queue: queue)
    }

    private func fetchPersons() -> AnyPublisher<[ListItem], Error> {
        let urlString = RaunoPipedriveApp.baseUrlString
        + "persons?"
        + "&api_token=\(RaunoPipedriveApp.apiToken)"

        // One might argue for using a forced unwrap here, because maybe we *do* want to crash
        // in case our URL String is somehow badly malformed here.
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: AllPersonsResponse.self, decoder: PipedriveJSONDecoder())
            .map(\.data)
            .compactMap({ persons in
                persons.compactMap { person in
                    ListItem(id: person.id, name: person.name ?? "Anonymous")
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func saveToFile(_ listItems: [ListItem]) {
        guard let cachedFilePath = cachedFilePath else { return }
        if let encoded = try? JSONEncoder().encode(CachedListItems(items: listItems)) {
            do {
                try encoded.write(to: cachedFilePath)
            } catch let error {
                // TODO: Actually handle errors here.
                print(error)
            }
        }
    }

    private func loadFromCache() -> [ListItem] {
        guard let cachedFilePath = cachedFilePath else { return [] }
        do {
            let data = try Data(contentsOf: cachedFilePath)
            let cache = try JSONDecoder().decode(CachedListItems.self, from: data)
            return cache.items
        } catch let error {
            // TODO: Actually handle errors here.
            print(error)
        }

        return []
    }

    private var cachedFilePath: URL? {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("cachedPipedriveContacts.json")
    }
}
