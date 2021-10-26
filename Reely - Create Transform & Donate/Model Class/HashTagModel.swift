//
//  HashTagModel.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 20/07/1943 Saka.
//

import Foundation

struct HashTagModel : Decodable {
    let code : String?
    let msg : [HashTagMsg]?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case msg = "msg"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        msg = try values.decodeIfPresent([HashTagMsg].self, forKey: .msg)
    }

}
struct HashTagMsg : Decodable {
    let section_name : String?
    let section_count : Int?
    let sections_videos : [Sections_videos]?

    enum CodingKeys: String, CodingKey {

        case section_name = "section_name"
        case section_count = "section_count"
        case sections_videos = "sections_videos"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        section_name = try values.decodeIfPresent(String.self, forKey: .section_name)
        section_count = try values.decodeIfPresent(Int.self, forKey: .section_count)
        sections_videos = try values.decodeIfPresent([Sections_videos].self, forKey: .sections_videos)
    }

}







