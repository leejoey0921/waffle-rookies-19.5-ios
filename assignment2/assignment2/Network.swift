//
//  Network.swift
//  assignment2
//
//  Created by Joey Lee on 2021/09/22.
//

import Foundation

struct MemberListResponseData: Codable {
    var statusCode: Int
    var body: [Member]
}

struct MemberProfileResponseData: Codable {
    var statusCode: Int
    var body: Member
}

struct Member: Codable {
    var id: Int
    var name: String
    var team: String
    var profile_image: String?
    var lectures: [Lecture]?
}

struct Lecture: Codable {
    var classification: String
    var category: String
    var instructor: String
    var lecture_number: String
    var course_number: String
    var academic_year: String
    var course_title: String
    var credit: Int
    var department: String
}

enum NetworkError {
    case authError
    case serverError
    case parsingError
    
    func getMessage() -> String {
        switch self {
        case .authError: return "권한이 없습니다."
        case .serverError: return "서버에 문제가 발생했습니다"
        case .parsingError: return "데이터 처리가 잘못됐습니다"
        }
    }
}

let baseUrl = "https://jkhi75xm0a.execute-api.ap-northeast-2.amazonaws.com/waffle/"
let memberUrl = baseUrl + "/members/"

struct WaffleNetwork {
    // API call to get list of members
    static func requestMembers(with urlString: String, done: @escaping ([Member]) -> (), failure: @escaping (NetworkError) -> ()) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 403 {
                        failure(.authError)
                        return
                    }
                }
                
                if error != nil {
                    failure(.serverError)
                    return
                }
                
                guard let data = data else {
                    failure(.serverError)
                    return
                }
                
                guard let memberList = memberListParser(data) else {
                    failure(.parsingError)
                    return
                }
                
                done(memberList)
            }
            
            task.resume()
        }
        
    }
    
    // API call to get certain profile data
    static func requestProfile(with urlString: String, done: @escaping (Member) -> (), failure: @escaping (NetworkError) -> ()) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 403 {
                        failure(.authError)
                        return
                    }
                }
                
                if error != nil {
                    failure(.serverError)
                    return
                }
                
                guard let data = data else {
                    failure(.serverError)
                    return
                }
                
                guard let memberProfile = memberProfileParser(data) else {
                    failure(.parsingError)
                    return
                }
                
                done(memberProfile)
            }
            
            task.resume()
        }
    }
    
    // parse list of members
    static func memberListParser(_ memberListData: Data) -> [Member]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MemberListResponseData.self, from: memberListData)
            
            return decodedData.body
            
        } catch _ {
            return nil
        }
    }
    
    // parse member profile
    static func memberProfileParser(_ memberProfileData: Data) -> Member? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MemberProfileResponseData.self, from: memberProfileData)
            
            return decodedData.body
        } catch _ {
            return nil
        }
    }
}

