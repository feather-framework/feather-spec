import Foundation
import XCTest
import OpenAPIRuntime
import HTTPTypes
import FeatherOpenAPISpec

enum SomeError: Error {
    case foo
}

struct Todo: Codable {
    let title: String
}

final class FeatherOpenAPISpecTests: XCTestCase {

    func test(using runner: SpecRunner) async throws {
        let body = HTTPBody()

        try await SpecBuilder {
            Method(.post)
            Path("todos")
            Header(.contentType, "application/json")
            Body(body)
            Expectation(.ok)
            Expectation { response, body in

            }
        }
        .build(using: runner)
        .test()

        var spec = Spec(runner: runner)
        spec.setMethod(.post)
        spec.setPath("todos")
        spec.setBody(body)
        spec.setHeader(.contentType, "application/json")
        spec.addExpectation(.ok)
        spec.addExpectation { response, body in

        }
        try await spec.test()

        try await Spec(runner: runner)
            .post("todos")
            .header(.contentType, "application/json")
            .body(body)
            .expect(.ok)
            .expect { response, body in

            }
            .test()
    }
}
