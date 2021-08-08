//
//  UserDataResponse.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 8/5/21.
//

import Foundation

struct UserDataResponse : Decodable
{
//    let last_name : String
//    let first_name: String
    let _image_url : String?
    
    
}



//Example JSON
/*

{"last_name":"Moen","social_accounts":[],"mailing_address":null,"_cohort_keys":[],"signature":null,"_stripe_customer_id":null,"guard":{},"_facebook_id":null,"timezone":null,"site_preferences":null,"occupation":null,"_image":null,"first_name":"Magdalena","jabber_id":null,"languages":null,"_badges":[],"location":null,"external_service_password":null,"_principals":[],"_enrollments":[],"email":{"address":"magdalena.moen@onthemap.udacity.com","_verified":true,"_verification_code_sent":true},"website_url":null,"external_accounts":[],"bio":null,"coaching_data":null,"tags":[],"_affiliate_profiles":[],"_has_password":true,"email_preferences":null,"_resume":null,"key":"7077093298S6671d90e8cb17037b1db5008a6b8fce7","nickname":"Magdalena Moen","employer_sharing":false,"_memberships":[],"zendesk_id":null,"_registered":false,"linkedin_url":null,"_google_id":null,"_image_url":"https://robohash.org/udacity-7077093298S6671d90e8cb17037b1db5008a6b8fce7"}
*/
