//
//  ProfileModel.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 27/08/1943 Saka.
//

import Foundation

struct ProfileModel : Decodable {
    let code : String?
    var msg : [ProfileMsg]?
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        msg = try values.decodeIfPresent([ProfileMsg].self, forKey: .msg)
    }
}

struct ProfileMsg : Decodable {
    let id : String?
    let fb_id : String?
    let user_info : User_info?
    let user_videos : [Sections_videos]?
    let team_videos : [Sections_videos]?
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
        case user_videos = "user_videos"
        case team_videos = "team_videos"
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
        user_videos = try values.decodeIfPresent([Sections_videos].self, forKey: .user_videos)
        team_videos = try values.decodeIfPresent([Sections_videos].self, forKey: .team_videos)
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
