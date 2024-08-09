import HTTPTypes

extension Spec {

    /// An enumeration that represents errors that can occur in a Spec context.
    public enum Failure: Error {
        /// Represents an error that occurs due to a missing HTTP header.
        /// - Parameter: HTTPField.Name - The name of the HTTP field that caused the error.
        case header(HTTPField.Name)

        /// Represents an error that occurs due to an issue with the HTTP response status code.
        /// - Parameter: HTTPResponse.Status - The HTTP status code that caused the error.
        case status(HTTPResponse.Status)
    }
}
