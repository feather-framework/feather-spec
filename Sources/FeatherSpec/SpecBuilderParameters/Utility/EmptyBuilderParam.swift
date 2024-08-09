/// A struct that represents an empty specification builder.
public struct Empty: SpecBuilderParameter {

    /// A method that conforms to the `SpecBuilderParameter` protocol but does not alter the `spec`.
    /// - Parameter spec: An inout parameter of type `Spec` that remains unchanged.
    public func build(_ spec: inout Spec) {}
}
