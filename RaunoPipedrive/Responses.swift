import Foundation

// https://developers.pipedrive.com/docs/api/v1/Persons
// Unused fields have been omitted
struct PersonsResponse: Decodable {
    private let data: [PersonResponse]

    private struct PersonsDataResponse: Decodable {
        let person: PersonResponse
    }

    struct PersonResponse: Codable, Identifiable {
        let id = UUID()
        let personId: Int
        let name: String?
        let email: [Email]
        let phone: [Phone]

        private enum CodingKeys: String, CodingKey {
            case personId = "id"
            case name, email, phone
        }

        struct Email: Codable {
            let label: String?
            let value: String?
            let primary: Bool
        }

        struct Phone: Codable {
            let label: String?
            let value: String?
            let primary: Bool
        }
    }

    var persons: [PersonListViewModel.Person] {
        data.map { response in
            PersonListViewModel.Person(
                id: response.personId,
                name: response.name,
                email: response.email.first?.value,
                phone: response.phone.first?.value
            )
        }
    }
}
