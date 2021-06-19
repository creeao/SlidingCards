//
//  AuthService.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//
//
//import Foundation
//import Combine
//
//protocol AuthService {
//    func auth() -> AnyPublisher<DefaultAuthService.Response, Error>
//}
//
//struct DefaultAuthService: AuthService {
//    struct Response: Decodable {
//        let authorized: Bool
//        let user: User?
//        
//        struct User: Decodable {
//            let firstName: String
//            let lastName: String
//        }
//    }
//
//    struct ServiceError: Decodable, Error {
//        let message: String
//    }
//    
//    private let networkManager: NetworkManager
//    
//    init(networkManager: NetworkManager) {
//        self.networkManager = networkManager
//    }
//    
//    func auth() -> AnyPublisher<Response, Error> {
//        networkManager.publisher(
//            for: URLRequest(url: URL(string: "nothttps://netguru.com/api/authMeInPlease")!)
//        )
//    }
//}
//
//protocol NetworkManager {
//    var session: NetworkSession { get }
//    func publisher<T: Decodable>(for request: URLRequest) -> AnyPublisher<T, Error>
//}
//
//private extension NetworkManager {
//    func makePublisher<T: Decodable>(request: URLRequest) -> AnyPublisher<T, Error> {
//        session.publisher(for: request)
//            .decode(type: T.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
//}
//
//struct DefaultNetworkManager: NetworkManager {
//    private(set) var session: NetworkSession
//    
//    init(session: NetworkSession) {
//        self.session = session
//    }
//    
//    func publisher<T: Decodable>(for request: URLRequest) -> AnyPublisher<T, Error> {
//        makePublisher(request: request)
//    }
//}
//
//protocol NetworkSession: AnyObject {
//    func publisher(for  request: URLRequest) -> AnyPublisher<Data, Error>
//}
//
//final class MockNetworkSession: NetworkSession {
//    var shouldAuthorizeStub: Bool?
//    
//    func publisher(for request: URLRequest) -> AnyPublisher<Data, Error> {
//        #if DEBUG
//        
//        let statusCode: Int
//        let data: Data
//        
//        switch request.url?.absoluteString {
//        case "nothttps://netguru.com/api/authMeInPlease":
//            let path: String?
//            let shouldAuthorizeValue = shouldAuthorizeStub ?? Bool.random()
//            
//            switch shouldAuthorizeValue {
//            case true:
//                path = Bundle.main.path(forResource: "AuthService+positiveResponse", ofType: "json")
//            case false:
//                path = Bundle.main.path(forResource: "AuthService+negativeResponse", ofType: "json")
//            }
//            data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
//
//            statusCode = 200
//        case _:
//            data = """
//            {
//              "errors": ["invalid_request"]
//            }
//            """.data(using: .utf8)!
//            statusCode = 500
//        }
//        
//        let response
//            = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
//        return Deferred {
//            Future { promise in
//                DispatchQueue.global().asyncAfter(deadline: .now(), execute: {
//                    promise(.success((data: data, response: response)))
//                })
//            }
//        }
//        .setFailureType(to: URLError.self)
//        .tryMap({ result in
//            guard result.response.statusCode >= 200 && result.response.statusCode < 300 else {
//                let error = try JSONDecoder().decode(DefaultAuthService.ServiceError.self, from: result.data)
//                throw error
//            }
//            return result.data
//        })
//        .eraseToAnyPublisher()
//        
//        #else
//        
//        fatalError("\(String(describing: self)) cannot be used on production")
//        
//        #endif
//    }
//}
