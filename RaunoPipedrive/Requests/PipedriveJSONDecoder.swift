import Foundation

final class PipedriveJSONDecoder: JSONDecoder {
    override init() {
        super.init()

        keyDecodingStrategy = .convertFromSnakeCase
    }
}
