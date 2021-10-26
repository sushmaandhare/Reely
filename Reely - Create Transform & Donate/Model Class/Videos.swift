//
//  Videos.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 03/06/1943 Saka.
//

import UIKit

struct VideoModel : Decodable {
    let code : String?
    let msg : [VideoMsg]?
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        msg = try values.decodeIfPresent([VideoMsg].self, forKey: .msg)
    }
}
struct VideoAudio_path : Codable {
    let acc : String?

    enum CodingKeys: String, CodingKey {

        case acc = "acc"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        acc = try values.decodeIfPresent(String.self, forKey: .acc)
    }

}
struct VideoCount : Codable {
    let like_count : String?
    let view : String?
    let share : String?

    enum CodingKeys: String, CodingKey {

        case like_count = "like_count"
        case view = "view"
        case share = "share"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        like_count = try values.decodeIfPresent(String.self, forKey: .like_count)
        view = try values.decodeIfPresent(String.self, forKey: .view)
        share = try values.decodeIfPresent(String.self, forKey: .share)
    }

}

struct VideoMsg : Decodable {
    let section_id : String?
    let section_name : String?
    let section_icon : String?
    let section_views : String?
    let sections_videos : [Sections_videos]?

    enum CodingKeys: String, CodingKey {

        case section_id = "section_id"
        case section_name = "section_name"
        case section_icon = "section_icon"
        case section_views = "section_views"
        case sections_videos = "sections_videos"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        section_id = try values.decodeIfPresent(String.self, forKey: .section_id)
        section_name = try values.decodeIfPresent(String.self, forKey: .section_name)
        section_icon = try values.decodeIfPresent(String.self, forKey: .section_icon)
        section_views = try values.decodeIfPresent(String.self, forKey: .section_views)
        sections_videos = try values.decodeIfPresent([Sections_videos].self, forKey: .sections_videos)
    }

}


struct Sections_videos : Decodable {
    let id : String?
    let video : String?
    let thum : String?
    let description : String?
    var liked : String?
    var count : Count?
    let user_info : User_info?
    let sound : Sound?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case video = "video"
        case thum = "thum"
        case description = "description"
        case liked = "liked"
        case count = "count"
        case user_info = "user_info"
        case sound = "sound"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        video = try values.decodeIfPresent(String.self, forKey: .video)
        thum = try values.decodeIfPresent(String.self, forKey: .thum)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        liked = try values.decodeIfPresent(String.self, forKey: .liked)
        count = try values.decodeIfPresent(Count.self, forKey: .count)
        user_info = try values.decodeIfPresent(User_info.self, forKey: .user_info)
        sound = try values.decodeIfPresent(Sound.self, forKey: .sound)
    }

}

struct Sound : Decodable {
    let id : String?
    let audio_path : Audio_path?
    let sound_name : String?
    let description : String?
    let thum : String?
    let section : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case audio_path = "audio_path"
        case sound_name = "sound_name"
        case description = "description"
        case thum = "thum"
        case section = "section"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        audio_path = try values.decodeIfPresent(Audio_path.self, forKey: .audio_path)
        sound_name = try values.decodeIfPresent(String.self, forKey: .sound_name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        thum = try values.decodeIfPresent(String.self, forKey: .thum)
        section = try values.decodeIfPresent(String.self, forKey: .section)
    }

}


struct VideoSound : Codable {
    let id : String?
    let audio_path : VideoAudio_path?
    let sound_name : String?
    let description : String?
    let thum : String?
    let section : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case audio_path = "audio_path"
        case sound_name = "sound_name"
        case description = "description"
        case thum = "thum"
        case section = "section"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        audio_path = try values.decodeIfPresent(VideoAudio_path.self, forKey: .audio_path)
        sound_name = try values.decodeIfPresent(String.self, forKey: .sound_name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        thum = try values.decodeIfPresent(String.self, forKey: .thum)
        section = try values.decodeIfPresent(String.self, forKey: .section)
    }

}

struct VideoUser_info : Codable {
    let fb_id : String?
    let first_name : String?
    let last_name : String?
    let profile_pic : String?
    let username : String?
    let verified : String?

    enum CodingKeys: String, CodingKey {

        case fb_id = "fb_id"
        case first_name = "first_name"
        case last_name = "last_name"
        case profile_pic = "profile_pic"
        case username = "username"
        case verified = "verified"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fb_id = try values.decodeIfPresent(String.self, forKey: .fb_id)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        verified = try values.decodeIfPresent(String.self, forKey: .verified)
    }

}


struct ItemVideo {
    
    var video:String! = ""
    var thum:String! = ""
    var liked:String! = "0"
    var like_count:String! = "0"
    var video_comment_count:String! = "0"
    var first_name:String = ""
    var last_name:String! = ""
    var profile_pic:String! = ""
    var sound_name:String! = ""
    var v_id:String! = "0"
    var u_id:String! = "0"
    var description:String! = ""
    var view_count:String! = "0"
    var f_name:String = ""
    var audio_url:String = ""
    var s_id:String! = "0"
    var share:String! = "0"
    var totalView :String = ""
    var hashtagIcon : String = ""
    var is_follow:String! = "0"
    
}

struct hashtagList{
       var favourite:String! = "0"
       var hashtag:String! = ""
       var hashtag_id:String! = "0"
       var videos_count:String! = "0"
       var views:String! = "0"
    
   }
