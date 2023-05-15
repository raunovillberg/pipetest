import Foundation
import Combine
import SwiftUI

@MainActor
final class PersonDetailsViewModel: NSObject, ObservableObject {
    struct Details {
        let name: String?
        let organization: String?
        let email: PersonResponse.Email?
        let phone: PersonResponse.Phone?
        let pictureUrl: URL?
    }

    @Published public private(set) var details: Details?

    private var fetchPersonDetailsTask: AnyCancellable?

    func onViewAppeared(id: Int) {
        fetchPersonDetailsTask = fetchPersonDetails(id: id).sink {
            print ("completion: \($0)")
        } receiveValue: {
            self.details = $0
        }
    }

    private func fetchPersonDetails(id: Int) -> AnyPublisher<Details, Error> {
        let urlString = RaunoPipedriveApp.baseUrlString
        + "persons/\(id)"
        + "?api_token=\(RaunoPipedriveApp.apiToken)"

        // One might argue for using a forced unwrap here, because maybe we *do* want to crash
        // in case our URL String is somehow badly malformed here.
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GetPersonDetailsResponse.self, decoder: PipedriveJSONDecoder())
            .map(\.data)
            .compactMap { data in
                let pictureUrlString: String? = {
                    guard let pictures = data.pictureId?.pictures else { return nil }
                    return pictures.small ?? pictures.big
                }()

                return Details(
                    name: data.name,
                    organization: data.orgName,
                    email: data.email.first,
                    phone: data.phone.first,
                    pictureUrl: URL(string: pictureUrlString ?? "")
                )
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
