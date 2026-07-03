//
//  ProfileUpdateDto.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 28.06.2026.
//

import Foundation

struct ProfileUpdateDto: Dto {
    let name: String
    let description: String
    let website: String
    let avatar: String
    
    func asDictionary() -> [String: String] {
        return [
            "name": name,
            "description": description,
            "website": website,
            "avatar": avatar
        ]
    }
}
