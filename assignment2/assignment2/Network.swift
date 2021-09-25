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

let baseUrl = "https://jkhi75xm0a.execute-api.ap-northeast-2.amazonaws.com/waffle/"
let memberUrl = baseUrl + "/members/"

struct WaffleNetwork {
    static func request(with urlString: String, done: @escaping ([Member]) -> (), failure: @escaping () -> ()) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 403 {
                        failure()
                        return
                    }
                }
                
                if let error = error {
                    print(error)
                    failure()
                    return
                }
                
                guard let data = data else {
                    print("야야야")
                    failure()
                    return
                }
                
                guard let memberList = memberListParser(data) else {
                    print("야야야야")
                    failure()
                    return
                }
                
                done(memberList)
            }
            
            task.resume()
        }
        
    }
    
    static func requestProfile(with urlString: String, done: @escaping (Member) -> (), failure: @escaping () -> ()) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 403 {
                        failure()
                        return
                    }
                }
                
                if let error = error {
                    print(error)
                    failure()
                    return
                }
                
                guard let data = data else {
                    print("야야야")
                    failure()
                    return
                }
                
                guard let memberProfile = memberProfileParser(data) else {
                    print("야야야야")
                    failure()
                    return
                }
                
                done(memberProfile)
            }
            
            task.resume()
        }
    }
    
    static func memberListParser(_ memberListData: Data) -> [Member]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MemberListResponseData.self, from: memberListData)
            
            return decodedData.body
            
        } catch let error {
            print("error", error)
            return nil
        }
    }
    
    static func memberProfileParser(_ memberProfileData: Data) -> Member? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MemberProfileResponseData.self, from: memberProfileData)
            
            return decodedData.body
        } catch let error {
            print("error", error)
            return nil
        }
    }
}

//WaffleNetwork.request(with: memberUrl) { (memberList) in
//    print(memberList)
//} failure: {
//    print("error")
//}
