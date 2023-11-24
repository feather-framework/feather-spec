@resultBuilder
public struct SpecBuilder {

    var root: SpecBuilderParameter

    public init(
        @SpecBuilder builder: () -> SpecBuilderParameter
    ) {
        root = builder()
    }

    public func build(
        using runner: SpecRunner
    ) -> Spec {
        var spec = Spec(runner: runner)
        root.build(&spec)
        return spec
    }

    // MARK: - builders

    public static func buildBlock(
        _ params: SpecBuilderParameter...
    ) -> SpecBuilderParameter {
        Combined(params: params)
    }

    public static func buildBlock(
        _ param: SpecBuilderParameter
    ) -> SpecBuilderParameter {
        param
    }

    public static func buildBlock() -> Empty {
        Empty()
    }

    public static func buildIf(
        _ param: SpecBuilderParameter?
    ) -> SpecBuilderParameter {
        param ?? Empty()
    }

    public static func buildEither(
        first: SpecBuilderParameter
    ) -> SpecBuilderParameter {
        first
    }

    public static func buildEither(
        second: SpecBuilderParameter
    ) -> SpecBuilderParameter {
        second
    }
}
