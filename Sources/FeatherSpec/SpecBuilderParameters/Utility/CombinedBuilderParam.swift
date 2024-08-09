/// A struct that combines multiple `SpecBuilderParameter` instances.
struct Combined: SpecBuilderParameter {

    /// An array of parameters that conform to `SpecBuilderParameter`.
    let params: [SpecBuilderParameter]

    /// Builds the specification by invoking the `build` method of each parameter in the `params` array.
    /// - Parameter spec: An inout parameter of type `Spec` that is modified by the `build` methods of the contained parameters.
    func build(_ spec: inout Spec) {
        // Iterate over each parameter and call its build method, modifying the passed spec.
        params.forEach { $0.build(&spec) }
    }
}
