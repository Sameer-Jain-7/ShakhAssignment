//
//  VideoModal.swift
//  AssignmentShakh
//
//  Created by Sameer Jain on 06/08/24.
//

import Foundation


struct ReelsResponse: Codable {
    let reels: [Reel]
}

struct Reel: Codable {
    let arr: [Video]
}

struct Video: Codable {
    let _id: String
    let video: String
    let thumbnail: String
}

