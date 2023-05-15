import Foundation

// https://developers.pipedrive.com/docs/api/v1/Persons#getPersons
// Unused fields have been omitted
struct AllPersonsResponse: Decodable {
    let data: [PersonResponse]

    struct PersonsDataResponse: Decodable {
        let person: PersonResponse
    }

    var persons: [PersonListViewModel.Person] {
        data.map { response in
            response.person
        }
    }
}

// https://developers.pipedrive.com/docs/api/v1/Persons#getPerson
// Unused fields have been omitted
struct PersonDetailsResponse: Decodable {
    private let data: [PersonResponse]

    var person: PersonListViewModel.Person? {
        data.first.map(\.person)
    }
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

    var person: PersonListViewModel.Person {
        PersonListViewModel.Person(
            id: personId,
            name: name,
            email: email.first?.value,
            phone: phone.first?.value
        )
    }
}
