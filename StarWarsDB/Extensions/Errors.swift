import Foundation

enum APIError: Error {
    case unexpectedResponse
    case cantCreateBaseUrl
    case cantCreateRelativeUrl
    case cantCreateNextPageComponents
    case cantCreateNextPage
}

enum CoreDataError: Error {
    case cantCreateEntity(String)
}
