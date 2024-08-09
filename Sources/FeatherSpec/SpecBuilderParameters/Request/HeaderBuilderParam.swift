import HTTPTypes

/// A struct that represents a header for an API request.
/// It conforms to the `SpecBuilderParameter` protocol and sets the header in the specification.
public struct Header: SpecBuilderParameter {

    /// The name of the HTTP header field.
    let name: HTTPField.Name

    /// The value of the HTTP header field.
    let value: String

    /// Initializes a new instance of `Header` with the provided name and value.
    /// - Parameters:
    ///   - name: The name of the HTTP header field.
    ///   - value: The value of the HTTP header field.
    public init(_ name: HTTPField.Name, _ value: String) {
        self.name = name
        self.value = value
    }

    /// Sets the header of the specification with the provided name and value.
    /// - Parameter spec: An inout parameter of type `Spec` that is modified to include the header.
    public func build(_ spec: inout Spec) {
        spec.setHeader(name, value)
    }
}
