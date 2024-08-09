import Foundation
import OpenAPIRuntime
@testable import FeatherSpec

struct Todo: Codable {
    let title: String
}

extension Todo {

    var httpBody: HTTPBody {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        return HTTPBody(data)
    }
}
