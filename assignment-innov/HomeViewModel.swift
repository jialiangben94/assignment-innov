//
//  HomeViewModel.swift
//  assignment-innov
//
//  Created by Benjamin on 04/02/2022.
//

import Foundation
import Alamofire

class HomeViewModel {
    var presenter: UIViewController?
    
    init(present: UIViewController) {
        self.presenter = present
    }
    
    func getPostList(completion: @escaping ([Post]) -> Void) {
        BaseService().getPosts{ (data, success, message) in
            if (success) {
                do {
                    completion(try data?.get() ?? [])
                } catch {
                    completion([])
                }
            } else {
                self.errorHandler(message: message)
                completion([])
            }
        }
    }
    
    func getCommentList(id: Int, completion: @escaping ([Comment]) -> Void) {
        BaseService().getComments(id: id){ (data, success, message) in
            if (success) {
                do {
                    completion(try data?.get() ?? [])
                } catch {
                    completion([])
                }
            } else {
                self.errorHandler(message: message)
                completion([])
            }
        }
    }
    
    func errorHandler(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.presenter?.present(alert, animated: true, completion: nil)
    }
}
