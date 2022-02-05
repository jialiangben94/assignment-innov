//
//  Comment.swift
//  assignment-innov
//
//  Created by Benjamin on 05/02/2022.
//

import Foundation

struct Comment: Decodable {
    let postId: Int?
    let id: Int?
    let name: String
    let email: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case postId
        case id
        case name
        case email
        case body
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postId = try container.decodeIfPresent(Int.self, forKey: .postId)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        body = try container.decodeIfPresent(String.self, forKey: .body) ?? ""
    }
}
