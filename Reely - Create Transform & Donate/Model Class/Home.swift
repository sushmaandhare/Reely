//
//  Home.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 16/06/1943 Saka.
//

import UIKit

struct HomeModel : Decodable {
    let code : String?
    let total_video_count : String?
    var msg : [HomeMsg]?
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case total_video_count = "total_video_count"
        case msg = "msg"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        total_video_count = try values.decodeIfPresent(String.self, forKey: .total_video_count)
        msg = try values.decodeIfPresent([HomeMsg].self, forKey: .msg)
    }
}

struct HomeMsg : Decodable {
    let id : String?
    let fb_id : String?
    let user_info : User_info?
    var count : Count?
    var liked : String?
    let video : String?
    let thum : String?
    let allow_comment : String?
    let allow_duet : String?
    let description : String?
    let is_follow : Int?
    let sound : Sound?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fb_id = "fb_id"
        case user_info = "user_info"
        case count = "count"
        case liked = "liked"
        case video = "video"
        case thum = "thum"
        case allow_comment = "allow_comment"
        case allow_duet = "allow_duet"
        case description = "description"
        case is_follow = "is_follow"
        case sound = "sound"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        fb_id = try values.decodeIfPresent(String.self, forKey: .fb_id)
        user_info = try values.decodeIfPresent(User_info.self, forKey: .user_info)
        count = try values.decodeIfPresent(Count.self, forKey: .count)
        liked = try values.decodeIfPresent(String.self, forKey: .liked)
        video = try values.decodeIfPresent(String.self, forKey: .video)
        thum = try values.decodeIfPresent(String.self, forKey: .thum)
        allow_comment = try values.decodeIfPresent(String.self, forKey: .allow_comment)
        allow_duet = try values.decodeIfPresent(String.self, forKey: .allow_duet)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        is_follow = try values.decodeIfPresent(Int.self, forKey: .is_follow)
        sound = try values.decodeIfPresent(Sound.self, forKey: .sound)
    }
}

struct Audio_path : Decodable {
    let acc : String?
    enum CodingKeys: String, CodingKey {
        case acc = "acc"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        acc = try values.decodeIfPresent(String.self, forKey: .acc)
    }
}
struct Count : Decodable {
    var like_count : String?
    let video_comment_count : String?
    let view : String?
    let share : String?
    enum CodingKeys: String, CodingKey {
        case like_count = "like_count"
        case video_comment_count = "video_comment_count"
        case view = "view"
        case share = "share"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        like_count = try values.decodeIfPresent(String.self, forKey: .like_count)
        video_comment_count = try values.decodeIfPresent(String.self, forKey: .video_comment_count)
        view = try values.decodeIfPresent(String.self, forKey: .view)
        share = try values.decodeIfPresent(String.self, forKey: .share)
    }
}

struct User_info : Decodable {
    let first_name : String?
    let last_name : String?
    let profile_pic : String?
    let username : String?

    enum CodingKeys: String, CodingKey {
        case first_name = "first_name"
        case last_name = "last_name"
        case profile_pic = "profile_pic"
        case username = "username"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        username = try values.decodeIfPresent(String.self, forKey: .username)
    }
}

struct SocialMediaModel : Decodable {
    let code : String?
    let msg : [SocialMediaMsg]?
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        msg = try values.decodeIfPresent([SocialMediaMsg].self, forKey: .msg)
    }
}

struct SocialMediaMsg: Decodable {
    let response : String?

    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response = try values.decodeIfPresent(String.self, forKey: .response)
    }
}


