//
//  DonateList.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 27/07/1943 Saka.
//

import Foundation

struct DonateList {
    
    var activity_id:String! = ""
    var activity_name:String! = ""
    var desc:String! = ""
    var activity_image:String! = ""
    var joined_members:String! = ""
    var fundRaise:String? = ""
    var fund_donate:String? = ""
    var created_by:String! = ""
    var creator_pic:String! = ""
    var days_left:String! = ""
    
    init(activity_id: String!,activity_name: String!, desc: String!, activity_image: String!, joined_members: String!, fundRaise: String?, fund_donate: String?, createdby: String?, creatorPic:String?, daysLeft:String?) {
       
        self.activity_id = activity_id
        self.activity_name = activity_name
        self.desc = desc
        self.activity_image = activity_image
        self.joined_members = joined_members
        self.fundRaise = fundRaise
        self.fund_donate = fund_donate
        self.created_by = createdby
        self.creator_pic = creatorPic
        self.days_left = daysLeft
    }

}
