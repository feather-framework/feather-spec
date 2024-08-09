import OpenAPIRuntime
import HTTPTypes

/// A struct that represents a body for an API request.
/// It conforms to the `SpecBuilderParameter` protocol and sets the body of the specification.
public struct Body: SpecBuilderParameter {

    /// The body of the API request.
    public var body: HTTPBody

    /// Initializes a new instance of `Body` with the provided `HTTPBody`.
    /// - Parameter body: The HTTP body to be set in the specification.
    public init(_ body: HTTPBody) {
        self.body = body
    }

    /// Sets the body of the specification to the provided `HTTPBody`.
    /// - Parameter spec: An inout parameter of type `Spec` that is modified to include the body.
    public func build(_ spec: inout Spec) {
        spec.setBody(body)
    }
}
