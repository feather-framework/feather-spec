import OpenAPIRuntime
import HTTPTypes
@testable import FeatherSpec

struct Custom: SpecBuilderParameter {
    var expectation: Expectation

    init(
        block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        self.expectation = .init(block: block)
    }

    /// build
    public func build(_ spec: inout Spec) {
        spec.addExpectation(expectation.block)
    }
}
