import Foundation

// https://developers.pipedrive.com/docs/api/v1/Persons#getPersons
struct AllPersonsResponse: Decodable {
    let data: [PersonResponse]

    struct PersonsDataResponse: Decodable {
        let person: PersonResponse
    }
}

// https://developers.pipedrive.com/docs/api/v1/Persons#getPerson
struct GetPersonDetailsResponse: Decodable {
    let data: PersonResponse
}

struct PersonResponse: Codable {
    let id: Int
    let name: String?
    let email: [Email]
    let phone: [Phone]
    let pictureId: Picture?
    let orgName: String?

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

    struct Picture: Codable {
        let pictures: PictureUrls?
        let value: Int

        struct PictureUrls: Codable {
            let small: String?
            let big: String?

            private enum CodingKeys: String, CodingKey {
                case small = "128"
                case big = "512"
            }
        }
    }
}
