//
//  TeamList.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 13/07/1943 Saka.
//

import Foundation

struct TeamList {
    
    var activity_id:String! = ""
    var activity_name:String! = ""
    var desc:String! = ""
    var activity_image:String! = ""
    var joined_members:String! = ""
    var fundRaise:String? = ""
    var fund_donate:Int? = 0
    
    init(activity_id: String!,activity_name: String!, desc: String!, activity_image: String!, joined_members: String!, fundRaise: String?, fund_donate: Int?) {
       
        self.activity_id = activity_id
        self.activity_name = activity_name
        self.desc = desc
        self.activity_image = activity_image
        self.joined_members = joined_members
        self.fundRaise = fundRaise
        self.fund_donate = fund_donate
    }

}

struct TeamMemberList {
    
    var fb_id:String! = ""
    var username:String! = ""
    var verified:String! = ""
    var first_name:String! = ""
    var last_name:String! = ""
    var profile_pic:String! = ""
    var follow_Status:String! = ""
    var my_follow_Status:String! = ""
    
    init(fb_id: String!,username: String!, verified: String!, first_name: String!, last_name: String!, profile_pic: String!, follow_Status: String!, my_follow_Status: String!) {
       
        self.fb_id = fb_id
        self.username = username
        self.verified = verified
        self.first_name = first_name
        self.last_name = last_name
        self.profile_pic = profile_pic
        self.follow_Status = follow_Status
        self.my_follow_Status = my_follow_Status
       
        
    }

}

struct SelfTeamDetails {
    var fb_id:String! = ""
    var activity_name:String! = ""
    var desc:String! = ""
    var activity_image:String! = ""
    var joined_members:String! = ""
    var fundRaise:String? = ""
    var last_date:String? = ""
    var is_verified:String? = ""
    var total_heart:String? = ""
//    var total_video_count:String? = ""
//    var total_like_count:String? = ""
    var userVideo:[UserVideo]
    var fund_donate: String? = ""
    var created_by:String? = ""
    var creator_pic:String? = ""
    var days_left:String? = ""
    
    init(fb_id: String!,activity_name: String!, desc: String!, activity_image: String!, joined_members: String!, fundRaise: String!, last_date: String!, is_verified: String!, total_heart: String!, userVideo: [UserVideo], fund_donate:String!, created_by: String!, creator_pic:String?, days_left:String?) {
       
        self.fb_id = fb_id
        self.activity_name = activity_name
        self.desc = desc
        self.activity_image = activity_image
        self.joined_members = joined_members
        self.fundRaise = fundRaise
        self.last_date = last_date
        self.is_verified = is_verified
        self.total_heart = total_heart
        self.userVideo = userVideo
        self.fund_donate = fund_donate
        self.created_by = created_by
        self.creator_pic = creator_pic
        self.days_left = days_left
       
    }
}

struct UserVideo {
    var v_id:String! = ""
    var video:String! = ""
    var thum:String! = ""
    var description:String? = ""
    var liked:String? = ""
    var likeCount:String? = ""
    var shareCount:String? = ""
    var viewCount:String? = ""
    var commentCount:String? = ""
    var soundId:String? = ""
    var soundName:String? = ""
    var audioPath:String? = ""
    
    init(v_id: String!,video: String!, thum: String!, description: String!, liked: String!, likeCount: String!, shareCount: String!, viewCount: String!, commentCount: String!, soundId: String!, soundName: String!, audioPath: String!) {
       
        self.v_id = v_id
        self.video = video
        self.thum = thum
        self.description = description
        self.liked = liked
        self.likeCount = likeCount
        self.shareCount = shareCount
        self.viewCount = viewCount
        self.commentCount = commentCount
        self.soundId = soundId
        self.soundName = soundName
        self.audioPath = audioPath
    }
}
                

struct Videos {

    var v_id:String! = "0"
    var video:String! = ""
    var thum:String! = ""
    var desc:String! = ""
    var liked:String! = "0"
    var likeCount:String! = "0"
    var shareCount:String! = "0"
    var first_name:String! = ""
    var last_name:String! = ""
    var profile_pic:String! = ""
    var view:String! = "0"
    var u_id:String! = ""
    var approve_status:String! = "0"
    var username:String! = ""




    init(thum: String!,first_name: String!, last_name: String!, profile_pic: String!, v_id: String!, view: String!,u_id: String!, video: String!, desc: String!, username: String!, shareCount: String!, likeCount: String!, liked: String!) {

        self.thum = thum
        self.first_name = first_name
        self.last_name = last_name
        self.profile_pic = profile_pic
        self.v_id = v_id
        self.view = view
        self.u_id = u_id
        self.video = video
        self.desc = desc
        self.username = username
        self.shareCount = shareCount
        self.likeCount = likeCount
        self.liked = liked
    }

}

struct fundDonateMemberList {
    var fb_id:String! = ""
    var username:String! = ""
    var verified:String! = ""
    var first_name:String? = ""
    var last_name:String? = ""
    var profile_pic:String? = ""
    
    init(fb_id: String!,username: String!, verified: String!, first_name: String!, last_name: String!, profile_pic: String!) {
       
        self.fb_id = fb_id
        self.username = username
        self.verified = verified
        self.first_name = first_name
        self.last_name = last_name
        self.profile_pic = profile_pic
        
    }
}
                
