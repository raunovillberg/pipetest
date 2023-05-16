import Foundation
import Combine
import SwiftUI

@MainActor
final class PersonDetailsViewModel: NSObject, ObservableObject {
    struct Details {
        let name: String
        let organization: String?
        let email: [Email]
        let phone: [Phone]
        let pictureUrl: URL?

        struct Email: Identifiable {
            let id = UUID()
            let address: String
            let label: String
        }

        struct Phone: Identifiable {
            let id = UUID()
            let number: String
            let label: String
        }
    }

    @Published public private(set) var details: Details?
    @Published public private(set) var error: String?

    private var fetchPersonDetailsTask: AnyCancellable?

    func onViewAppeared(id: Int) {
        fetchPersonDetailsTask = fetchPersonDetails(id: id).sink { result in
            switch result {
            case .failure(let error):
                self.error = error.localizedDescription
            default:
                self.error = nil
            }
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
                    name: data.name.fallbackIfEmptyOrWhitespace(to: "Anonymous"),
                    organization: data.orgName,
                    email: data.email.compactMap({ email in
                        guard let address = email.value,
                              address.isNotEmptyOrWhitespace else {
                            return nil
                        }
                        var label = email.label.fallbackIfEmptyOrWhitespace(to: "unlabeled")
                        if email.primary {
                            // Maybe only add this label if we have more than one value?
                            label.append(" (primary)")
                        }
                        return Details.Email(
                            address: address,
                            label: label
                        )
                    }),
                    phone: data.phone.compactMap({ phone in
                        guard let number = phone.value,
                              number.isNotEmptyOrWhitespace else {
                            return nil
                        }
                        var label = phone.label.fallbackIfEmptyOrWhitespace(to: "unlabeled")
                        if phone.primary {
                            label.append(" (primary)")
                        }
                        return Details.Phone(
                            number: number,
                            label: label
                        )
                    }),
                    pictureUrl: URL(string: pictureUrlString ?? "")
                )
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
