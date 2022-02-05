//
//  BaseService.swift
//  assignment-innov
//
//  Created by Benjamin on 04/02/2022.
//

import Foundation
import Alamofire

enum ApiError: Error {
    case sessionExpired         // Status code 401
    case notFound               // Status code 404
    case internalServerError    // Status code 500
    case noInternetError        // noInternetError

    var statusCode: Int {
        switch self {
        case .sessionExpired:
            return 401
        case .notFound:
            return 404
        case .internalServerError:
            return 500
        case .noInternetError:
            return 999999
        }
    }

    var defaultMessage: String {
        switch self {
        case .sessionExpired:
            return "Session is expired. Please login again."
        case .notFound:
            return "API not found."
        case .internalServerError:
            return "Internal Server Error. Please check with backend team."
        case .noInternetError:
            return "No internet connection."
        }
    }
}

class BaseService {
    private func request<T: Decodable> (_ url: String, completion: @escaping (AFResult<T>?, Bool, String) -> Void){
        // Create an RxSwift observable, which will be the one to call the request when subscribed to
        AF.request(url).validate().responseDecodable { (response: AFDataResponse<T>) in
            switch response.response?.statusCode {
            case 200:
                completion(response.result, true, "Success")
                break
            case ApiError.sessionExpired.statusCode:
                completion(nil, false, ApiError.sessionExpired.defaultMessage)
                break
            case ApiError.notFound.statusCode:
                completion(nil, false, ApiError.notFound.defaultMessage)
                break
            case ApiError.internalServerError.statusCode:
                completion(nil, false, ApiError.internalServerError.defaultMessage)
                break
            default:
                completion(nil, false, ApiError.noInternetError.defaultMessage)
                break
            }
        }
    }
    
    func getPosts(completion: @escaping (AFResult<[Post]>?, Bool, String) -> Void) {
        request("https://jsonplaceholder.typicode.com/posts", completion: completion)
    }
    
    func getComments(id: Int ,completion: @escaping (AFResult<[Comment]>?, Bool, String) -> Void) {
        request("https://jsonplaceholder.typicode.com/posts/\(id)/comments", completion: completion)
    }
}
