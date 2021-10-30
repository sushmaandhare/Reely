//
//  Notificaton.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 06/08/1943 Saka.
//

import Foundation

struct Notificaton {
    
    var fb_id:String? = ""
    var first_name:String? = ""
    var last_name:String? = ""
    var profile_pic:String? = ""
    var username:String? = ""
    var verified:String? = ""
    var effected_fb_id:String? = ""
    var type:String? = ""
    var value:String? = ""
    var video_id:String? = ""
    var activity_id:String? = ""
    var activity_name:String? = ""
    var activity_image:String? = ""
    var donate_points:String? = ""
   
    
    init(fb_id: String?, first_name: String?,last_name: String?, profile_pic: String?, username: String?, verified: String?, effected_fb_id: String?, type: String?, value: String?, video_id: String?, activity_id: String?, activity_name: String?, activity_image: String?, donate_points: String?) {
       
        self.fb_id = fb_id
        self.first_name = first_name
        self.last_name = last_name
        self.profile_pic = profile_pic
        self.username = username
        self.verified = verified
        self.effected_fb_id = effected_fb_id
        self.type = type
        self.value = value
        self.video_id = video_id
        self.activity_id = activity_id
        self.activity_name = activity_name
        self.activity_image = activity_image
        self.donate_points = donate_points
    }

}

